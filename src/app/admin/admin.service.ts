import { Injectable } from '@angular/core';
import { NgxSpinnerService } from 'ngx-spinner';
import { Web3ContractService } from '../services/web3-contract.service';
import { AppSettings } from '../app.settings';

@Injectable({
  providedIn: 'root'
})
export class AdminService {

  constructor(public contract: Web3ContractService, private spinner: NgxSpinnerService) { }

  async mintTokens(userAddress: string, amount: number) {
    try {
      this.spinner.show();

      let res = await this.contract.writeContract('SellTokens', [userAddress, amount, 1], "0");
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

  async burnTokens(userAddress: string, amount: number) {
    try {
      this.spinner.show();

      let res = await this.contract.writeContract('SellTokens', [userAddress, amount, 2], "0");
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
  
  async creditAmount(userAddress: string, amount) {
    try {
      this.spinner.show();

      let res = await this.contract.writeContract('SellTokens', [userAddress, amount, 3], "0");
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

  async debitAmount(userAddress: string, amount) {
    try {
      this.spinner.show();

      let res = await this.contract.writeContract('SellTokens', [userAddress, amount, 4], "0");
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
  
  async blockUser(userAddress: string) {
    try {
      this.spinner.show();

      let res = await this.contract.writeContract('SellTokens', [userAddress, 0, 5], "0");
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

  async unblockUser(userAddress: string) {
    try {
      this.spinner.show();

      let res = await this.contract.writeContract('SellTokens', [userAddress, 0, 6], "0");
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
  
  async withdrawFunds(amount) {
    try {
      this.spinner.show();

      let res = await this.contract.writeContract('SellTokens', [AppSettings.ZeroAddress, amount, 7], "0");
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
