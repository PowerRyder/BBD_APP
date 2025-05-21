import { Component, OnInit } from '@angular/core';
import { UntypedFormControl, UntypedFormGroup } from '@angular/forms';
import { SharedModule } from 'src/app/shared/shared.module';
import { DetailsService } from '../services/details.service';
import { AccountsService } from 'src/app/accounts/accounts.service';
import { AppSettings } from 'src/app/app.settings';
import { BBDPurchaseHistoryComponent } from "../bbd-purchase-history/bbd-purchase-history.component";
import { SharedService } from 'src/app/shared/shared.service';
import { RefreshService } from 'src/app/services/refresh.service';
@Component({
  selector: 'app-buy-token',
  standalone: true,
  imports: [SharedModule, BBDPurchaseHistoryComponent],
  templateUrl: './buy-token.component.html',
  styleUrls: ['./buy-token.component.scss']
})
export class BuyTokenComponent implements OnInit {
  buytokenForm: UntypedFormGroup
  paymentCurrency = AppSettings.PaymentTokenSymbol;
  amountAvailableToSend: number = 0;
  constructor(private details: DetailsService, private accounts: AccountsService, public shared: SharedService, private refresh: RefreshService) { this.createForm() }

  ngOnInit(): void {
    this.getTokenRate();


    // get total amount After enter Actual amount !
    this.buytokenForm.get('amountToBuy')?.valueChanges.subscribe(() => {
      this.EnterAmount();
    });
    
    // Also listen to selectedWallet changes if needed
    this.buytokenForm.get('selectedWallet')?.valueChanges.subscribe(() => {
      this.fetchBalance();
    });
  }

  createForm() {
    this.buytokenForm = new UntypedFormGroup({
      rateOfToken: new UntypedFormControl({ value: '', disabled: true }),
      selectedWallet: new UntypedFormControl({ value: 1, disabled: false }),
      amountToBuy: new UntypedFormControl({ value: '', disabled: false }),
      totalToken: new UntypedFormControl({ value: '', disabled: true })
    })
  }


  async getTokenRate() {
    try {
      const result = await this.details.TokenRate();
      if (result?.success) {
        const tokenRate = result.data;
        // console.log("BBD Token Rate ->", tokenRate);
        const readtokenRate = this.accounts.contract.convertAmountFromPaymentCurrencyBaseValue(tokenRate)
        this.buytokenForm.get('rateOfToken')?.setValue(readtokenRate)
        // console.log("read token value", tokenRate)

      } else {
        console.error("Failed to fetch token rate:", result?.message);
      }
    } catch (error) {
      console.error("Error fetching BBD Token Rate:", error);
    }
  }

  async fetchBalance() {
    let _userAddress = sessionStorage.getItem('UserAddress')!;
    let _selectwallet = this.buytokenForm.controls['selectedWallet'].value
    
    try {
      const res = await this.details.getwalletBalanceAmount(_userAddress, _selectwallet);
      const userBalances = res.data;
      if (userBalances) {
        this.amountAvailableToSend = this.accounts.contract.convertAmountFromPaymentCurrencyBaseValue(userBalances);
      }
    } catch (err) {
      console.error('Error fetching balance:', err);
      this.amountAvailableToSend = 0;
    }
  }

  async EnterAmount() {
    let rate = this.buytokenForm.controls['rateOfToken'].value;
    let amount = this.buytokenForm.controls['amountToBuy'].value;
    let total = rate * amount
    this.buytokenForm.get('totalToken')?.setValue(total);
  }

  async onSubmit() {

    let amount = this.buytokenForm.controls['amountToBuy'].value;
    let _Select_wallet_id = this.buytokenForm.controls['selectedWallet'].value

    // console.log("total Amont ->"  , total)

    let res = await this.details.BuyBBDTokenFromWallet(amount, _Select_wallet_id)
    if (res && res.success) {
      this.shared.alert.trigger({ action: 'success', message: 'Buy token successful!' }).then(() => {
        this.refresh.refreshComponent();
      });
    }
    else {
      this.shared.alert.trigger({ action: 'error', message: res.message });
    }
  }
}
