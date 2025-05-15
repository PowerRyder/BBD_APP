import { Component } from '@angular/core';
import { SharedModule } from 'src/app/shared/shared.module';
import { FlipClockComponent } from "../../shared/flip-clock/flip-clock.component";
import { DetailsService } from '../services/details.service';
import { AppSettings } from 'src/app/app.settings';
import { DepositService } from '../services/deposit.service';
import { SharedService } from 'src/app/shared/shared.service';
import { RefreshService } from 'src/app/services/refresh.service';

@Component({
  selector: 'app-re-activation',
  templateUrl: './re-activation.component.html',
  styleUrls: ['./re-activation.component.scss'],
  standalone: true,
  imports: [SharedModule, FlipClockComponent]
})
export class ReActivationComponent {

  nextActivationDate: Date = new Date(); //new Date("2025-05-16");//
  countdownExpired = false;
  pendingRoiIncome: number = 0;

  paymentCurrency = AppSettings.PaymentTokenSymbol;
  constructor(public shared: SharedService, private details: DetailsService, private depositService: DepositService, private refresh: RefreshService) { }

  async ngOnInit() {
    let userAddress = sessionStorage.getItem("UserAddress");
    let userDetails = (await this.details.getUserDetails(userAddress)).data;

    this.pendingRoiIncome = userDetails.PendingRoiIncome || 0;
    // return;
    const expiryTimestamp = userDetails.ActivationExpiryTimestamp * 1000;
    const now = Date.now();

    if (now >= expiryTimestamp) {
      this.countdownExpired = true;
    } else {
      this.countdownExpired = false;
      this.nextActivationDate = new Date(expiryTimestamp);
      const remaining = expiryTimestamp - now;
      setTimeout(() => {
        this.countdownExpired = true;
      }, remaining);
    }
  }

  async onActivateClick() {
    let result = await this.depositService.activate();

    if (result && result.success) {
      this.shared.alert.trigger({ action: 'success', message: 'Activation successful!' }).then(() => {
        // location.reload();
        this.refresh.refreshComponent();
      });
    }
    else {
      this.shared.alert.trigger({ action: 'error', message: result.message });
    }
  }
}
