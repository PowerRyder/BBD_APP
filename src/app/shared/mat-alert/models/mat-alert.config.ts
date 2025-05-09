import { SafeHtml } from '@angular/platform-browser';

export class MatAlertConfig {
  title?: string = '';
  message?: string | SafeHtml;
  action?: 'success' | 'warning' | 'error' | 'info' | 'question';
  confirmButtonText?: string = 'OK';
  confirmButtonTheme?: string = 'primary';
  denyButtonText?: string = 'Deny';
  denyButtonTheme?: string = 'warn';
  cancelButtonText?: string = 'Cancel';
  cancelButtonTheme?: string = 'default';
  raisedButton?: boolean = true;
  hasBackdrop?: boolean = true;
  disableClose?: boolean = false;
}
