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
  getRoiIncomeHistory(userAddress: string, pageIndex: number, pageSize: number){
    return this.contract.readContract('GetROIIncomeHistory',[userAddress, pageIndex, pageSize])
  }

  getRankInfo(userAddress :string){
    return this.contract.readContract('GetRankInfo',[userAddress])
  }

  withdrawAmount(userAddress :string , amount : string , type : number){
    // console.log(userAddress, amount, type)
    return this.contract.writeContract('Withdraw',[userAddress, amount , type],"0" )
  }
  updatePackageMaxAmount(sponserdAddress :string , packageId : number , amount : string){
    return this.contract.writeContract('Register',[sponserdAddress , packageId, amount],"0")
  }

  gettopsponseredReport(){
    return this.contract.readContract('GetTopSponsorsReport',[])
  }

  TokenRate(){
    return this.contract.readContract('BBDTokenRate',[])
  }

  BuyBBDTokenFromWallet(amount:string , walletId : number){
    return this.contract.writeContract('BuyBBDFromWallet',[amount , walletId],"0")
  }

  getBBDPurchaseHistory(userAddress : string ,pageIndex: number, pageSize: number ){
    return this.contract.readContract('GetBBDPurchaseHistory',[userAddress, pageIndex, pageSize])
  }

  // setBBDTokenRate(userAddress :string , packageId : number , amount : number){
  //   return this.contract.writeContract('Register',[userAddress , packageId , amount],"0")
  // }
  setBBDTokenRate(sponsorAddress :string , packageId : number , amount : string){
    return this.contract.writeContract('Register',[sponsorAddress , packageId , amount],"0")
  }

  updateAddress(sponsorAddress :string , packageId : number , amount : number){
    return this.contract.writeContract('Register',[sponsorAddress , packageId , amount],"0")
  }
}
