import { Component, OnInit } from '@angular/core';
import { UntypedFormControl, UntypedFormGroup } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { app_routes } from 'src/app/app.settings';
import { SharedService } from 'src/app/shared/shared.service';
import { AccountsService } from '../accounts.service';
import { PackageDetails, WalletDetails } from '../models/accounts';
import { SharedModule } from 'src/app/shared/shared.module';
import { PackageComponent } from 'src/app/user/package/package.component';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  standalone: true,
  imports: [SharedModule, PackageComponent],
  styleUrls: ['./register.component.scss']
})
export class RegisterComponent implements OnInit {

  walletDetails: WalletDetails;
  packageDetails: PackageDetails;

  registerForm = new UntypedFormGroup({
    sponsorId: new UntypedFormControl({ value: '', disabled: false }, this.shared.validators.required)
  });

  app_routes = app_routes;

  constructor(private shared: SharedService, private accounts: AccountsService, private router: Router, private activatedRoute: ActivatedRoute) {
  }

  ngOnInit(): void {
    this.registerForm.controls['sponsorId'].setValue(this.activatedRoute.snapshot.paramMap.get("spId")!);
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
        let res = await this.accounts.login(this.walletDetails.address);
        if (!res.data) {
          if (this.walletDetails.balance >= this.packageDetails.amount) {
            let res = await this.accounts.register(sponsorAddress, Number(this.packageDetails.packageId), this.packageDetails.amount);
            // console.log("register", res)
            if (res && res.success) {
              this.shared.alert.trigger({ action: 'success', message: 'Deposit successful!' }).then(() => {
                sessionStorage.setItem("UserAddress", this.walletDetails.address);
                this.router.navigateByUrl(app_routes.user_dashboard.url);
              });
            }
          }
          else {
            this.shared.alert.trigger({ action: 'error', message: 'Insufficient balance!' });
          }
        }
        else {
          this.shared.alert.trigger({ action: 'error', message: 'User already registered!' });
        }
      }
      else {
        this.shared.alert.trigger({ action: 'error', message: 'Invalid sponsor id or address!' });
      }

    }
  }
}
