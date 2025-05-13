import { Component, OnInit } from '@angular/core';
import { AppSettings, app_routes } from 'src/app/app.settings';
import { DetailsService } from '../services/details.service';
import { SharedModule } from 'src/app/shared/shared.module';
import { DepositComponent } from '../deposit/deposit.component';
import { DashboardTilesComponent } from 'src/app/shared/dashboard-tiles/dashboard-tiles.component';
import { ReferralLinkComponent } from '../referral-link/referral-link.component';
import { ReActivationComponent } from '../re-activation/re-activation.component';

@Component({
  selector: 'app-user-dashboard',
  templateUrl: './user-dashboard.component.html',
  standalone: true,
  imports: [SharedModule, DepositComponent, DashboardTilesComponent, ReferralLinkComponent, ReActivationComponent],
  styleUrls: ['./user-dashboard.component.scss']
})
export class UserDashboardComponent implements OnInit {

  userAddress: string = '';
  // userDetails: any;
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
    let dashboardDetails = Object.assign({}, (await this.details.getDashboardDetails(this.userAddress)).data);

    // console.log(userDetails, dashboardDetails)

    dashboardDetails.Investment = this.details.contract.convertAmountFromPaymentCurrencyBaseValue(dashboardDetails.Investment);

    dashboardDetails.DirectsInvestment = this.details.contract.convertAmountFromPaymentCurrencyBaseValue(dashboardDetails.DirectsInvestment);
    dashboardDetails.TeamInvestment = this.details.contract.convertAmountFromPaymentCurrencyBaseValue(dashboardDetails.TeamInvestment);
    dashboardDetails.ReferralIncome = this.details.contract.convertAmountFromPaymentCurrencyBaseValue(dashboardDetails.ReferralIncome);
    dashboardDetails.NewRegistrationBonus = this.details.contract.convertAmountFromPaymentCurrencyBaseValue(dashboardDetails.NewRegistrationBonus);
    dashboardDetails.ROIIncome = this.details.contract.convertAmountFromPaymentCurrencyBaseValue(dashboardDetails.ROIIncome);
    dashboardDetails.RankIncome = this.details.contract.convertAmountFromPaymentCurrencyBaseValue(dashboardDetails.RankIncome);
    dashboardDetails.TopmostSponsorsIncome = this.details.contract.convertAmountFromPaymentCurrencyBaseValue(dashboardDetails.TopmostSponsorsIncome);
    dashboardDetails.LevelIncome = this.details.contract.convertAmountFromPaymentCurrencyBaseValue(dashboardDetails.LevelIncome);
    dashboardDetails.PendingROIIncome = this.details.contract.convertAmountFromPaymentCurrencyBaseValue(dashboardDetails.PendingROIIncome);
    dashboardDetails.TotalIncome = this.details.contract.convertAmountFromPaymentCurrencyBaseValue(dashboardDetails.TotalIncome);
    dashboardDetails.Capping = this.details.contract.convertAmountFromPaymentCurrencyBaseValue(dashboardDetails.Capping);
    dashboardDetails.AmountWithdrawn = this.details.contract.convertAmountFromPaymentCurrencyBaseValue(dashboardDetails.AmountWithdrawn);

    
    // let userDetails = (await this.details.getUserDetails(this.userAddress)).data;
    
    // this.userDetails = userDetails;
    this.dashboardDetails = dashboardDetails;

    // console.log(this.userDetails, this.dashboardDetails)

    this.referralLink = AppSettings.Website+app_routes.register.url.slice(1)+'/'+this.userAddress;
  }

}
