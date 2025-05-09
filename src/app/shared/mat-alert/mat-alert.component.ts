import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatAlertConfig } from './models/mat-alert.config';

@Component({
  selector: 'app-mat-alert',
  templateUrl: './mat-alert.component.html',
  styleUrls: ['./mat-alert.component.scss']
})
export class MatAlertComponent implements OnInit {

  constructor(
    public dialogRef: MatDialogRef<MatAlertComponent>,
    @Inject(MAT_DIALOG_DATA) public data: MatAlertConfig) { }

  ngOnInit(): void {
  }

  closeDialog(event: 'deny' | 'confirm' | 'cancel') {
    this.dialogRef.close({
      isConfirmed: event === 'confirm',
      isDenied: event === 'deny',
      isCancelled: event === 'cancel',
      isDismissed: false
    });
  }
}
