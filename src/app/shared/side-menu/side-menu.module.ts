import { NgModule } from '@angular/core';
import { RouterModule } from '@angular/router';
import { SharedModule } from '../shared.module';
import { SideMenuComponent } from './side-menu.component';


@NgModule({
  declarations: [
    SideMenuComponent
  ],
  imports: [
    SharedModule,
    RouterModule
  ],
  exports: [
    SideMenuComponent
  ]
})
export class SideMenuModule { }
