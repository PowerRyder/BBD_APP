import { NgModule } from '@angular/core';

import { SharedModule } from '../shared/shared.module';
import { UserLayoutComponent } from './user-layout/user-layout.component';
import { UserRoutingModule } from './user-routing.module';


@NgModule({
  declarations: [
    UserLayoutComponent,
    
  ],
  imports: [
    SharedModule,
    UserRoutingModule
  ]
})
export class UserModule { }
