import { Inject, Injectable } from '@angular/core';
import { Subject } from 'rxjs';
import Web3 from 'web3';
import { AppSettings } from '../app.settings';
import { SharedService } from '../shared/shared.service';

@Injectable({
  providedIn: 'root'
})
export class Web3ContractService {

  private account: string = '';
  private web3: Web3;
  private gasPrice: string = "50";
  private contract: any;
  accountChange: Subject<string> = new Subject<string>();

  constructor(@Inject('Window') private window: any, private shared: SharedService) {
    this.initialize();
  }

  async initialize() {
    await this.getContract();

    if (this.web3 && !this.account) {
      await this.getAddress();
    }
  }

  private getWeb3 = async () => {
    if (this.web3 == undefined || this.web3 == null) {
      if (this.window.ethereum) {
        await this.initializeWeb3();
        var that = this;
        this.window.ethereum.on('accountsChanged', function (accounts: any) {
          that.account = accounts[0];

          that.accountChange.next(that.account);
        });
        this.window.ethereum.on('networkChanged', async function (networkId: any) {

          console.log('networkChanged', networkId);
          await that.initializeWeb3();
        });
        return this.web3;
      }
      else {
        this.shared.alert.trigger({ action: 'error', title: 'Non-Dapp browser detected!', message: 'Try Metamask or Trustwallet.' });

        this.web3 = await new Web3(new Web3.providers.HttpProvider(AppSettings.CHAIN.RpcUrl));
        return this.web3;
      }
    }
    return this.web3;
  }

  private async initializeWeb3() {
    if ((this.window.ethereum.networkVersion != AppSettings.CHAIN.ChainId)) {
      //this.web3 = await new Web3(this.window.ethereum);
      await this.addNetwork();
    }

    this.web3 = await new Web3(new Web3.providers.HttpProvider(AppSettings.CHAIN.RpcUrl));
  }

  private async addNetwork() {
    try {
      await this.window.ethereum.request({
        method: 'wallet_switchEthereumChain',
        params: [{ chainId: AppSettings.CHAIN.ChainIdHex }],
      });
    } catch (error: any) {
      if (error.code === 4902) {
        try {
          await this.window.ethereum.request({
            method: 'wallet_addEthereumChain',
            params: [{
              chainId: AppSettings.CHAIN.ChainIdHex,
              chainName: AppSettings.CHAIN.ChainName,
              nativeCurrency: {
                name: AppSettings.CHAIN.NativeCurrency.Name,
                symbol: AppSettings.CHAIN.NativeCurrency.Symbol,
                decimals: AppSettings.CHAIN.NativeCurrency.Decimal,
              },
              rpcUrls: [AppSettings.CHAIN.RpcUrl],
              blockExplorerUrls: [AppSettings.CHAIN.ExplorerUrl],
              iconUrls: [""],

            }],
          });
        } catch (addError) {
          console.log('Did not add network');
        }
      }
    }
  }

  public async getContract() {
    if (!this.contract) {
      this.contract = await new (await this.getWeb3()).eth.Contract(AppSettings.ABI, AppSettings.ContractAddress);
      return this.contract;
    }
    return this.contract;
  }

  public getAddress = async () => {

    if (!this.account) {
      let addresses = null;
      try {
        addresses = await this.window.ethereum.request({ method: 'eth_requestAccounts' });
      }
      catch (exception) {
        try {
          addresses = await this.window.ethereum.enable();
        }
        catch (innerEx) {
          console.log(innerEx);
        }
        console.log(exception);
      }

      if (addresses != null && addresses != undefined && addresses.length > 0) {
        this.account = addresses.length ? addresses[0] : null;
        return this.account;
      }

      return undefined;
    }
    this.accountChange.next(this.account);
    return this.account;
  }

  public async getNativeCurrencyBalance() {
    let accountBalance = await (await this.getWeb3()).eth.getBalance(this.account ? this.account : (await this.getAddress()));
    return Number(this.web3.utils.fromWei(accountBalance, "ether"));
  }

  private async getPaymentTokenContract() {
    let contract = await new (await this.getWeb3()).eth.Contract(AppSettings.PaymentTokenABI, AppSettings.PaymentTokenContractAddress);
    return contract;
  }

  public async getPaymentTokenBalance(address: string) {
    // debugger;
    if (AppSettings.IsPaymentCurrencyDifferentThanNative) {
      try {
        let contract = await this.getPaymentTokenContract();
        // console.log(contract)
        let balance = (await contract.methods.balanceOf(address).call()) / Math.pow(10, AppSettings.PaymentTokenDecimals);
        // console.log("balance", balance)

        return balance;
      } catch (err: any) {
        return 0;
      }
    }
    else {
      return await this.getNativeCurrencyBalance();
    }
  }

  private async getGasPrice() {
    try {
      await (await this.getWeb3()).eth.getGasPrice()
        .then((gPrice: any) => {
          ///console.log("Gas price: " + this.web3.utils.fromWei(gPrice, "Gwei"));
          this.gasPrice = this.web3.utils.fromWei(gPrice, "Gwei");
        });
    }
    catch (ex) {
      console.log("getGasPrice", ex);
    }
  }

