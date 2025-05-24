import { trigger, state, style, transition, animate } from '@angular/animations';
import { Breakpoints, BreakpointObserver } from '@angular/cdk/layout';
import { Component, ViewChild } from '@angular/core';
import { MatSidenav } from '@angular/material/sidenav';
import { Observable, map, shareReplay, firstValueFrom } from 'rxjs';
import { AppSettings, app_routes } from 'src/app/app.settings';
import { SharedModule } from 'src/app/shared/shared.module';

@Component({
  selector: 'app-admin-layout',
  templateUrl: './admin-layout.component.html',
  standalone: true,
  imports: [SharedModule],
  styleUrls: ['./admin-layout.component.scss'],
  animations: [
      trigger('slideInOut', [
        state('in', style({ height: '*', opacity: 1, padding: '8px 16px' })),
        state('out', style({ height: '0px', opacity: 0, padding: '0 16px' })),
        transition('out => in', [animate('250ms ease-out')]),
        transition('in => out', [animate('200ms ease-in')])
      ])
    ]
})
export class AdminLayoutComponent {

  @ViewChild('sidenav') sidenav: MatSidenav;

  logo: string = AppSettings.Logo;
  isInternalToken = AppSettings.IsInternalToken;
  isHandset$: Observable<boolean> = this.breakpointObserver.observe(Breakpoints.Handset).pipe(map(result => result.matches), shareReplay());

  isMenuOpen = false;
  // app_routes = app_routes;

  app_routes = {
    admin_dashboard :app_routes.admin_dashboard,
    // mint_burn :app_routes.admin_mint_burn_internal_tokens,
    // credit_debit :app_routes.admin_credit_debit_amount,
    // block_unblock :app_routes.admin_block_unblock_user,
    // withdrawal_fund : app_routes.admin_withdraw_funds,
    update_package_max_amount : app_routes.update_package_max_amount,
    update_BBD_token_rate : app_routes.update_BBD_token_rate
  };

  isSideNavOpen: boolean = false;
  constructor(private breakpointObserver: BreakpointObserver) {
  }

  async ngOnInit() {
    this.isSideNavOpen = await firstValueFrom(this.isHandset$)
  }

  handleMenuItemClick() {
    if (this.sidenav.mode === 'over') {
      this.sidenav.close();
    }
  }

  get visibleRoutes() {
    return Object.values(this.app_routes);
  }
}
