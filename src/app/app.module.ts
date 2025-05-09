import { ErrorHandler, NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { TitleStrategy } from '@angular/router';
import { AppPageTitleStrategyService } from './misc/app-page-title-strategy.service';
import { NgxSpinnerModule } from 'ngx-spinner';
import { ToastModule } from 'primeng/toast';
import { MatAlertModule } from './shared/mat-alert/mat-alert.module';
import { MAT_FORM_FIELD_DEFAULT_OPTIONS } from '@angular/material/form-field';
import { MessageService } from 'primeng/api';
import { AppSettings } from './app.settings';
import { MatAlertService } from './shared/mat-alert/mat-alert.service';
import { GlobalErrorHandler } from './shared/global-error-handler';

@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    MatAlertModule,
    ToastModule,
    NgxSpinnerModule.forRoot({ type: 'ball-climbing-dot' })
  ],
  providers: [
    { provide: 'Window',  useValue: window },
    // { provide: ErrorHandler, useClass: GlobalErrorHandler, },
    { provide: TitleStrategy, useClass: AppPageTitleStrategyService },
    { provide: MAT_FORM_FIELD_DEFAULT_OPTIONS, useValue: { floatLabel: 'auto', hideRequiredMarker: AppSettings.matFormFieldHideRequiredMarker, appearance: AppSettings.matFormFieldAppearance } },
    MessageService,
    MatAlertService
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
