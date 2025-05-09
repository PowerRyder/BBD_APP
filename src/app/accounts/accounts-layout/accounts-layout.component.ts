import { Component } from '@angular/core';
import { AppSettings } from 'src/app/app.settings';

@Component({
  selector: 'app-accounts-layout',
  templateUrl: './accounts-layout.component.html',
  styleUrls: ['./accounts-layout.component.scss']
})
export class AccountsLayoutComponent {

  logo: string = AppSettings.Logo;
}
