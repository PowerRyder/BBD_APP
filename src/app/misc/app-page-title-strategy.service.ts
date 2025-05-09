import { Injectable } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { RouterStateSnapshot, TitleStrategy } from '@angular/router';
import { AppSettings } from '../app.settings';

@Injectable({
  providedIn: 'root'
})
export class AppPageTitleStrategyService extends TitleStrategy {

  constructor(private readonly title: Title) {
    super();
  }

  updateTitle(snapshot: RouterStateSnapshot): void {
    const title = this.buildTitle(snapshot);
    if (title) {
      this.title.setTitle(`${AppSettings.CompanyName} | ${title}`);
    }
    else{
      this.title.setTitle(`${AppSettings.CompanyName}`);
    }
  }

}
