import { Component, OnInit } from '@angular/core';
import { SharedModule } from 'src/app/shared/shared.module';
import { SharedService } from 'src/app/shared/shared.service';
import { DetailsService } from 'src/app/user/services/details.service';
import { ReactiveFormsModule, UntypedFormControl, UntypedFormGroup } from '@angular/forms';
import { AccountsService } from 'src/app/accounts/accounts.service';
import { RefreshService } from 'src/app/services/refresh.service';
import { AppSettings } from 'src/app/app.settings';

@Component({
  selector: 'app-update-bbd-token-rate',
  standalone: true,
  imports: [SharedModule,ReactiveFormsModule],
  templateUrl: './update-bbd-token-rate.component.html',
  styleUrls: ['./update-bbd-token-rate.component.scss']
})
export class UpdateBBDTokenRateComponent implements OnInit{
  // amount : number = 0

  sponseredAddress = AppSettings
  constructor(private details : DetailsService , public shared : SharedService, private accounts : AccountsService , private refresh : RefreshService){this.createForm()}

  updateBBDTokenRateForm : UntypedFormGroup 

  ngOnInit(): void {
    this.getTokenRate()
  }

  
  createForm(){
    this.updateBBDTokenRateForm = new UntypedFormGroup({
      amount : new UntypedFormControl({value : ''  , disabled :false},this.shared.validators.required),
      rateOfToken : new UntypedFormControl({value : ''  , disabled :false})
    })
  }

  async onSubmit(){
    // console.log(this.updateBBDTokenRateForm.controls['amount'].value)
    let _amount = this.updateBBDTokenRateForm.controls['amount'].value
    _amount = (1/_amount).toFixed(18);
    let  convert_usd = this.details.contract.convertBBDRateToBase(_amount);
    let res = await this.details.setBBDTokenRate(AppSettings.ZeroAddress, 6, convert_usd);
    // console.log("result" , res)

    if (res && res.success) {
      this.shared.alert.trigger({ action: 'success', message: 'Update BBD token successful!' }).then(() => {
        this.refresh.refreshComponent();
      });
    }
    else {
      this.shared.alert.trigger({ action: 'error', message: res.message });
    }
  }

  async getTokenRate() {
    try {
      const result = await this.details.TokenRate();
      if (result?.success) {
        const tokenRate = result.data;
        // console.log("BBD Token Rate ->", tokenRate);
        const readtokenRate = (1/this.details.contract.convertBBDRateFromBase(tokenRate)).toFixed(4);
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
