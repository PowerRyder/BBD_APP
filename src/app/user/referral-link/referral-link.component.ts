import { Component, Input, OnInit } from '@angular/core';
import { SharedModule } from 'src/app/shared/shared.module';
import { SharedService } from 'src/app/shared/shared.service';

@Component({
  selector: 'app-referral-link',
  templateUrl: './referral-link.component.html',
  standalone: true,
  imports: [SharedModule],
  styleUrls: ['./referral-link.component.scss']
})
export class ReferralLinkComponent implements OnInit {

  @Input() text: string = '';
  @Input() displayValue: string = '';
  @Input() url: string = '';

  // referralLink: string = AppSettings.Website+app_routes.register.url.slice(1)+'/'+sessionStorage.getItem('UserAddress');
  constructor(private shared: SharedService) { }

  ngOnInit(): void {
  }

  copyToClipboard(text: string) {
    this.shared.clipboard.copy(text)
    this.shared.toast.add({ severity: 'success', summary: 'Copied to clipboard' });
  }

}
