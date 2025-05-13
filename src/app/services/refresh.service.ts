import { LocationStrategy } from '@angular/common';
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { Constants } from '../misc/app.constants';

@Injectable({
  providedIn: 'root'
})
export class RefreshService {

  constructor(private router: Router, private location: LocationStrategy) { }


  refreshComponent(do_check_user: boolean = true) {
    let path = this.location.path();

    // if (do_check_user) {
    //   if (this.auth.isAdmin) {
    //     refresh_url = app_routes.admin.url + refresh_url;
    //   }
    //   else if (this.auth.isUser) {
    //     refresh_url = app_routes.user.url + refresh_url;
    //   }
    //   else if (this.auth.isFranchise) {
    //     refresh_url = app_routes.franchise.url + refresh_url;
    //   }
    // }
    this.router.navigateByUrl(Constants.refresh, { skipLocationChange: true }).then(() => {
      this.router.navigate([path]);
    });
  }

}
