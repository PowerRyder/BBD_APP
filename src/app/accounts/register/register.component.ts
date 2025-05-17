import { Component, OnInit } from '@angular/core';
import { UntypedFormControl, UntypedFormGroup } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { Subscription } from 'rxjs';
import { app_routes } from 'src/app/app.settings';
import { SharedModule } from 'src/app/shared/shared.module';
import { SharedService } from 'src/app/shared/shared.service';
import { AccountsService } from '../accounts.service';
import { PackageDetails, WalletDetails } from '../models/accounts';
import { DetailsService } from 'src/app/user/services/details.service';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  standalone: true,
  imports: [SharedModule,],
  styleUrls: ['./register.component.scss']
})
export class RegisterComponent implements OnInit {

  walletDetails: WalletDetails;
  packageDetails: PackageDetails;

  registerForm = new UntypedFormGroup({
    sponsorId: new UntypedFormControl({ value: '', disabled: false }, this.shared.validators.required),
    userAdddress: new UntypedFormControl({ value: '', disabled: true }, this.shared.validators.required),
  });

  app_routes = app_routes;

  subscription: Subscription;
  constructor(private shared: SharedService, private accounts: AccountsService, private router: Router, private activatedRoute: ActivatedRoute, private details: DetailsService) {
  }

  async ngOnInit() {
    this.registerForm.controls['sponsorId'].setValue(this.activatedRoute.snapshot.paramMap.get("spId")!);

    this.subscription = this.accounts.accountChange.subscribe(async addr => {
      this.registerForm.controls['userAdddress'].setValue(addr);
      let paymentCurrencyBalance = await this.accounts.contract.getPaymentTokenBalance(addr);

      this.walletDetails = { address: addr, balance: paymentCurrencyBalance };
    })

    setTimeout(async () => {
      await this.onConnectWalletClick();
    }, 100);
  }

  async onConnectWalletClick() {
    await this.accounts.connectWallet();
  }

  accountCallback(data: WalletDetails) {
    this.walletDetails = data;
  }

  packageCallback(data: PackageDetails) {
    this.packageDetails = data;
  }

  async onSubmit() {
    if (!this.registerForm.controls['sponsorId'].value) {
      this.registerForm.controls['sponsorId'].setValue('1');
    }

    if (this.registerForm.valid) {
      let sponsorAddress = this.registerForm.controls['sponsorId'].value;

      if (sponsorAddress.match(/^[0-9]+$/)) {
        sponsorAddress = (await this.accounts.idToAddress(sponsorAddress)).data;
      }

      let res = await this.accounts.login(sponsorAddress);
      if (res && res.data) {

        let res_sponsor = (await this.details.getUserDetails(sponsorAddress)).data;
        console.log(res_sponsor)
        if (res_sponsor && res_sponsor.Investment > 0) {
          let res = await this.accounts.login(this.walletDetails.address);
          if (!res.data) {
            // if (this.walletDetails.balance >= this.packageDetails.amount) {
            let res = await this.accounts.register(sponsorAddress, 0);
            // console.log("register", res)
            if (res && res.success) {
              this.shared.alert.trigger({ action: 'success', message: 'Ragistration successful!' }).then(() => {
                sessionStorage.setItem("UserAddress", this.walletDetails.address);
                this.router.navigateByUrl(app_routes.user_dashboard.url);
              });
            }
            // }
            // else {
            //   this.shared.alert.trigger({ action: 'error', message: 'Insufficient balance!' });
            // }
          }
          else {
            this.shared.alert.trigger({ action: 'error', message: 'User already registered!' });
          }
        }
        else {
          this.shared.alert.trigger({ action: 'error', message: 'Sponsor is inactive!' });
        }
      }
      else {
        this.shared.alert.trigger({ action: 'error', message: 'Invalid sponsor id or address!' });
      }

    }
  }
}
