import { Component, OnInit } from '@angular/core';
import { AppSettings, app_routes } from 'src/app/app.settings';
import { DetailsService } from '../services/details.service';
import { SharedModule } from 'src/app/shared/shared.module';
import { DepositComponent } from '../deposit/deposit.component';
import { DashboardTilesComponent } from 'src/app/shared/dashboard-tiles/dashboard-tiles.component';
import { ReferralLinkComponent } from '../referral-link/referral-link.component';
import { ReActivationComponent } from '../re-activation/re-activation.component';
import { NgxGaugeModule } from 'ngx-gauge';

@Component({
  selector: 'app-user-dashboard',
  templateUrl: './user-dashboard.component.html',
  standalone: true,
  imports: [SharedModule, DepositComponent, DashboardTilesComponent, ReferralLinkComponent, ReActivationComponent, NgxGaugeModule],
  styleUrls: ['./user-dashboard.component.scss']
})
export class UserDashboardComponent implements OnInit {

  userAddress: string = '';
  // userDetails: any;
  dashboardDetails: any;

  referralLink: string = '';
  contractAddress: string = AppSettings.ContractAddress;
  addressExplorer: string = AppSettings.CHAIN.ExplorerUrl + 'address/';

  paymentCurrency = AppSettings.PaymentTokenSymbol;
  isInternalToken = AppSettings.IsInternalToken;
  internalTokenName = AppSettings.InternalTokenName;

  guageThresholdConfig = {
        '0': {color: 'green'},
        '40': {color: 'orange'},
        '75.5': {color: 'red'}
    };
  constructor(private details: DetailsService) { }

