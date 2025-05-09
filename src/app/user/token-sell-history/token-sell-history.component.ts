import { Component } from '@angular/core';
import { PageEvent } from '@angular/material/paginator';
import { AppSettings } from 'src/app/app.settings';
import { Web3ContractService } from 'src/app/services/web3-contract.service';
import { SharedModule } from 'src/app/shared/shared.module';
import { SharedService } from 'src/app/shared/shared.service';
import { DepositService } from '../services/deposit.service';
import { DetailsService } from '../services/details.service';

@Component({
  selector: 'app-token-sell-history',
  standalone: true,
  imports: [SharedModule],
  templateUrl: './token-sell-history.component.html',
  styleUrls: ['./token-sell-history.component.scss']
})
export class TokenSellHistoryComponent {

  userAddress: string = '';
  displayedColumns: string[] = ['Srno', 'Direct'];
  dataSource: any[] = []

  paymentCurrency = AppSettings.PaymentTokenSymbol;
  internalTokenName = AppSettings.InternalTokenName;

  data_count = 0;
  pageEvent: PageEvent;
  pageSizeOptions = AppSettings.pageSizeOptions;
  defaultPageSize: number = AppSettings.pageDefaultSize;
  showFirstLastButtons = AppSettings.matPaginatorShowFirstLastButtons;

  constructor(private details: DetailsService, private contract: Web3ContractService, private shared: SharedService) { }

  async ngOnInit() {
    this.userAddress = sessionStorage.getItem('UserAddress');
    this.getData();
  }

  async getData(){
    let res = (await this.details.getTokenSellHistory(this.userAddress, this.pageEvent?this.pageEvent.pageIndex:1, this.pageEvent?this.pageEvent.pageSize:this.defaultPageSize)).data;
    console.log(res)

    for (let i = 0; i < res.length; i++) {
      let d = res[i];
      this.dataSource.push({ 
        Srno: i + 1, 
        InternalTokenAmount: d.TokenAmount,
        Amount: this.contract.convertAmountFromPaymentCurrencyBaseValue(d.PaymentTokenAmount),
        Rate: d.Rate,
        Timestamp: this.shared.convertTimestampToDate(d.Timestamp)
      });
    }

    let res_cnt = (await this.details.getTransactionCount(this.userAddress)).data;
    // console.log(res_cnt)
    this.data_count = res_cnt.TokenSellCount;
  }

  async onPageChange(event) {
    this.pageEvent = event;
    this.getData();
  }

}
