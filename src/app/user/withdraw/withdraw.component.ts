import { Component, OnInit } from '@angular/core';
import { UntypedFormControl, UntypedFormGroup } from '@angular/forms';
import { Subscription } from 'rxjs';
import { AccountsService } from 'src/app/accounts/accounts.service';
import { AppSettings } from 'src/app/app.settings';
import { SharedService } from 'src/app/shared/shared.service';
import { DetailsService } from '../services/details.service';
import { WithdrawService } from '../services/withdraw.service';
import { SharedModule } from 'src/app/shared/shared.module';
import { WithdrawalHistoryComponent } from '../withdrawal-history/withdrawal-history.component';

@Component({
  selector: 'app-withdraw',
  templateUrl: './withdraw.component.html',
  standalone: true,
  imports: [SharedModule, WithdrawalHistoryComponent],
  styleUrls: ['./withdraw.component.scss']
})
export class WithdrawComponent implements OnInit {

  withdrawForm = new UntypedFormGroup({
    userAddress: new UntypedFormControl({ value: '', disabled: true }, this.shared.validators.required),
    amount: new UntypedFormControl({ value: '', disabled: false }, this.shared.validators.required)
  });

  subscription: Subscription;

  amountAvailableToWithdraw: number = 0;
  paymentCurrency = AppSettings.PaymentTokenSymbol;

  minAmount: number = 0;
  maxAmount: number = 0;

  deductionPercentage: number = 10;
  deductionAmount: number = 0;
  receivingAmount: number = 0;

  constructor(private shared: SharedService, private accounts: AccountsService, private details: DetailsService, private withdraw: WithdrawService) { }

  async ngOnInit() {

    this.subscription = this.accounts.accountChange.subscribe(async addr => {
      this.withdrawForm.controls['userAddress'].setValue(addr);
    })

    setTimeout(async () => {
      await this.onConnectWalletClick();
    }, 100);

    let details = (await this.details.getDashboardDetails(sessionStorage.getItem('UserAddress')!)).data;
    if (details) {
      this.amountAvailableToWithdraw = this.accounts.contract.convertAmountFromPaymentCurrencyBaseValue(details.TotalIncome - details.AmountWithdrawn);
      this.maxAmount = this.amountAvailableToWithdraw;
    }

  }

  async onConnectWalletClick() {
    await this.accounts.connectWallet();
  }

  async onMaxClick() {
    this.withdrawForm.controls['amount'].setValue(this.maxAmount);
    this.onAmountChange();
  }

  onAmountChange(){
    let amount = Number(this.withdrawForm.controls['amount'].value);
    this.deductionAmount = amount*this.deductionPercentage/100;
    this.receivingAmount = amount-this.deductionAmount;
  }

  async onWithdrawClick() {
    if (this.withdrawForm.valid) {
      let res = await this.withdraw.withdrawIncome(Number(this.withdrawForm.controls['amount'].value));
      // console.log("register", res)
      if (res && res.success) {
        this.shared.alert.trigger({ action: 'success', message: 'Withdrawal successful!' }).then(() => {
          location.reload();
        });
      }
      else {
        this.shared.alert.trigger({ action: 'error', message: res.message });
      }
    }
    else {
      this.shared.alert.trigger({ action: 'error', message: 'Insufficient balance!' });
    }
  }

}
