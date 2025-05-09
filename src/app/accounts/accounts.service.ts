import { Injectable } from '@angular/core';
import { NgxSpinnerService } from 'ngx-spinner';
import { Subject } from 'rxjs';
import { AppSettings } from '../app.settings';
import { Web3ContractService } from '../services/web3-contract.service';

@Injectable({
  providedIn: 'root'
})
export class AccountsService {

  public accountChange: Subject<string> = new Subject<string>();

  constructor(public contract: Web3ContractService, private spinner: NgxSpinnerService) {
    contract.accountChange.subscribe((d:string)=>{
      this.accountChange.next(d);
    })
  }

  connectWallet(){
    this.contract.getAddress();
  }

  idToAddress(id: number){
    return this.contract.readContract('map_UserIdToAddress', [id]);
  }

  login(userAddress: string){
    return this.contract.readContract('Login', [userAddress]);
  }

  async register(sponsorAddress: string, packageId: number, amount: number){
    try{
      this.spinner.show();
      if(AppSettings.IsPaymentCurrencyDifferentThanNative){
        let r = await this.contract.approveToken(amount);
        console.log(r)
      }
      let amount_str = this.contract.convertAmountToPaymentCurrencyBaseValue(amount);
      let res = await this.contract.writeContract('Deposit', [sponsorAddress, packageId, amount_str], amount_str);
      console.log(res)
      return res;
    }
    catch(e){
      console.log(e)
      return { success: false, data: null, message: e };
    }
    finally{
      this.spinner.hide();
    }
  }
}
