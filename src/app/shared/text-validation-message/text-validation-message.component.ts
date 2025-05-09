import { Component, Input, OnInit, SimpleChanges } from '@angular/core';
import { FormGroupDirective } from '@angular/forms';

@Component({
  selector: 'app-text-validation-message',
  templateUrl: './text-validation-message.component.html',
  styleUrls: ['./text-validation-message.component.scss']
})
export class TextValidationMessageComponent implements OnInit {

  @Input() fieldName: string;
  @Input() formGroupDirective: FormGroupDirective;

  @Input() regexErrorMessage: string ='';

  control: any;
  constructor() { }

  ngOnInit(): void {
  }

  ngOnChanges(changes: SimpleChanges) {
    if(changes['fieldName'] && !!this.formGroupDirective)
    {
      // console.log(this.formGroupDirective)
      this.control = this.formGroupDirective.form.controls[this.fieldName];

      // console.log(this.control)
      // this.control.valueChanges.subscribe(()=>{
      //   console.log(this.control)
      // })

      // this.formGroupDirective.ngSubmit.subscribe(()=>{
      //   console.log(this.formGroupDirective.submitted, !!this.control.errors, this.control.dirty, this.control.touched)
      // })
    }
  }
  
}
