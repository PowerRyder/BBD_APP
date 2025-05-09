import { Component } from '@angular/core';
import { AppSettings } from 'src/app/app.settings';
import { Web3ContractService } from 'src/app/services/web3-contract.service';
import { DashboardTilesComponent } from 'src/app/shared/dashboard-tiles/dashboard-tiles.component';
import { SharedModule } from 'src/app/shared/shared.module';
import { ReferralLinkComponent } from 'src/app/user/referral-link/referral-link.component';
import { DetailsService } from 'src/app/user/services/details.service';

@Component({
  selector: 'app-admin-dashboard',
  templateUrl: './admin-dashboard.component.html',
  standalone: true,
  imports: [SharedModule, DashboardTilesComponent, ReferralLinkComponent],
  styleUrls: ['./admin-dashboard.component.scss']
})
export class AdminDashboardComponent {

  contractAddress: string = AppSettings.ContractAddress;
  addressExplorer: string = AppSettings.CHAIN.ExplorerUrl+'address/';

  paymentCurrency = AppSettings.PaymentTokenSymbol;
  isInternalToken = AppSettings.IsInternalToken;
  internalTokenName = AppSettings.InternalTokenName;

  contractDetails: any;
  constructor(private details: DetailsService, private web3: Web3ContractService){ }

  ngOnInit(){
    this.getData();
  }

  async getData() {
    let contractDetails = Object.assign({}, (await this.details.getContractDetails()).data);

    contractDetails.CommunityInvestment = this.web3.convertAmountFromPaymentCurrencyBaseValue(contractDetails.CommunityInvestment);
    contractDetails.CommunityWithdrawal = this.web3.convertAmountFromPaymentCurrencyBaseValue(contractDetails.CommunityWithdrawal);
    contractDetails.ContractBalance = this.web3.convertAmountFromPaymentCurrencyBaseValue(contractDetails.ContractBalance);
    contractDetails.InternalTokenLiquidity = this.web3.convertAmountFromPaymentCurrencyBaseValue(contractDetails.InternalTokenLiquidity);
    contractDetails.InternalTokenRate = (1/contractDetails.InternalTokenRate).toFixed(8);

    console.log(contractDetails)
    this.contractDetails = contractDetails;
  }
}