  async approveToken(amount: number) {
    if (AppSettings.IsPaymentCurrencyDifferentThanNative) {
      try {
        let contract = await this.getPaymentTokenContract();
        // console.log(contract);

        await this.getGasPrice();


        let value = "0";
        let _gasPrice = (await this.getWeb3()).utils.toWei(this.gasPrice, "Gwei");
        let estimatedGas = "0";
        let amount_str = this.convertAmountToPaymentCurrencyBaseValue(amount);
        await contract.methods.approve(AppSettings.ContractAddress, amount_str).estimateGas({
          from: this.account,
          value: "0",
          gasPrice: _gasPrice
        }, function (error: any, _estimatedGas: any) {
          //console.log(error, _estimatedGas);
          estimatedGas = _estimatedGas;
        });

        let data = contract.methods.approve(AppSettings.ContractAddress, amount_str).encodeABI();
        var receipt = await this.sendTransaction(this.account, AppSettings.PaymentTokenContractAddress, value, _gasPrice, estimatedGas, data);
        return { success: receipt.success, data: receipt.data, message: receipt.success ? "Ok!" : receipt.message };

      } catch (err: any) {
        return { success: false, data: err, message: "Unable to approve " + AppSettings.PaymentTokenSymbol + "!" + err };
      }
    }
    else {
      return { success: true, data: '', message: 'No need for approval!' }
    }
  }

  public convertAmountToPaymentCurrencyBaseValue(amount: number): string {
    let amount_str = Number(amount * Math.pow(10, AppSettings.PaymentTokenDecimals)).toLocaleString('fullwide', { useGrouping: false });
    return amount_str;
  }

  public convertAmountFromPaymentCurrencyBaseValue(amount: number) {
    amount = Number(Number(amount / Math.pow(10, AppSettings.PaymentTokenDecimals)).toFixed(4));
    return amount;
  }

  public convertBBDRateToBase(amount: number): string {
    let amount_str = Number(amount * Math.pow(10, 30)).toLocaleString('fullwide', { useGrouping: false });
    return amount_str;
  }

  public convertBBDRateFromBase(amount: number) {
    amount = Number(Number(amount / Math.pow(10, 30)).toFixed(4));
    return amount;
  }

  public async sendTransaction(fromAddress: string, toAddress: string, value: string, gasPrice: string, gas: string, data: any) {
    try {
      var _gas = Math.ceil(Number(gas) + (Number(gas) * 0.02));

      gas = _gas.toString();

      var _gasPrice = Math.ceil(Number(gasPrice) + (Number(gasPrice)));

      gasPrice = _gasPrice.toString();

      if ((this.window.ethereum.networkVersion == AppSettings.CHAIN.ChainId || this.window.ethereum.chainId == AppSettings.CHAIN.ChainId)) {

        var _web3: any = await new Web3(this.window.ethereum);

        let receipt = await _web3.eth.sendTransaction({
          from: fromAddress,
          to: toAddress,
          value: value,
          gasPrice: gasPrice,
          gas: gas,
          data: data
        });
        return { success: receipt.status, data: receipt, message: 'Ok' };

      }
      else {
        return { success: false, data: '', message: "Please switch to Smart Chain network!" };
      }
    }
    catch (ex: any) {
      console.log(ex);
      return { success: false, data: '', message: ex.message };
    }
  }

  public async writeContract(methodName: string, params: any, value: string) {

    try {
      if (AppSettings.IsPaymentCurrencyDifferentThanNative) {
        value = "0";
      }

      await this.getGasPrice();

      let estimatedGas = "0";
      let _gasPrice = (await this.getWeb3()).utils.toWei(this.gasPrice, "Gwei");
      await this.contract.methods[methodName].apply(this, params).estimateGas({
        from: this.account,
        value: value,
        gasPrice: _gasPrice
      }, function (error: any, _estimatedGas: any) {
        console.log(error, _estimatedGas);
        estimatedGas = _estimatedGas;
      });

      let data = this.contract.methods[methodName].apply(this, params).encodeABI();
      console.log("data", data)
      var receipt = await this.sendTransaction(this.account, AppSettings.ContractAddress, value, _gasPrice, estimatedGas, data);
      console.log("receip" , receipt)
      return { success: receipt.success, data: receipt.data, message: receipt.success ? "Ok!" : receipt.message };
    }
    catch (e) {
      console.log("e",e)
      return { success: false, data: null, message: e };
    }
  }

  public async readContract(methodName: string, params: any) {
    let res = { success: false, message: '', data: null };

    await (await this.getContract()).methods[methodName].apply(this, params).call((error: any, result: any) => {
      if (!error) {
        res = { success: true, message: "Ok", data: result };
      }
      else {
        res = { success: false, message: error, data: null };
      }
    });

    return res;
  }
}
