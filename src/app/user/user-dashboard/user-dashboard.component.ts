import { Component, OnInit } from '@angular/core';
import { AppSettings, app_routes } from 'src/app/app.settings';
import { DetailsService } from '../services/details.service';
import { SharedModule } from 'src/app/shared/shared.module';
import { DepositComponent } from '../deposit/deposit.component';
import { DashboardTilesComponent } from 'src/app/shared/dashboard-tiles/dashboard-tiles.component';
import { ReferralLinkComponent } from '../referral-link/referral-link.component';

@Component({
  selector: 'app-user-dashboard',
  templateUrl: './user-dashboard.component.html',
  standalone: true,
  imports: [SharedModule, DepositComponent, DashboardTilesComponent, ReferralLinkComponent],
  styleUrls: ['./user-dashboard.component.scss']
})
export class UserDashboardComponent implements OnInit {

  userAddress: string = '';
  userDetails: any;
  dashboardDetails: any;

  referralLink: string = '';
  contractAddress: string = AppSettings.ContractAddress;
  addressExplorer: string = AppSettings.CHAIN.ExplorerUrl+'address/';

  paymentCurrency = AppSettings.PaymentTokenSymbol;
  isInternalToken = AppSettings.IsInternalToken;
  internalTokenName = AppSettings.InternalTokenName;
  constructor(private details: DetailsService){ }

  async ngOnInit() {
    this.userAddress = sessionStorage.getItem("UserAddress");
    let userDetails = (await this.details.getUserDetails(this.userAddress)).data;
    
    let dashboardDetails = Object.assign({}, (await this.details.getDashboardDetails(this.userAddress)).data);

    // console.log(userDetails, dashboardDetails)

    userDetails.Investment = this.details.contract.convertAmountFromPaymentCurrencyBaseValue(userDetails.Investment);
    userDetails.DirectsInvestment = this.details.contract.convertAmountFromPaymentCurrencyBaseValue(userDetails.DirectsInvestment);
    userDetails.TeamInvestment = this.details.contract.convertAmountFromPaymentCurrencyBaseValue(userDetails.TeamInvestment);
    
    dashboardDetails.ReferralIncome = this.details.contract.convertAmountFromPaymentCurrencyBaseValue(dashboardDetails.ReferralIncome);
    dashboardDetails.LevelIncome = this.details.contract.convertAmountFromPaymentCurrencyBaseValue(dashboardDetails.LevelIncome);
    dashboardDetails.WithdrawalLevelIncome = this.details.contract.convertAmountFromPaymentCurrencyBaseValue(dashboardDetails.WithdrawalLevelIncome);
    dashboardDetails.TotalIncome = this.details.contract.convertAmountFromPaymentCurrencyBaseValue(dashboardDetails.TotalIncome);
    dashboardDetails.AmountWithdrawn = this.details.contract.convertAmountFromPaymentCurrencyBaseValue(dashboardDetails.AmountWithdrawn);

    
    this.userDetails = userDetails;
    this.dashboardDetails = dashboardDetails;

    // console.log(this.userDetails, this.dashboardDetails)

    this.referralLink = AppSettings.Website+app_routes.register.url.slice(1)+'/'+this.userAddress;
  }

}
