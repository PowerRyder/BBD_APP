import { NgModule } from '@angular/core';

import { SharedModule } from '../shared/shared.module';
import { AccountsLayoutComponent } from './accounts-layout/accounts-layout.component';
import { AccountsRoutingModule } from './accounts-routing.module';


@NgModule({
  declarations: [
    AccountsLayoutComponent
  ],
  imports: [
    AccountsRoutingModule,
    SharedModule
  ]
})
export class AccountsModule { }
