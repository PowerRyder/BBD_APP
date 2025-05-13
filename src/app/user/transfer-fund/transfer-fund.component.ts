import { Component, OnDestroy, OnInit } from '@angular/core';
import { UntypedFormControl, UntypedFormGroup } from '@angular/forms';
import { SharedModule } from 'src/app/shared/shared.module';
import { FormsModule } from '@angular/forms';
import { DetailsService } from '../services/details.service';
import { SharedService } from 'src/app/shared/shared.service';
import { AppSettings } from 'src/app/app.settings';
import { Subscription } from 'rxjs';
import { AccountsService } from 'src/app/accounts/accounts.service';
import { RefreshService } from 'src/app/services/refresh.service';
import { WithdrawService } from '../services/withdraw.service';

@Component({
  selector: 'app-transfer-fund',
  standalone: true,
  imports: [SharedModule, FormsModule],
  templateUrl: './transfer-fund.component.html',
  styleUrls: ['./transfer-fund.component.scss']
})
export class TransferFundComponent implements OnInit {

  transferfundForm: UntypedFormGroup
  paymentCurrency = AppSettings.PaymentTokenSymbol;
  amountAvailableToSend: number = 0;
  // Fundsubscription: Subscription;
  maxAmount: number = 0;

  constructor(public shared: SharedService, private details: DetailsService, private accounts: AccountsService, private refresh: RefreshService, private withdrawService: WithdrawService) {
    this.createForm()

  }

  createForm() {
    this.transferfundForm = new UntypedFormGroup({
      userIdAddress: new UntypedFormControl({ value: '', disabled: false }, this.shared.validators.required),
      amount: new UntypedFormControl({ value: '', disabled: false }, this.shared.validators.required)
    })
  }

  async ngOnInit() {
    // this.Fundsubscription = this.accounts.accountChange.subscribe(async addr => {
    //   this.transferfundForm.controls['userAddress'].setValue(addr);
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
    if (this.transferfundForm.valid) {
      let from_address = sessionStorage.getItem("UserAddress")
      let to_address = this.transferfundForm.controls['userIdAddress'].value
      let amount = this.transferfundForm.controls['amount'].value
      let sendamount = this.accounts.contract.convertAmountToPaymentCurrencyBaseValue(amount)
      let result = await this.withdrawService.transferFund(from_address, to_address, sendamount)

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
