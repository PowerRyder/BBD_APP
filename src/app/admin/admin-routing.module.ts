import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { app_routes } from '../app.settings';

const routes: Routes = [
  {
    path: '',
    loadComponent: () => import('./admin-layout/admin-layout.component').then(m => m.AdminLayoutComponent),
    children: [
      {
        path: app_routes.admin_dashboard.path,
        loadComponent: () => import('./admin-dashboard/admin-dashboard.component').then(m => m.AdminDashboardComponent),
        title: app_routes.admin_dashboard.title
      },
      {
        path: app_routes.admin_mint_burn_internal_tokens.path,
        loadComponent: () => import('./mint-burn-internal-tokens/mint-burn-internal-tokens.component').then(m => m.MintBurnInternalTokensComponent),
        title: app_routes.admin_mint_burn_internal_tokens.title
      },
      {
        path: app_routes.admin_credit_debit_amount.path,
        loadComponent: () => import('./credit-debit-amount/credit-debit-amount.component').then(m => m.CreditDebitAmountComponent),
        title: app_routes.admin_credit_debit_amount.title
      },
      {
        path: app_routes.admin_block_unblock_user.path,
        loadComponent: () => import('./block-unblock-user/block-unblock-user.component').then(m => m.BlockUnblockUserComponent),
        title: app_routes.admin_block_unblock_user.title
      },
      {
        path: app_routes.admin_withdraw_funds.path,
        loadComponent: () => import('./withdraw/withdraw.component').then(m => m.WithdrawComponent),
        title: app_routes.admin_withdraw_funds.title
      },
      {
        path:app_routes.update_package_max_amount.path,
        loadComponent:()=>import("./update-package-max-amount/update-package-max-amount.component").then(m=>m.UpdatePackageMaxAmountComponent)
      },
      {
        path:app_routes.update_BBD_token_rate.path,
        loadComponent:()=>import("./update-bbd-token-rate/update-bbd-token-rate.component").then(m=>m.UpdateBBDTokenRateComponent)
      },
      {
        path:app_routes.update_address.path,
        loadComponent:()=>import("./update-address/update-address.component").then(m=>m.UpdateAddressComponent)
      }
    ]
  }];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AdminRoutingModule { }
