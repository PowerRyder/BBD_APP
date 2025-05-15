import { Component, Input, OnChanges, SimpleChanges } from '@angular/core';
import { AppSettings } from 'src/app/app.settings';
import { FlipClockComponent } from 'src/app/shared/flip-clock/flip-clock.component';
import { SharedModule } from 'src/app/shared/shared.module';

@Component({
  selector: 'app-capping4x-end-timer',
  standalone: true,
  imports: [SharedModule, FlipClockComponent],
  templateUrl: './capping4x-end-timer.component.html',
  styleUrls: ['./capping4x-end-timer.component.scss']
})
export class Capping4xEndTimerComponent implements OnChanges {

  @Input() timerEndTimestamp: number = 0;
  timerEndDate: Date = new Date(); //new Date("2025-05-16");//
  countdownExpired = false;

  paymentCurrency = AppSettings.PaymentTokenSymbol;

  ngOnChanges(changes: SimpleChanges): void {
    if (changes && changes['timerEndTimestamp']) {
      const timerEndTimestamp = this.timerEndTimestamp*1000;
      const now = Date.now();
      console.log(now, timerEndTimestamp)
      if (now >= timerEndTimestamp) {
      this.countdownExpired = true;
    } else {
      this.countdownExpired = false;
      this.timerEndDate = new Date(timerEndTimestamp);

      const remaining = timerEndTimestamp - now;
      setTimeout(() => {
        this.countdownExpired = true;
      }, remaining);
    }
    }
  }
}
