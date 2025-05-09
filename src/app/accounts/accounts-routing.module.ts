import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { app_routes } from '../app.settings';
import { AccountsLayoutComponent } from './accounts-layout/accounts-layout.component';
import { LoginComponent } from './login/login.component';
import { RegisterComponent } from './register/register.component';

const routes: Routes = [
  {
    path: '',
    component: AccountsLayoutComponent,
    children: [
      {
        path: '',
        component: LoginComponent,
        title: app_routes.login.title
      },
      {
        path: app_routes.login.path,
        component: LoginComponent,
        title: app_routes.login.title
      },
      {
        path: app_routes.admin_login.path,
        loadComponent: () => import('./admin-login/admin-login.component').then(m => m.AdminLoginComponent),
        title: app_routes.admin_login.title
      },
      {
        path: app_routes.register.path,
        component: RegisterComponent,
        title: app_routes.register.title
      },
      {
        path: app_routes.register.path+"/:spId",
        component: RegisterComponent,
        title: app_routes.register.title
      }
    ]
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AccountsRoutingModule { }
