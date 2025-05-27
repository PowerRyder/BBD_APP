import { Component } from '@angular/core';
import { UntypedFormControl, UntypedFormGroup } from '@angular/forms';
import { RefreshService } from 'src/app/services/refresh.service';
import { SharedModule } from 'src/app/shared/shared.module';
import { SharedService } from 'src/app/shared/shared.service';
import { DetailsService } from 'src/app/user/services/details.service';

@Component({
  selector: 'app-update-address',
  standalone: true,
  imports: [SharedModule],
  templateUrl: './update-address.component.html',
  styleUrls: ['./update-address.component.scss']
})
export class UpdateAddressComponent {

  updateAddressForm: UntypedFormGroup

  constructor(private details: DetailsService , public shared :SharedService , private refresh :RefreshService) { this.createForm() }
  createForm() {
    this.updateAddressForm = new UntypedFormGroup({
      selectAdress: new UntypedFormControl({ value: '', disabled: false }),
      address: new UntypedFormControl({ value: '', disabled: false })
    })
  }

  async onSubmit() {
    let _sponsered_address = this.updateAddressForm.controls['address'].value;
    let _selectwallet = this.updateAddressForm.controls['selectAdress'].value;
    console.log("details", _selectwallet);
    console.log("details", _sponsered_address);
    let res = await this.details.updateAddress(_sponsered_address, _selectwallet, 0);

    if (res && res.success) {
      this.shared.alert.trigger({ action: 'success', message: 'Update BBD token successful!' }).then(() => {
        this.refresh.refreshComponent();
      });
    }
    else {
      this.shared.alert.trigger({ action: 'error', message: res.message });
    }
  }

}
