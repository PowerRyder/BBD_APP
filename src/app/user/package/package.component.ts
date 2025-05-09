import { Component, EventEmitter, OnInit, Output } from '@angular/core';
import { UntypedFormControl, UntypedFormGroup } from '@angular/forms';
import { Subscription } from 'rxjs';
import { AccountsService } from 'src/app/accounts/accounts.service';
import { PackageDetails, WalletDetails } from 'src/app/accounts/models/accounts';
import { AppSettings } from 'src/app/app.settings';
import { SharedModule } from 'src/app/shared/shared.module';
import { SharedService } from 'src/app/shared/shared.service';
import { DepositService } from '../services/deposit.service';

@Component({
  selector: 'app-package',
  templateUrl: './package.component.html',
  styleUrls: ['./package.component.scss'],
  standalone: true,
  imports: [SharedModule]
})
export class PackageComponent implements OnInit {

  @Output() accountCallback: EventEmitter<WalletDetails> = new EventEmitter();
  @Output() packageCallback: EventEmitter<PackageDetails> = new EventEmitter();

  packages: any[] = []
  selectedPackage: any;
  minAmount: number = 0;
  maxAmount: number = 0;
  paymentCurrencyBalance: number = 0;

  paymentCurrency = AppSettings.PaymentTokenSymbol;

  packageForm = new UntypedFormGroup({
    userAddress: new UntypedFormControl({ value: '', disabled: true }, this.shared.validators.required),
    amount: new UntypedFormControl({ value: '', disabled: false }, this.shared.validators.required),
    amountUsedToBuyTokens: new UntypedFormControl({ value: '', disabled: true })
  });

  subscription: Subscription;

  constructor(private deposit: DepositService, private accounts: AccountsService, private shared: SharedService) { }

  async ngOnInit() {
    this.subscription = this.accounts.accountChange.subscribe(async addr => {
      this.packageForm.controls['userAddress'].setValue(addr);
      this.paymentCurrencyBalance = await this.accounts.contract.getPaymentTokenBalance(addr);
      this.accountCallback.emit({ address: addr, balance: this.paymentCurrencyBalance })
    })

    setTimeout(async ()=>{
      await this.onConnectWalletClick();
    }, 100)
    this.packages = (await this.deposit.getPackages()).data;
    if (this.packages.length == 1) {
      this.onPackageSelect(this.packages[0])
      // this.selectedPackage = this.packages[0];
    }
    // console.log(this.packages)
  }

  async onConnectWalletClick() {
    await this.accounts.connectWallet();
  }

  onPackageSelect(pack: any) {
    this.selectedPackage = pack;
    if (!this.selectedPackage.HasRange) {
      this.packageForm.controls['amount'].setValue(this.accounts.contract.convertAmountFromPaymentCurrencyBaseValue(Number(this.selectedPackage.Amount)));
      this.packageForm.controls['amount'].disable();
      this.minAmount = this.accounts.contract.convertAmountFromPaymentCurrencyBaseValue(this.selectedPackage.Amount);
      this.maxAmount = this.accounts.contract.convertAmountFromPaymentCurrencyBaseValue(this.selectedPackage.Amount);
    }
    else {
      this.packageForm.controls['amount'].enable();
      this.packageForm.controls['amount'].setValue(this.accounts.contract.convertAmountFromPaymentCurrencyBaseValue(Number(this.selectedPackage.MinAmount)));
      this.minAmount = this.accounts.contract.convertAmountFromPaymentCurrencyBaseValue(this.selectedPackage.MinAmount);
      this.maxAmount = this.accounts.contract.convertAmountFromPaymentCurrencyBaseValue(this.selectedPackage.MaxAmount);
    }
    this.onAmountChange();
  }

  onAmountChange() {
    this.packageCallback.emit({ packageId: this.selectedPackage.PackageId, amount: this.packageForm.controls['amount'].value })
  }

  addAmount(amount: number) {
    if (this.packageForm.controls['amount'].value + amount <= this.maxAmount) {
      this.packageForm.controls['amount'].setValue(this.packageForm.controls['amount'].value + amount);
    }
    else {
      this.packageForm.controls['amount'].setValue(this.maxAmount);
    }
    this.onAmountChange();
  }

  async onMaxClick() {
    this.packageForm.controls['amount'].setValue(this.maxAmount <= this.paymentCurrencyBalance ? this.maxAmount : this.paymentCurrencyBalance);
  }

  ngOnDestroy(): void {
    this.subscription.unsubscribe();
  }

}
