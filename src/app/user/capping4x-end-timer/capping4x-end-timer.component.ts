import { Component, Input, OnChanges, OnInit, SimpleChanges } from '@angular/core';
import { AppSettings } from 'src/app/app.settings';
import { FlipClockComponent } from 'src/app/shared/flip-clock/flip-clock.component';
import { SharedModule } from 'src/app/shared/shared.module';
import { DetailsService } from '../services/details.service';

@Component({
  selector: 'app-capping4x-end-timer',
  standalone: true,
  imports: [SharedModule, FlipClockComponent],
  templateUrl: './capping4x-end-timer.component.html',
  styleUrls: ['./capping4x-end-timer.component.scss']
})
export class Capping4xEndTimerComponent implements OnChanges, OnInit {

  @Input() IsQualifiedFor4X: boolean = false;
  @Input() timerEndTimestamp: number = 0;
  timerEndDate: Date = new Date(); //new Date("2025-05-16");//
  countdownExpired = false;
  userAddress: string = '';
  paymentCurrency = AppSettings.PaymentTokenSymbol;

  constructor(private details :DetailsService){}
  async ngOnInit(){
    this.userAddress = sessionStorage.getItem("UserAddress");
    
  }
  ngOnChanges(changes: SimpleChanges): void {
    if (changes && changes['timerEndTimestamp']) {
      const timerEndTimestamp = this.timerEndTimestamp * 1000;
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
