import { HttpErrorResponse } from "@angular/common/http";
import { Injectable, ErrorHandler, NgZone } from "@angular/core";
import { SharedService } from "./shared.service";

@Injectable()
export class GlobalErrorHandler implements ErrorHandler {
    constructor(
        private shared: SharedService,
        private zone: NgZone
    ) { }

    handleError(error: any) {
        // Check if it's an error from an HTTP response

        // if (!(error instanceof HttpErrorResponse)) {
        //     error = error.rejection; // get the error object
        // }
        // this.zone.run(() =>
        //     this.shared.alert.trigger({
        //         action: 'error',
        //         message: error?.message || 'Undefined client error'
        //     })
        // );

        // console.error('Error from global error handler', error);

    }
}