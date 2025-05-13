import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { Constants } from './misc/app.constants';

const routes: Routes = [
  {
    path: '',
    loadChildren: () => import("./accounts/accounts.module").then(m => m.AccountsModule)
  },
  {
    path: 'u',
    loadChildren: () => import("./user/user.module").then(m => m.UserModule)
  },
  {
    path: 'a',
    loadChildren: () => import("./admin/admin.module").then(m => m.AdminModule)
  },
  {
    path: Constants.refresh,
    loadComponent: () => import("./shared/refresh/refresh.component").then(m => m.RefreshComponent),
    data: { preload: true }
  },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
