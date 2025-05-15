import { Component, OnInit } from '@angular/core';
import { AppSettings } from 'src/app/app.settings';
import { SharedModule } from 'src/app/shared/shared.module';
import { SharedService } from 'src/app/shared/shared.service';
import { AdminService } from '../admin.service';
import { Web3ContractService } from 'src/app/services/web3-contract.service';
import { DetailsService } from 'src/app/user/services/details.service';
import { AccountsService } from 'src/app/accounts/accounts.service';

@Component({
  selector: 'app-credit-debit-amount',
  standalone: true,
  imports: [SharedModule],
  templateUrl: './credit-debit-amount.component.html',
  styleUrls: ['./credit-debit-amount.component.scss']
})
export class CreditDebitAmountComponent implements OnInit {

  // 0xb7f746040b00Fdc0bd95a9D821Bc38A48e00b064
  userAddress: string = '';
  amount: number = 0;
  selectedWallet = 1;
  amountAvailableToSend: number = 0;
  paymentCurrency = AppSettings.PaymentTokenSymbol;
  paymentToken = AppSettings.PaymentTokenSymbol;

  constructor(private shared: SharedService, private contract: AdminService, public web3: Web3ContractService, private details: DetailsService, private accounts: AccountsService) { }

  ngOnInit(): void {
    this.fetchAndSetBalance()
  }

  async fetchAndSetBalance() {
    const userAddress = sessionStorage.getItem('UserAddress');
    if (userAddress) {
      let balances = (await this.details.getwalletBalanceAmount(userAddress, 2)).data;
      if (balances) {
        this.amountAvailableToSend = this.accounts.contract.convertAmountFromPaymentCurrencyBaseValue(balances);
      }
    }
  }

  async onCreditClick() {
    // console.log('Selected User:', this.userAddress);
    // console.log('Selected Wallet:', this.selectedWallet);
    // console.log('Amount:', this.amount);
    const credit_amount = this.accounts.contract.convertAmountToPaymentCurrencyBaseValue(this.amount)
    if (this.selectedWallet = 1) {
      this.details.withdrawAmount(this.userAddress, credit_amount, 3)
      location.reload()
    }
    else if (this.selectedWallet = 2) {
      this.details.withdrawAmount(this.userAddress, credit_amount, 8)
      location.reload()
    } else {
      this.shared.alert.trigger({ action: 'error', message: 'Invalid wallet selection.' });
    }

  }

  async onDebitClick() {
    // console.log("okay")
    if (this.amount <= this.amountAvailableToSend) {
      // console.log("Amount", this.amount)
      const credit_amount = this.accounts.contract.convertAmountToPaymentCurrencyBaseValue(this.amount)
      if (this.selectedWallet = 1) {

        this.details.withdrawAmount(this.userAddress, credit_amount, 3)
        location.reload()
      }
      else if (this.selectedWallet = 2) {
        this.details.withdrawAmount(this.userAddress, credit_amount, 8)
        location.reload()
      } else {
        this.shared.alert.trigger({ action: 'error', message: 'Invalid wallet selection.' });
      }
    } else {
    
      this.shared.alert.trigger({ action: 'error', message: 'Insufficient Balances !' })
      // console.log("Insufficient Balances !")
    }
  }


  // async onCreditClick() {

  //   let res = await this.contract.creditAmount(this.userAddress, this.web3.convertAmountToPaymentCurrencyBaseValue(this.amount));
  //   // console.log("register", res)
  //   if (res && res.success) {
  //     this.shared.alert.trigger({ action: 'success', message: 'Amount credited successfully!' }).then(() => {
  //       location.reload();
  //     });
  //   }
  //   else {
  //     this.shared.alert.trigger({ action: 'error', message: res.message });
  //   }
  // }

  // async onDebitClick() {

  //   let res = await this.contract.debitAmount(this.userAddress, this.web3.convertAmountToPaymentCurrencyBaseValue(this.amount));
  //   // console.log("register", res)
  //   if (res && res.success) {
  //     this.shared.alert.trigger({ action: 'success', message: 'Amount debited successfully!' }).then(() => {
  //       location.reload();
  //     });
  //   }
  //   else {
  //     this.shared.alert.trigger({ action: 'error', message: res.message });
  //   }
  // }
}
