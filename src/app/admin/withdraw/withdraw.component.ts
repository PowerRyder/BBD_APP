import { Component } from '@angular/core';
import { AppSettings } from 'src/app/app.settings';
import { SharedModule } from 'src/app/shared/shared.module';
import { SharedService } from 'src/app/shared/shared.service';
import { AdminService } from '../admin.service';
import { Web3ContractService } from 'src/app/services/web3-contract.service';

@Component({
  selector: 'app-withdraw',
  standalone: true,
  imports: [SharedModule],
  templateUrl: './withdraw.component.html',
  styleUrls: ['./withdraw.component.scss']
})
export class WithdrawComponent {

  amount: number = 0;
  paymentToken = AppSettings.PaymentTokenSymbol;

  constructor(private shared: SharedService, private contract: AdminService, public web3: Web3ContractService){ }

  async onWithdrawClick(){

    let res = await this.contract.withdrawFunds(this.web3.convertAmountToPaymentCurrencyBaseValue(this.amount));
    // console.log("register", res)
    if (res && res.success) {
      this.shared.alert.trigger({action: 'success', message: 'Amount withdrawn successfully!'}).then(()=>{
        location.reload();
      });
    }
    else{
      this.shared.alert.trigger({action: 'error', message: res.message});
    }
  }

}