  async ngOnInit() {
    this.userAddress = sessionStorage.getItem("UserAddress");
    let dashboardDetails = Object.assign({}, (await this.details.getDashboardDetails(this.userAddress)).data);

    // console.log(userDetails, dashboardDetails)

    dashboardDetails.Investment = this.details.contract.convertAmountFromPaymentCurrencyBaseValue(dashboardDetails.Investment);
    dashboardDetails.InvestmentBadge = ((dashboardDetails?.TotalIncome <= dashboardDetails?.Investment && dashboardDetails?.Investment > 0) ? (dashboardDetails?.TotalIncome * 100 / dashboardDetails?.Investment) : 100).toFixed(1) + '%';

    // dashboardDetails.DirectsCountBadge = ((dashboardDetails?.TeamCount > 0) ? (dashboardDetails?.DirectsCount * 100 / dashboardDetails?.TeamCount) : 100).toFixed(1) + '%';

    dashboardDetails.DirectsInvestment = this.details.contract.convertAmountFromPaymentCurrencyBaseValue(dashboardDetails.DirectsInvestment);
    dashboardDetails.TeamA_Business = this.details.contract.convertAmountFromPaymentCurrencyBaseValue(dashboardDetails.TeamA_Business);
    dashboardDetails.TeamB_Business = this.details.contract.convertAmountFromPaymentCurrencyBaseValue(dashboardDetails.TeamB_Business);
    dashboardDetails.TeamInvestment = this.details.contract.convertAmountFromPaymentCurrencyBaseValue(dashboardDetails.TeamInvestment);

    // dashboardDetails.DirectsInvestmentBadge = ((dashboardDetails?.DirectsInvestment <= dashboardDetails?.TeamInvestment && dashboardDetails?.TeamInvestment > 0) ? (dashboardDetails?.DirectsInvestment * 100 / dashboardDetails?.TeamInvestment) : 100).toFixed(1) + '%';

    // dashboardDetails.TeamInvestmentBadge = (dashboardDetails?.DirectsInvestment).toFixed(1);

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

    dashboardDetails.WithdrawalWalletBalance = this.details.contract.convertAmountFromPaymentCurrencyBaseValue(dashboardDetails.WithdrawalWalletBalance);
    dashboardDetails.TopupWalletBalance = this.details.contract.convertAmountFromPaymentCurrencyBaseValue(dashboardDetails.TopupWalletBalance);


    // 1. Deposit Badge (Earnings %)
    dashboardDetails.InvestmentBadge = (dashboardDetails?.Investment > 0)
      ? ((dashboardDetails.TotalIncome * 100) / dashboardDetails.Investment).toFixed(1)
      : '100';

    // 2. Directs Count Badge (Directs % of Team)
    dashboardDetails.DirectsCountBadge = (dashboardDetails?.TeamCount > 0)
      ? ((dashboardDetails.DirectsCount * 100) / dashboardDetails.TeamCount).toFixed(1)
      : '100';

    // 3. Directs Investment Badge (% of Team Investment)
    dashboardDetails.DirectsInvestmentBadge = (dashboardDetails?.TeamInvestment > 0)
      ? ((dashboardDetails.DirectsInvestment * 100) / dashboardDetails.TeamInvestment).toFixed(1)
      : '100';

    // 4. Team A Contribution Badge
    dashboardDetails.TeamA_Badge = (dashboardDetails?.TeamInvestment > 0)
      ? ((dashboardDetails.TeamA_Business * 100) / dashboardDetails.TeamInvestment).toFixed(1)
      : '0';

    // 5. Team B Contribution Badge
    dashboardDetails.TeamB_Badge = (dashboardDetails?.TeamInvestment > 0)
      ? ((dashboardDetails.TeamB_Business * 100) / dashboardDetails.TeamInvestment).toFixed(1)
      : '0';

    // 6. Team Business Badge (Directs Investment % of Team Business)
    dashboardDetails.TeamInvestmentBadge = (dashboardDetails?.TeamInvestment > 0)
      ? ((dashboardDetails.DirectsInvestment * 100) / dashboardDetails.TeamInvestment).toFixed(1)
      : '100';

    // 7. New Registration Bonus per Direct
    dashboardDetails.RegistrationBonusBadge = (dashboardDetails?.DirectsCount > 0)
      ? (dashboardDetails.NewRegistrationBonus * 100 / dashboardDetails.TotalIncome).toFixed(1)
      : '0';

    // 8. ROI Income Contribution Badge
    dashboardDetails.RoiIncomeBadge = (dashboardDetails?.TotalIncome > 0)
      ? ((dashboardDetails.ROIIncome * 100) / dashboardDetails.TotalIncome).toFixed(1)
      : '0';

    // 9. Level Income Contribution Badge
    dashboardDetails.LevelIncomeBadge = (dashboardDetails?.TotalIncome > 0)
      ? ((dashboardDetails.LevelIncome * 100) / dashboardDetails.TotalIncome).toFixed(1)
      : '0';

    // 10. Rank Income Contribution Badge
    dashboardDetails.RankIncomeBadge = (dashboardDetails?.TotalIncome > 0)
      ? ((dashboardDetails.RankIncome * 100) / dashboardDetails.TotalIncome).toFixed(1)
      : '0';

    // 11. Topmost Sponsors Income Contribution Badge
    dashboardDetails.TopmostSponsorsBadge = (dashboardDetails?.TotalIncome > 0)
      ? ((dashboardDetails.TopmostSponsorsIncome * 100) / dashboardDetails.TotalIncome).toFixed(1)
      : '0';

    // 12. Pending ROI Badge
    dashboardDetails.PendingRoiBadge = (dashboardDetails?.ROIIncome > 0)
      ? ((dashboardDetails.PendingROIIncome * 100) / dashboardDetails.ROIIncome).toFixed(1)
      : '0';

    // 13. Capping Badge (How much cap is used)
    dashboardDetails.CappingUsedBadge = (dashboardDetails?.Capping > 0)
      ? ((dashboardDetails.TotalIncome * 100) / dashboardDetails.Capping).toFixed(1)
      : '0';

    // 14. Withdrawn Badge
    dashboardDetails.WithdrawnBadge = (dashboardDetails?.TotalIncome > 0)
      ? ((dashboardDetails.AmountWithdrawn * 100) / dashboardDetails.TotalIncome).toFixed(1)
      : '0';


    dashboardDetails.TotalIncomeBadge = (dashboardDetails?.Capping > 0)
      ? ((dashboardDetails.TotalIncome * 100) / dashboardDetails.Capping).toFixed(1)
      : '0';
    // let userDetails = (await this.details.getUserDetails(this.userAddress)).data;

    // this.userDetails = userDetails;
    this.dashboardDetails = dashboardDetails;

    // console.log(this.userDetails, this.dashboardDetails)

    this.referralLink = AppSettings.Website + app_routes.register.url.slice(1) + '/' + this.userAddress;
  }

}
