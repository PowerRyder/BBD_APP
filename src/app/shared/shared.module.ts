import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { FooterModule } from './footer/footer.module';
import { LogoutButtonComponent } from './logout-button/logout-button.component';
import { MaterialModule } from './material.module';
import { TextValidationMessageComponent } from './text-validation-message/text-validation-message.component';
import { RouterModule } from '@angular/router';



@NgModule({
  declarations: [
    TextValidationMessageComponent,
    LogoutButtonComponent
  ],
  imports: [
    CommonModule,
    MaterialModule,
    RouterModule 
  ],
  exports: [
    TextValidationMessageComponent,
    LogoutButtonComponent,
    CommonModule,
    MaterialModule,
    RouterModule,
    ReactiveFormsModule,
    FormsModule,
    FooterModule,
    // SideMenuModule
  ]
})
export class SharedModule { }
