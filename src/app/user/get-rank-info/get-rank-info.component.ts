import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AppSettings } from 'src/app/app.settings';
import { Web3ContractService } from 'src/app/services/web3-contract.service';
import { DetailsService } from '../services/details.service';
import { SharedModule } from 'src/app/shared/shared.module';

@Component({
  selector: 'app-get-rank-info',
  standalone: true,
  imports: [SharedModule],
  templateUrl: './get-rank-info.component.html',
  styleUrls: ['./get-rank-info.component.scss']
})
export class GetRankInfoComponent {

  displayedColumns: string[] = ['Srno', 'Direct'];
  dataSource: any[] = []

  paymentCurrency = AppSettings.PaymentTokenSymbol;
  constructor(private details: DetailsService, private contract: Web3ContractService) { }

  async ngOnInit() {
    let res = (await this.details.getRankInfo(sessionStorage.getItem('UserAddress'))).data;
    console.log(res)

    for (let i = 0; i < res.length; i++) {
      let d = res[i];
      this.dataSource.push({
        RankId: d.RankId,
        RankName: d.RankName,
        ReqSelfInvestment: this.contract.convertAmountFromPaymentCurrencyBaseValue(d.ReqSelfInvestment),
        ReqTeamA_Business: this.contract.convertAmountFromPaymentCurrencyBaseValue(d.ReqTeamA_Business),
        ReqTeamB_Business: this.contract.convertAmountFromPaymentCurrencyBaseValue(d.ReqTeamB_Business),
        UserSelfInvestment:this.contract.convertAmountFromPaymentCurrencyBaseValue(d.UserSelfInvestment),
        UserTeamA_Business:this.details.contract.convertAmountFromPaymentCurrencyBaseValue(d.UserTeamA_Business),
        UserTeamB_Business:this.details.contract.convertAmountFromPaymentCurrencyBaseValue(d.UserTeamB_Business),
        RewardAmount : this.details.contract.convertAmountFromPaymentCurrencyBaseValue(d.RewardAmount),
        IsAchieved:d.IsAchieved
      });
    }
  }

  isVisible(fieldName) {
    return this.dataSource.some((elem) => elem[fieldName] > 0)
  }
}
