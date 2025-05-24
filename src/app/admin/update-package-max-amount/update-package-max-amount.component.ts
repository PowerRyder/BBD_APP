import { Component } from '@angular/core';
import { AccountsService } from 'src/app/accounts/accounts.service';
import { AppSettings } from 'src/app/app.settings';
import { SharedModule } from 'src/app/shared/shared.module';
import { DetailsService } from 'src/app/user/services/details.service';


@Component({
  selector: 'app-update-package-max-amount',
  standalone: true,
  imports: [SharedModule],
  templateUrl: './update-package-max-amount.component.html',
  styleUrls: ['./update-package-max-amount.component.scss']
})
export class UpdatePackageMaxAmountComponent {

  zeroAddress = AppSettings
  amount: number = 0;
  
  constructor(private details :DetailsService , private contract : AccountsService){}

  // onSubmit(){
  //   const maxAmount = this.contract.contract.convertAmountToPaymentCurrencyBaseValue(this.amount)
  //   this.details.withdrawAmount(this.zeroAddress.ZeroAddress,maxAmount,2)
  // }
   onSubmit(){
    const maxAmount = this.contract.contract.convertAmountToPaymentCurrencyBaseValue(this.amount)
    this.details.updatePackageMaxAmount(this.zeroAddress.ZeroAddress,5,maxAmount)
  }
}


// updatePackageMaxAmount