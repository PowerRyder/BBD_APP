import { Component } from '@angular/core';
import { SharedModule } from 'src/app/shared/shared.module';
import { FlipClockComponent } from "../../shared/flip-clock/flip-clock.component";
import { DetailsService } from '../services/details.service';
import { AppSettings } from 'src/app/app.settings';

@Component({
  selector: 'app-re-activation',
  templateUrl: './re-activation.component.html',
  styleUrls: ['./re-activation.component.scss'],
  standalone: true,
  imports: [SharedModule, FlipClockComponent]
})
export class ReActivationComponent {

  nextActivationDate: Date = new Date();
  countdownExpired = false;
  pendingRoiIncome: number = 0;

  paymentCurrency = AppSettings.PaymentTokenSymbol;
  constructor(private details: DetailsService){ }

  async ngOnInit(){
    let userAddress = sessionStorage.getItem("UserAddress");
    let userDetails = (await this.details.getUserDetails(userAddress)).data;

    this.pendingRoiIncome = userDetails.PendingRoiIncome || 0;

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

  onActivateClick() {
    
  }
}
