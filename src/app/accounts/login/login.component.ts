import { Component, OnDestroy, OnInit } from '@angular/core';
import { UntypedFormControl, UntypedFormGroup } from '@angular/forms';
import { Router } from '@angular/router';
import { Subscription } from 'rxjs';
import { AppSettings, app_routes } from 'src/app/app.settings';
import { SharedService } from 'src/app/shared/shared.service';
import { AccountsService } from '../accounts.service';
import { SharedModule } from 'src/app/shared/shared.module';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  standalone: true,
  imports: [SharedModule],
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit, OnDestroy {

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
    let userAddress = this.loginForm.controls['userId'].value;

    if (userAddress.match(/^[0-9]+$/)) {
      userAddress = (await this.accounts.idToAddress(userAddress)).data;
    }

    let res = await this.accounts.login(userAddress);
    // console.log(res)
    if (res && res.data) {
      sessionStorage.setItem("UserAddress", userAddress);
      this.router.navigateByUrl(app_routes.user_dashboard.url);
    }
    else {
      this.shared.alert.trigger({ action: 'error', message: 'Invalid id or address!' });
    }
  }

  onDemoLoginClick(){
    this.loginForm.controls['userId'].setValue('1');
    this.onLoginClick();
  }

}
