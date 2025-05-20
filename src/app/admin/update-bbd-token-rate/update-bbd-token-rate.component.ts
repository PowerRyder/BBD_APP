import { Component, OnInit } from '@angular/core';
import { SharedModule } from 'src/app/shared/shared.module';
import { SharedService } from 'src/app/shared/shared.service';
import { DetailsService } from 'src/app/user/services/details.service';
import { ReactiveFormsModule, UntypedFormControl, UntypedFormGroup } from '@angular/forms';
import { AccountsService } from 'src/app/accounts/accounts.service';

@Component({
  selector: 'app-update-bbd-token-rate',
  standalone: true,
  imports: [SharedModule,ReactiveFormsModule],
  templateUrl: './update-bbd-token-rate.component.html',
  styleUrls: ['./update-bbd-token-rate.component.scss']
})
export class UpdateBBDTokenRateComponent implements OnInit{
  // amount : number = 0
  constructor(private details : DetailsService , public shared : SharedService, private accounts : AccountsService ){this.createForm()}

  updateBBDTokenRateForm : UntypedFormGroup 

  ngOnInit(): void {
    this.getTokenRate()
  }

  
  createForm(){
    this.updateBBDTokenRateForm = new UntypedFormGroup({
      amount : new UntypedFormControl({value : 0  , disabled :false}),
      rateOfToken : new UntypedFormControl({value : 0  , disabled :false})
    })
  }

  async onSubmit(){
    // console.log(this.updateBBDTokenRateForm.controls['amount'].value)
    let _amount = this.updateBBDTokenRateForm.controls['amount'].value
    let result = await this.details.setBBDTokenRate('0',6 ,_amount)
    console.log("result" , result)
  }

  async getTokenRate() {
    try {
      const result = await this.details.TokenRate();
      if (result?.success) {
        const tokenRate = result.data;
        // console.log("BBD Token Rate ->", tokenRate);
        const readtokenRate = this.accounts.contract.convertAmountFromPaymentCurrencyBaseValue(tokenRate)
        this.updateBBDTokenRateForm.get('rateOfToken')?.setValue(readtokenRate)
        // console.log("read token value", tokenRate)

      } else {
        console.error("Failed to fetch token rate:", result?.message);
      }
    } catch (error) {
      console.error("Error fetching BBD Token Rate:", error);
    }
  }
}
