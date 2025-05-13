import { Component } from '@angular/core';
import { SharedModule } from 'src/app/shared/shared.module';
import { FlipClockComponent } from "../../shared/flip-clock/flip-clock.component";
import { DetailsService } from '../services/details.service';

@Component({
  selector: 'app-re-activation',
  templateUrl: './re-activation.component.html',
  styleUrls: ['./re-activation.component.scss'],
  standalone: true,
  imports: [SharedModule, FlipClockComponent]
})
export class ReActivationComponent {

  nextActivationDate: Date = new Date();

  constructor(private details: DetailsService){ }
  
  async ngOnInit(){
    let userAddress = sessionStorage.getItem("UserAddress");
    let userDetails = (await this.details.getUserDetails(userAddress)).data;

    let ActivationExpiryTimestamp = userDetails.ActivationExpiryTimestamp;
    this.nextActivationDate = new Date(ActivationExpiryTimestamp * 1000);
    // console.log(this.nextActivationDate)
    // this.nextActivationDate = new Date('2025-05-15T18:00:00')
  }

  onActivateClick(){

  }
}
