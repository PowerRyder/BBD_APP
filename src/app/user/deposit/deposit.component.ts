import { Component, Input } from '@angular/core';
import { Router } from '@angular/router';
import { PackageDetails, WalletDetails } from 'src/app/accounts/models/accounts';
import { SharedService } from 'src/app/shared/shared.service';
import { DepositService } from '../services/deposit.service';
import { AppSettings } from 'src/app/app.settings';
import { DetailsService } from '../services/details.service';
import { SharedModule } from 'src/app/shared/shared.module';
import { DepositHistoryComponent } from '../deposit-history/deposit-history.component';
import { PackageComponent } from '../package/package.component';
import { RefreshService } from 'src/app/services/refresh.service';

@Component({
  selector: 'app-deposit',
  templateUrl: './deposit.component.html',
  standalone: true,
  imports: [SharedModule, PackageComponent, DepositHistoryComponent],
  styleUrls: ['./deposit.component.scss']
})
export class DepositComponent {

  @Input() showHistory: boolean = true;

  walletDetails: WalletDetails;
  packageDetails: PackageDetails;

  paymentCurrency = AppSettings.PaymentTokenSymbol;
  amountUsedToBuyTokens = 0;
  internalTokenAmount = 0;
  paymentTokenToInternalTokensRate = 0;
  
  isInternalToken = AppSettings.IsInternalToken;
  internalTokenName = AppSettings.InternalTokenName;

  constructor(private router: Router, private shared: SharedService, private deposit: DepositService, private details: DetailsService, private refresh: RefreshService){ }

  async ngOnInit(){
    this.paymentTokenToInternalTokensRate = (await this.details.getContractDetails()).data.InternalTokenRate;
  }

  accountCallback(data: WalletDetails) {
    this.walletDetails = data;
  }

  packageCallback(data: PackageDetails) {
    this.packageDetails = data;
    this.amountUsedToBuyTokens = this.packageDetails.amount*0.66;
    this.internalTokenAmount = this.amountUsedToBuyTokens*this.paymentTokenToInternalTokensRate;
  }

  async onDepositClick() {
    if (this.walletDetails.balance >= this.packageDetails.amount) {
      console.log(this.packageDetails)
      let res = await this.deposit.redeposit(Number(this.packageDetails.packageId), this.packageDetails.amount);
      // console.log("register", res)
      if (res && res.success) {
        this.shared.alert.trigger({action: 'success', message: 'Deposit successful!'}).then(()=>{
          this.refresh.refreshComponent();
        });
      }
      else{
        this.shared.alert.trigger({action: 'error', message: res.message});
      }
    }
    else {
      this.shared.alert.trigger({ action: 'error', message: 'Insufficient balance!' });
    }
  }

}
