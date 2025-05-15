import { Component } from '@angular/core';
import { UntypedFormGroup, UntypedFormControl } from '@angular/forms';
import { Router } from '@angular/router';
import { Subscription } from 'rxjs';
import { AppSettings, app_routes } from 'src/app/app.settings';
import { SharedModule } from 'src/app/shared/shared.module';
import { SharedService } from 'src/app/shared/shared.service';
import { AccountsService } from '../accounts.service';

@Component({
  selector: 'app-admin-login',
  standalone: true,
  imports: [SharedModule],
  templateUrl: './admin-login.component.html',
  styleUrls: ['./admin-login.component.scss']
})
export class AdminLoginComponent {

  isDemo: boolean = AppSettings.IsDemo;

  loginForm = new UntypedFormGroup({
    userId: new UntypedFormControl({ value: '', disabled: false }, this.shared.validators.required)
  });

  app_routes = app_routes;

  subscription: Subscription;
  constructor(private shared: SharedService, private accounts: AccountsService, private router: Router) {
  }

  ngOnDestroy(): void {
    this.subscription.unsubscribe();
  }

  async ngOnInit() {
    setTimeout(async()=>{
      this.subscription = this.accounts.accountChange.subscribe(addr => {
        this.loginForm.controls['userId'].setValue(addr);
      })
  
      await this.onConnectWalletClick();
    }, 100)
  }

  async onConnectWalletClick() {
    await this.accounts.connectWallet();
  }

  async onLoginClick() {
    let userAddress: string = this.loginForm.controls['userId'].value;

    // console.log(res)
    if (userAddress.toLowerCase() == AppSettings.AdminAddress.toLowerCase()) {
      sessionStorage.setItem("UserAddress", userAddress);
      this.router.navigateByUrl(app_routes.admin_dashboard.url);
    }
    else {
      this.shared.alert.trigger({ action: 'error', message: 'Invalid admin address!' });
    }
  }

}
