import { Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { firstValueFrom } from 'rxjs';
import { MatAlertComponent } from './mat-alert.component';
import { MatAlertConfig } from './models/mat-alert.config';
import { MatAlertResponse } from './models/mat-alert.responsoe';

@Injectable({
  providedIn: 'root'
})
export class MatAlertService {

  private default: MatAlertConfig = new MatAlertConfig();
  constructor(private dialog: MatDialog) { }


  async trigger(config: MatAlertConfig): Promise<MatAlertResponse> {
    const dialogRef = this.dialog.open(MatAlertComponent, {
      minWidth: '400px',
      data: {
        title: config.title,
        message: config.message,
        action: config.action,
        confirmButtonText: config.confirmButtonText ? config.confirmButtonText : this.default.confirmButtonText,
        confirmButtonTheme: config.confirmButtonTheme ? config.confirmButtonTheme : this.default.confirmButtonTheme,
        raisedButton: config.raisedButton ? config.raisedButton : this.default.raisedButton,
        hasBackdrop: config.hasBackdrop ? config.hasBackdrop : this.default.hasBackdrop,
        disableClose: config.disableClose ? config.disableClose : this.default.disableClose,
        denyButtonText: config.denyButtonText,
        denyButtonTheme: config.denyButtonTheme,
        cancelButtonText: config.cancelButtonText,
        cancelButtonTheme: config.cancelButtonTheme
      },
    });

    let returnValue = await firstValueFrom(dialogRef.afterClosed());

    return returnValue ? returnValue : {
      isConfirmed: false,
      isDenied: false,
      isCancelled: false,
      isDismissed: true
    };
  }
}
