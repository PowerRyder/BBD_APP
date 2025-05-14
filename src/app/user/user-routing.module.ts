import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { app_routes } from '../app.settings';
import { UserLayoutComponent } from './user-layout/user-layout.component';

const routes: Routes = [
  {
    path: '',
    component: UserLayoutComponent,
    children: [
      {
        path: app_routes.user_dashboard.path,
        loadComponent: () => import('./user-dashboard/user-dashboard.component').then(m => m.UserDashboardComponent),
        title: app_routes.user_dashboard.title
      },
      {
        path: app_routes.directs.path,
        loadComponent: () => import('./directs/directs.component').then(m => m.DirectsComponent),
        title: app_routes.directs.title
      },
      {
        path: app_routes.level_income.path,
        loadComponent: () => import('./level-income/level-income.component').then(m => m.LevelIncomeComponent),
        title: app_routes.level_income.title
      },
      {
        path: app_routes.withdrawal_level_income.path,
        loadComponent: () => import('./withdrawal-level-income/withdrawal-level-income.component').then(m => m.WithdrawalLevelIncomeComponent),
        title: app_routes.withdrawal_level_income.title
      },
      {
        path: app_routes.topup.path,
        loadComponent: () => import('./topup/topup.component').then(m => m.TopupComponent),
        title: app_routes.topup.title
      },
      {
        path: app_routes.deposit.path,
        loadComponent: () => import('./deposit/deposit.component').then(m => m.DepositComponent),
        title: app_routes.deposit.title
      },
      {
        path: app_routes.sell_tokens.path,
        loadComponent: () => import('./sell-tokens/sell-tokens.component').then(m => m.SellTokensComponent),
        title: app_routes.sell_tokens.title
      },
      {
        path: app_routes.withdraw.path,
        loadComponent: () => import('./withdraw/withdraw.component').then(m => m.WithdrawComponent),
        title: app_routes.withdraw.title
      },
      {
        path:app_routes.transfer_fund.path,
        loadComponent:() =>import("./transfer-fund/transfer-fund.component").then(m=>m.TransferFundComponent)
      },
      {
        path:app_routes.roi_income_history.path,
        loadComponent:()=>import("./roi-income/roi-income.component").then(m=>m.RoiIncomeComponent)
      },
      {
        path:app_routes.rank_info.path,
        loadComponent:()=>import("./get-rank-info/get-rank-info.component").then(m=>m.GetRankInfoComponent)
      }
    ]
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class UserRoutingModule { }
