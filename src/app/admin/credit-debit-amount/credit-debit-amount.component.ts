import { Component, OnInit } from '@angular/core';
import { ReactiveFormsModule, UntypedFormControl, UntypedFormGroup, Validators } from '@angular/forms';
import { AccountsService } from 'src/app/accounts/accounts.service';
import { AppSettings } from 'src/app/app.settings';
import { Web3ContractService } from 'src/app/services/web3-contract.service';
import { SharedModule } from 'src/app/shared/shared.module';
import { SharedService } from 'src/app/shared/shared.service';
import { DetailsService } from 'src/app/user/services/details.service';
import { AdminService } from '../admin.service';
import { RefreshService } from 'src/app/services/refresh.service';

@Component({
  selector: 'app-credit-debit-amount',
  standalone: true,
  imports: [SharedModule, ReactiveFormsModule],
  templateUrl: './credit-debit-amount.component.html',
  styleUrls: ['./credit-debit-amount.component.scss']
})
export class CreditDebitAmountComponent implements OnInit {

  amountAvailableToSend: number = 0;
  paymentCurrency = AppSettings.PaymentTokenSymbol;
  paymentToken = AppSettings.PaymentTokenSymbol;

  creditdebitForm: UntypedFormGroup

  constructor(private shared: SharedService, private contract: AdminService, public web3: Web3ContractService, private details: DetailsService, private accounts: AccountsService, private refresh: RefreshService) { this.createform() }

  createform() {
    this.creditdebitForm = new UntypedFormGroup({
      userAddress: new UntypedFormControl({ value: '', disabled: false }),
      amount: new UntypedFormControl({ value: '', disabled: false }),
      selectedWallet: new UntypedFormControl({ value: 1, disabled: false })
    })
  }

  async ngOnInit() {
    this.creditdebitForm.get('userAddress')?.valueChanges.subscribe((address) => {
      if (this.isValidEthereumAddress(address)) {
        this.fetchBalance();
      } else {
        this.amountAvailableToSend = 0; 
      }
    });

    // Also listen to selectedWallet changes if needed
    this.creditdebitForm.get('selectedWallet')?.valueChanges.subscribe(() => {
      const address = this.creditdebitForm.get('userAddress')?.value;
      if (this.isValidEthereumAddress(address)) {
        this.fetchBalance();
      }
    });
    // this.fetchAndSetBalance()
    // this.creditdebitForm.get('selectedWallet')?.valueChanges.subscribe(() => {
    //   this.fetchBalance();
    // });
    // await this.fetchBalance()
  }

  isValidEthereumAddress(address: string): boolean {
    return /^0x[a-fA-F0-9]{40}$/.test(address);
  }


  async fetchBalance() {
    let _userAddress = this.creditdebitForm.controls['userAddress'].value
    let _selectwallet = this.creditdebitForm.controls['selectedWallet'].value
    if (!this.isValidEthereumAddress(_userAddress)) return;

    try {
      const res = await this.details.getwalletBalanceAmount(_userAddress, _selectwallet);
      const userBalances = res.data;
      if (userBalances) {
        this.amountAvailableToSend = this.accounts.contract.convertAmountFromPaymentCurrencyBaseValue(userBalances);
      }
    } catch (err) {
      console.error('Error fetching balance:', err);
      this.amountAvailableToSend = 0;
    }
    // let userBalances = (await this.details.getwalletBalanceAmount(_userAddress, _selectwallet)).data
    // if (userBalances) {
    //   this.amountAvailableToSend = this.accounts.contract.convertAmountFromPaymentCurrencyBaseValue(userBalances)
    // }
  }

  async onCreditClick() {
    let _userAddres = this.creditdebitForm.controls['userAddress'].value
    let _selectedWallet = this.creditdebitForm.controls['selectedWallet'].value

    let credit_amount = this.accounts.contract.convertAmountToPaymentCurrencyBaseValue(this.creditdebitForm.controls['amount'].value)

    let walletType = _selectedWallet === 1 ? 3 : _selectedWallet === 2 ? 8 : null;
    if (!walletType) {
      this.shared.alert.trigger({ action: 'error', message: 'Invalid wallet selection.' });
      return;
    }
    const res = await this.details.withdrawAmount(_userAddres, credit_amount, walletType);

    if (res && res.success) {
      this.shared.alert.trigger({ action: 'success', message: 'Credit successful' });
      this.refresh.refreshComponent();
    } else {
      this.shared.alert.trigger({ action: 'error', message: res?.message || 'Credit failed' });
    }


  }

  async onDebitClick() {
    let _userAddres = this.creditdebitForm.controls['userAddress'].value
    let _selectedWallet = this.creditdebitForm.controls['selectedWallet'].value
    let _enteredAmount = this.creditdebitForm.controls['amount'].value
    if (_enteredAmount <= this.amountAvailableToSend) {
      const debitAmount = this.accounts.contract.convertAmountToPaymentCurrencyBaseValue(_enteredAmount);
      let walletType = _selectedWallet === 1 ? 4 : _selectedWallet === 2 ? 9 : null;

      if (!walletType) {
        this.shared.alert.trigger({ action: 'error', message: 'Invalid wallet selection.' });
        return;
      }

      const res = await this.details.withdrawAmount(_userAddres, debitAmount, walletType);

      if (res && res.success) {
        this.shared.alert.trigger({ action: 'success', message: 'Debit successful' });
        this.amountAvailableToSend -= _enteredAmount; // 👈 This line subtracts from the available balance
        this.refresh.refreshComponent();
      } else {
        this.shared.alert.trigger({ action: 'error', message: res?.message || 'Debit failed' });
      }

    } else {
      this.shared.alert.trigger({ action: 'error', message: 'Insufficient Balance!' });
    }

  }


}
