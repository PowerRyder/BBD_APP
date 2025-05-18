import { Component } from '@angular/core';
import { FormsModule, UntypedFormControl, UntypedFormGroup } from '@angular/forms';
import { AccountsService } from 'src/app/accounts/accounts.service';
import { AppSettings } from 'src/app/app.settings';
import { RefreshService } from 'src/app/services/refresh.service';
import { SharedModule } from 'src/app/shared/shared.module';
import { SharedService } from 'src/app/shared/shared.service';
import { DepositService } from '../services/deposit.service';
import { DetailsService } from '../services/details.service';

@Component({
  selector: 'app-topup',
  standalone: true,
  imports: [SharedModule, FormsModule],
  templateUrl: './topup.component.html',
  styleUrls: ['./topup.component.scss']
})
export class TopupComponent {

  topupForm: UntypedFormGroup
  paymentCurrency = AppSettings.PaymentTokenSymbol;
  amountAvailableToSend: number = 0;
  // Fundsubscription: Subscription;
  maxAmount: number = 0;

  constructor(public shared: SharedService, private details: DetailsService, private accounts: AccountsService, private refresh: RefreshService, private depositService: DepositService) {
    this.createForm()

  }

  createForm() {
    this.topupForm = new UntypedFormGroup({
      userIdAddress: new UntypedFormControl({ value: '', disabled: false }, this.shared.validators.required),
      amount: new UntypedFormControl({ value: '', disabled: false }, this.shared.validators.required)
    })
  }

  async ngOnInit() {
    // this.Fundsubscription = this.accounts.accountChange.subscribe(async addr => {
    //   this.topupForm.controls['userAddress'].setValue(addr);
    //   await this.fetchAndSetBalance();
    // })
    await this.fetchAndSetBalance();

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

  async onSubmit() {
    if (this.topupForm.valid) {
      let from_address = sessionStorage.getItem("UserAddress")
      let to_address = this.topupForm.controls['userIdAddress'].value
      let amount = this.topupForm.controls['amount'].value
      let sendamount = this.accounts.contract.convertAmountToPaymentCurrencyBaseValue(amount)
      let result = await this.depositService.topup(1, sendamount)

      // console.log("result", result)

      if (result && result.success) {
        await this.fetchAndSetBalance()
        this.shared.alert.trigger({ action: 'success', message: 'Transfer successful!' }).then(() => {
          // location.reload();
          this.refresh.refreshComponent();
        });
      }
      else {
        this.shared.alert.trigger({ action: 'error', message: result.message });
      }
    }
    else {
      this.shared.alert.trigger({ action: 'error', message: 'Insufficient balance!' });
    }

  }
}
