import { Component } from '@angular/core';
import { AppSettings } from 'src/app/app.settings';
import { Web3ContractService } from 'src/app/services/web3-contract.service';
import { SharedModule } from 'src/app/shared/shared.module';
import { DetailsService } from '../services/details.service';
import { PageEvent } from '@angular/material/paginator';
import { DepositService } from '../services/deposit.service';
import { SharedService } from 'src/app/shared/shared.service';

@Component({
  selector: 'app-deposit-history',
  standalone: true,
  imports: [SharedModule],
  templateUrl: './deposit-history.component.html',
  styleUrls: ['./deposit-history.component.scss']
})
export class DepositHistoryComponent {

  userAddress: string = '';
  displayedColumns: string[] = ['Srno', 'Direct'];
  dataSource: any[] = []
  packages: any[] = []

  paymentCurrency = AppSettings.PaymentTokenSymbol;
  isInternalToken = AppSettings.IsInternalToken;
  internalTokenName = AppSettings.InternalTokenName;

  data_count = 0;
  pageEvent: PageEvent;
  pageSizeOptions = AppSettings.pageSizeOptions;
  defaultPageSize: number = AppSettings.pageDefaultSize;
  showFirstLastButtons = AppSettings.matPaginatorShowFirstLastButtons;

  constructor(private deposit: DepositService, private details: DetailsService, private contract: Web3ContractService, private shared: SharedService) { }

  async ngOnInit() {
    this.userAddress = sessionStorage.getItem('UserAddress');
    this.getData();
  }

  async getData(){
    this.packages = (await this.deposit.getPackages()).data;
    
    // console.log(this.packages)
    let res = (await this.details.getDepositHistory(this.userAddress, this.pageEvent?this.pageEvent.pageIndex:1, this.pageEvent?this.pageEvent.pageSize:this.defaultPageSize)).data;
    // console.log(res)

    for (let i = 0; i < res.length; i++) {
      let d = res[i];
      this.dataSource.push({ 
        Srno: i + 1, 
        PackageName: this.getPackageNameFromId(d.PackageId),
        Amount: this.contract.convertAmountFromPaymentCurrencyBaseValue(d.Amount),
        InternalTokenAmount: d.InternalTokenAmount,
        Rate: d.Rate,
        Timestamp: this.shared.convertTimestampToDate(d.Timestamp)
      });
    }

    let res_cnt = (await this.details.getTransactionCount(this.userAddress)).data;
    // console.log(res_cnt)
    this.data_count = res_cnt.DepositsCount;
  }

  getPackageNameFromId(id: number){
    return (this.packages.filter((elem)=>elem.PackageId==id)[0]).Name;
  }

  isVisible(fieldName){
    return this.dataSource.some((elem)=> elem[fieldName]>0)
  }

  async onPageChange(event) {
    this.pageEvent = event;
    this.getData();
  }

}
