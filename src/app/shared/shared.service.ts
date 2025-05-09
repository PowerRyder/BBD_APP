import { Inject, Injectable } from '@angular/core';
import { Clipboard } from '@angular/cdk/clipboard';
import { MessageService } from 'primeng/api';
import { MatAlertService } from './mat-alert/mat-alert.service';
import { CustomValidatorsService } from './validators.service';

@Injectable({
  providedIn: "root"
})
export class SharedService {

  constructor(@Inject(MessageService) public toast: MessageService, 
  @Inject(Clipboard) public clipboard: Clipboard, 
  @Inject(MatAlertService) public alert: MatAlertService,
  @Inject(CustomValidatorsService) public validators: CustomValidatorsService) { }

  convertTimestampToDate(timestamp: number): Date {
    // Convert the timestamp from seconds to milliseconds
    return new Date(timestamp * 1000);
  }
}
