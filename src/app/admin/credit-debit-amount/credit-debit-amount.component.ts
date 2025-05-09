import { Component } from '@angular/core';
import { AppSettings } from 'src/app/app.settings';
import { SharedModule } from 'src/app/shared/shared.module';
import { SharedService } from 'src/app/shared/shared.service';
import { AdminService } from '../admin.service';
import { Web3ContractService } from 'src/app/services/web3-contract.service';

@Component({
  selector: 'app-credit-debit-amount',
  standalone: true,
  imports: [SharedModule],
  templateUrl: './credit-debit-amount.component.html',
  styleUrls: ['./credit-debit-amount.component.scss']
})
export class CreditDebitAmountComponent {

  userAddress: string = '';
  amount: number = 0;
  paymentToken = AppSettings.PaymentTokenSymbol;

  constructor(private shared: SharedService, private contract: AdminService, public web3: Web3ContractService){ }

  async onCreditClick(){

    let res = await this.contract.creditAmount(this.userAddress, this.web3.convertAmountToPaymentCurrencyBaseValue(this.amount));
    // console.log("register", res)
    if (res && res.success) {
      this.shared.alert.trigger({action: 'success', message: 'Amount credited successfully!'}).then(()=>{
        location.reload();
      });
    }
    else{
      this.shared.alert.trigger({action: 'error', message: res.message});
    }
  }

  async onDebitClick(){

    let res = await this.contract.debitAmount(this.userAddress, this.web3.convertAmountToPaymentCurrencyBaseValue(this.amount));
    // console.log("register", res)
    if (res && res.success) {
      this.shared.alert.trigger({action: 'success', message: 'Amount debited successfully!'}).then(()=>{
        location.reload();
      });
    }
    else{
      this.shared.alert.trigger({action: 'error', message: res.message});
    }
  }
}
