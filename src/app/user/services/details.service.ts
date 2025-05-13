import { Injectable } from '@angular/core';
import { Web3ContractService } from 'src/app/services/web3-contract.service';

@Injectable({
  providedIn: 'root'
})
export class DetailsService {

  constructor(public contract: Web3ContractService) { }
  
  getContractDetails(){
    return this.contract.readContract('GetContractDetails', []);
  }
  
  getUserDetails(userAddress: string){
    return this.contract.readContract('map_Users', [userAddress]);
  }
  
  getDashboardDetails(userAddress: string){
    return this.contract.readContract('GetDashboardDetails', [userAddress]);
  }

  getDirects(userAddress: string){
    return this.contract.readContract('GetDirects', [userAddress])
  }
  
  getLevelIncome(userAddress: string){
    return this.contract.readContract('GetLevelIncomeInfo', [userAddress])
  }
  
  getWithdrawalLevelIncome(userAddress: string){
    return this.contract.readContract('GetWithdrawalLevelIncomeInfo', [userAddress])
  }
  
  getTransactionCount(userAddress: string){
    return this.contract.readContract('map_UserTransactionCount', [userAddress])
  }
  
  getDepositHistory(userAddress: string, pageIndex: number, pageSize: number){
    return this.contract.readContract('GetDepositHistory', [userAddress, pageIndex, pageSize])
  }
  
  getTokenSellHistory(userAddress: string, pageIndex: number, pageSize: number){
    return this.contract.readContract('GetTokenSellHistory', [userAddress, pageIndex, pageSize])
  }
  
  getIncomeWithdrawalHistory(userAddress: string, pageIndex: number, pageSize: number){
    return this.contract.readContract('GetIncomeWithdrawalHistory', [userAddress, pageIndex, pageSize])
  }
  
  getwalletBalanceAmount(userAddress :string , walletId : number){
    return this.contract.readContract('GetWalletBalance',[userAddress , walletId])
  }
}
