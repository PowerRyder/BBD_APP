import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { Subscription } from 'rxjs';
import { AppSettings } from 'src/app/app.settings';
import { SharedModule } from 'src/app/shared/shared.module';
import { SharedService } from 'src/app/shared/shared.service';
import { DetailsService } from '../services/details.service';
import { WithdrawService } from '../services/withdraw.service';
import { TokenSellHistoryComponent } from '../token-sell-history/token-sell-history.component';

@Component({
  selector: 'app-sell-tokens',
  standalone: true,
  imports: [SharedModule, TokenSellHistoryComponent],
  templateUrl: './sell-tokens.component.html',
  styleUrls: ['./sell-tokens.component.scss']
})
export class SellTokensComponent {

  userAddress = '';
  paymentCurrency = AppSettings.PaymentTokenSymbol;
  amounToSell = 0;
  paymentTokenAmount = 0;
  deductionPercentage = 5;
  amountReceived = 0;

  paymentTokenToInternalTokensRate = 0;
  
  internalTokenName = AppSettings.InternalTokenName;
  subscription: Subscription;

  internalTokenBalance = 0;
  constructor(private router: Router, private shared: SharedService, private withdraw: WithdrawService, private details: DetailsService){ }

  async ngOnInit(){
    this.userAddress = sessionStorage.getItem("UserAddress");
    // console.log((await this.details.getDashboardDetails(this.userAddress)).data.ContractBalance)
    this.paymentTokenToInternalTokensRate = (await this.details.getContractDetails()).data.InternalTokenRate;
    let dashboardDetails = (await this.details.getDashboardDetails(this.userAddress)).data;
    this.internalTokenBalance = dashboardDetails.InternalTokenBalance;
  }

  onAmountChange(){
    this.paymentTokenAmount = this.amounToSell/this.paymentTokenToInternalTokensRate;
    this.amountReceived = this.paymentTokenAmount-(this.paymentTokenAmount*this.deductionPercentage/100)
  }

  async onSellClick() {
    if (this.internalTokenBalance >= this.amounToSell) {
      let res = await this.withdraw.sellTokens(Number(this.amounToSell));
      // console.log("register", res)
      if (res && res.success) {
        this.shared.alert.trigger({action: 'success', message: 'Tokens sold successfully!'}).then(()=>{
          location.reload();
        });
      }
      else{
        this.shared.alert.trigger({action: 'error', message: res.message});
      }
    }
    else {
      this.shared.alert.trigger({ action: 'error', message: 'Insufficient token balance!' });
    }
  }

}
