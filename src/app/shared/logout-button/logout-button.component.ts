import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { app_routes } from 'src/app/app.settings';

@Component({
  selector: 'app-logout-button',
  templateUrl: './logout-button.component.html',
  styleUrls: ['./logout-button.component.scss']
})
export class LogoutButtonComponent {

  app_routes = app_routes;
  constructor(private router: Router) { }

  logout() {
    sessionStorage.removeItem("UserAddress");
    this.router.navigate([this.app_routes.login.url]);
  }
}
