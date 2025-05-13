import { Injectable } from '@angular/core';
import { NgxSpinnerService } from 'ngx-spinner';
import { AppSettings } from 'src/app/app.settings';
import { Web3ContractService } from 'src/app/services/web3-contract.service';

@Injectable({
  providedIn: 'root'
})
export class DepositService {

  constructor(public contract: Web3ContractService, private spinner: NgxSpinnerService) { }

  getPackages() {
    return this.contract.readContract('GetPackages', []);
  }

  async redeposit(packageId: number, amount: number) {
    try {
      this.spinner.show();
      if (AppSettings.IsPaymentCurrencyDifferentThanNative) {
        let r = await this.contract.approveToken(amount);
        // console.log(r)
      }
      let amount_str = this.contract.convertAmountToPaymentCurrencyBaseValue(amount);
      let res = await this.contract.writeContract('Deposit', [packageId, amount_str], amount_str);
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

  async activate(){
    try {
      this.spinner.show();

      let res = await this.contract.writeContract('Reactivate', [], "0");
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
}
