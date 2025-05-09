import { Injectable } from "@angular/core";
import { AbstractControl, ValidationErrors, ValidatorFn, Validators } from "@angular/forms";

@Injectable({
    providedIn: 'root'
})
export class CustomValidatorsService {
    public required = [Validators.required]
    public userId = [Validators.minLength(5), Validators.maxLength(50)]
    public userIdRequired = [Validators.required, ...this.userId]

    public exactLengthValidator(length: number): ValidatorFn {
        return (control: AbstractControl): ValidationErrors | null => {
            const value = control.value;

            if (!value) {
                return null;
            }

            if (value.length != length) {
                return { 'exactlength': length }
            }
            return null;
        }
    }
}

