import { Component, OnInit, ViewChild } from '@angular/core';
import { AppSettings, app_routes } from 'src/app/app.settings';
import { BreakpointObserver, Breakpoints } from '@angular/cdk/layout';
import { Observable, map, shareReplay, firstValueFrom } from 'rxjs';
import { MatSidenav } from '@angular/material/sidenav';

@Component({
  selector: 'app-user-layout',
  templateUrl: './user-layout.component.html',
  styleUrls: ['./user-layout.component.scss']
})
export class UserLayoutComponent implements OnInit {
  
  @ViewChild('sidenav') sidenav: MatSidenav;

  logo: string = AppSettings.Logo;
  isInternalToken = AppSettings.IsInternalToken;
  isHandset$: Observable<boolean> = this.breakpointObserver.observe(Breakpoints.Handset).pipe(map(result => result.matches), shareReplay());

  app_routes = app_routes;

  isSideNavOpen: boolean = false;
  constructor(private breakpointObserver: BreakpointObserver){
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
