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
  styleUrls: ['./admin-layout.component.scss']
})
export class AdminLayoutComponent {

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
