import { Component, OnInit } from '@angular/core';
import { AppSettings } from 'src/app/app.settings';
@Component({
  selector: 'app-footer',
  templateUrl: './footer.component.html',
  styleUrls: ['./footer.component.scss']
})
export class FooterComponent{

  companyName: string = AppSettings.CompanyName;
  current_year = new Date().getFullYear();
}
