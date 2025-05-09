import { Component } from '@angular/core';
import { AppSettings } from 'src/app/app.settings';
import { Web3ContractService } from 'src/app/services/web3-contract.service';
import { SharedModule } from 'src/app/shared/shared.module';
import { DetailsService } from '../services/details.service';

@Component({
  selector: 'app-level-income',
  standalone: true,
  imports: [SharedModule],
  templateUrl: './level-income.component.html',
  styleUrls: ['./level-income.component.scss']
})
export class LevelIncomeComponent {
  displayedColumns: string[] = ['Srno', 'Direct'];
  dataSource: any[] = []

  paymentCurrency = AppSettings.PaymentTokenSymbol;
  constructor(private details: DetailsService, private contract: Web3ContractService) { }

  async ngOnInit() {
    let res = (await this.details.getLevelIncome(sessionStorage.getItem('UserAddress'))).data;
    // console.log(res)

    for (let i = 0; i < res.length; i++) {
      let d = res[i];
      this.dataSource.push({ 
        Srno: i + 1, 
        Level: d.Level,
        RequiredSelfInvestment: this.contract.convertAmountFromPaymentCurrencyBaseValue(d.RequiredSelfInvestment),
        SelfInvestment: this.contract.convertAmountFromPaymentCurrencyBaseValue(d.SelfInvestment),
        RequiredNumberOfDirects: d.RequiredNumberOfDirects,
        DirectsCount: d.DirectsCount,
        RequiredDirectsInvestment: this.contract.convertAmountFromPaymentCurrencyBaseValue(d.RequiredDirectsInvestment),
        DirectsInvestment: this.contract.convertAmountFromPaymentCurrencyBaseValue(d.DirectsInvestment),
        RequiredNumberOfTeam: d.RequiredNumberOfTeam,
        TotalTeam: d.TotalTeam,
        RequiredTeamInvestment: this.contract.convertAmountFromPaymentCurrencyBaseValue(d.RequiredTeamInvestment),
        TeamInvestment: this.contract.convertAmountFromPaymentCurrencyBaseValue(d.TeamInvestment),
        OnAmount: this.contract.convertAmountFromPaymentCurrencyBaseValue(d.OnAmount),
        Percentage: d.Percentage/10,
        Income: this.contract.convertAmountFromPaymentCurrencyBaseValue(d.Income),
        IsLevelAchieved: d.IsLevelAchieved
      });
    }

    // console.log(this.dataSource)
  }

  isVisible(fieldName){
    return this.dataSource.some((elem)=> elem[fieldName]>0)
  }

}
