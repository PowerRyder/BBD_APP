import { Component } from '@angular/core';
import { AppSettings } from 'src/app/app.settings';
import { SharedModule } from 'src/app/shared/shared.module';
import { SharedService } from 'src/app/shared/shared.service';
import { AdminService } from '../admin.service';

@Component({
  selector: 'app-block-unblock-user',
  standalone: true,
  imports: [SharedModule],
  templateUrl: './block-unblock-user.component.html',
  styleUrls: ['./block-unblock-user.component.scss']
})
export class BlockUnblockUserComponent {

  userAddress: string = '';
  paymentToken = AppSettings.PaymentTokenSymbol;

  constructor(private shared: SharedService, private contract: AdminService){ }

  async onBlockClick(){

    let res = await this.contract.blockUser(this.userAddress);
    // console.log("register", res)
    if (res && res.success) {
      this.shared.alert.trigger({action: 'success', message: 'User blocked successfully!'}).then(()=>{
        location.reload();
      });
    }
    else{
      this.shared.alert.trigger({action: 'error', message: res.message});
    }
  }

  async onUnblockClick(){

    let res = await this.contract.unblockUser(this.userAddress);
    // console.log("register", res)
    if (res && res.success) {
      this.shared.alert.trigger({action: 'success', message: 'User unblocked successfully!'}).then(()=>{
        location.reload();
      });
    }
    else{
      this.shared.alert.trigger({action: 'error', message: res.message});
    }
  }
}
