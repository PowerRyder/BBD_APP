import { Component, OnInit } from '@angular/core';
import { DetailsService } from '../services/details.service';
import { Web3ContractService } from 'src/app/services/web3-contract.service';
import { AppSettings } from 'src/app/app.settings';
import { SharedModule } from 'src/app/shared/shared.module';

@Component({
  selector: 'app-directs',
  templateUrl: './directs.component.html',
  standalone: true,
  imports: [SharedModule],
  styleUrls: ['./directs.component.scss']
})
export class DirectsComponent implements OnInit {
  displayedColumns: string[] = ['Srno', 'Direct'];
  dataSource: any[] = []

  paymentCurrency = AppSettings.PaymentTokenSymbol;
  constructor(private details: DetailsService, private contract: Web3ContractService) { }

  async ngOnInit() {
    let res = (await this.details.getDirects(sessionStorage.getItem('UserAddress'))).data;
    console.log(res)

    for (let i = 0; i < res.length; i++) {
      this.dataSource.push({ Srno: i + 1, Direct: res[i].Address, Investment: this.contract.convertAmountFromPaymentCurrencyBaseValue(res[i].Investment), Business: this.contract.convertAmountFromPaymentCurrencyBaseValue(res[i].Business) });
    }

    console.log(this.dataSource)
  }


}
