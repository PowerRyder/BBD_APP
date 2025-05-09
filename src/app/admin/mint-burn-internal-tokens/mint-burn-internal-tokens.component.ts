import { Component } from '@angular/core';
import { AppSettings } from 'src/app/app.settings';
import { SharedModule } from 'src/app/shared/shared.module';
import { SharedService } from 'src/app/shared/shared.service';
import { AdminService } from '../admin.service';

@Component({
  selector: 'app-mint-burn-internal-tokens',
  standalone: true,
  imports: [SharedModule],
  templateUrl: './mint-burn-internal-tokens.component.html',
  styleUrls: ['./mint-burn-internal-tokens.component.scss']
})
export class MintBurnInternalTokensComponent {

  userAddress: string = '';
  internalTokenAmount: number = 0;
  internalTokenName = AppSettings.InternalTokenName;

  constructor(private shared: SharedService, private contract: AdminService){ }

  async onMintClick(){

    let res = await this.contract.mintTokens(this.userAddress, Number(this.internalTokenAmount));
    // console.log("register", res)
    if (res && res.success) {
      this.shared.alert.trigger({action: 'success', message: 'Tokens minted successfully!'}).then(()=>{
        location.reload();
      });
    }
    else{
      this.shared.alert.trigger({action: 'error', message: res.message});
    }
  }

  async onBurnClick(){

    let res = await this.contract.burnTokens(this.userAddress, Number(this.internalTokenAmount));
    // console.log("register", res)
    if (res && res.success) {
      this.shared.alert.trigger({action: 'success', message: 'Tokens burnt successfully!'}).then(()=>{
        location.reload();
      });
    }
    else{
      this.shared.alert.trigger({action: 'error', message: res.message});
    }
  }
}
