import { Component, OnInit, ViewChild } from '@angular/core';
import { AppSettings, app_routes } from 'src/app/app.settings';
import { BreakpointObserver, Breakpoints } from '@angular/cdk/layout';
import { Observable, map, shareReplay, firstValueFrom } from 'rxjs';
import { MatSidenav } from '@angular/material/sidenav';
import { trigger, state, style, transition, animate } from '@angular/animations';

@Component({
  selector: 'app-user-layout',
  templateUrl: './user-layout.component.html',
  styleUrls: ['./user-layout.component.scss'],
  animations: [
    trigger('slideInOut', [
      state('in', style({ height: '*', opacity: 1, padding: '8px 16px' })),
      state('out', style({ height: '0px', opacity: 0, padding: '0 16px' })),
      transition('out => in', [animate('250ms ease-out')]),
      transition('in => out', [animate('200ms ease-in')])
    ])
  ]
})
export class UserLayoutComponent implements OnInit {

  @ViewChild('sidenav') sidenav: MatSidenav;

  logo: string = AppSettings.Logo;
  isInternalToken = AppSettings.IsInternalToken;
  isMenuOpen = false;
  isHandset$: Observable<boolean> = this.breakpointObserver.observe(Breakpoints.Handset).pipe(map(result => result.matches), shareReplay());

  isSideNavOpen: boolean = false;

  app_routes = {
    user_dashboard: app_routes.user_dashboard,
    directs: app_routes.directs,
    roi_income_history: app_routes.roi_income_history,
    level_income: app_routes.level_income,
    rank_info: app_routes.rank_info,
    topup: app_routes.topup,
    transfer_fund: app_routes.transfer_fund,
    deposit: app_routes.deposit,
    withdraw: app_routes.withdraw,
    buy_token :app_routes.buy_token

  };
  constructor(private breakpointObserver: BreakpointObserver) {
  }

  get visibleRoutes() {
    return Object.values(this.app_routes);
  }

  async ngOnInit() {
    this.isSideNavOpen = await firstValueFrom(this.isHandset$)
  }

  handleMenuItemClick() {
    if (this.sidenav.mode === 'over') {
      this.sidenav.close();
    }
  }
}
