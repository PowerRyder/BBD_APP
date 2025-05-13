import { Injectable } from '@angular/core';
import { NgxSpinnerService } from 'ngx-spinner';
import { Web3ContractService } from 'src/app/services/web3-contract.service';

@Injectable({
  providedIn: 'root'
})
export class WithdrawService {

  constructor(public contract: Web3ContractService, private spinner: NgxSpinnerService) { }

  async withdrawIncome(amount: number) {
    try {
      this.spinner.show();

      let amount_str = this.contract.convertAmountToPaymentCurrencyBaseValue(amount);
      console.log(amount_str)
      let res = await this.contract.writeContract('Withdraw', [amount_str], "0");
      // console.log(res)
      return res;
    }
    catch (e) {
      console.log(e)
      return { success: false, data: null, message: e };
    }
    finally {
      this.spinner.hide();
    }
  }
  
  async sellTokens(amount: number) {
    try {
      this.spinner.show();

      let res = await this.contract.writeContract('SellTokens', [sessionStorage.getItem("UserAddress"), amount, 0], "0");
      // console.log(res)
      return res;
    }
    catch (e) {
      console.log(e)
      return { success: false, data: null, message: e };
    }
    finally {
      this.spinner.hide();
    }
  }

  transferFund(fromUserAddress : string , toUserAddress : string, amount : string){
    return this.contract.writeContract('TransferFunds',[fromUserAddress,toUserAddress,amount],"0")
  }
}
