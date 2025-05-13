import { Component, Input, OnChanges, OnInit, SimpleChanges } from '@angular/core';
import { AppSettings } from 'src/app/app.settings';
import { dashboardTilesAppearance } from 'src/app/misc/app.custom-type';
import { SharedModule } from '../shared.module';

@Component({
  selector: 'app-dashboard-tiles',
  templateUrl: './dashboard-tiles.component.html',
  styleUrls: ['./dashboard-tiles.component.scss'],
  standalone: true,
  imports: [SharedModule]
})
export class DashboardTilesComponent implements OnInit, OnChanges {

  @Input() matIcon: string = '';
  @Input() title: string = '';
  @Input() data: { key: string, value: string | number}[] = [];
  @Input() appearance: dashboardTilesAppearance = AppSettings.dashboardTilesAppearance;
  @Input() badge: string = '';
  @Input() badgeText: string = '';

  firstRowData: { key: string, value: string | number }[] = [];
  secondRowData: { key: string, value: string | number }[] = [];

  constructor() { }

  ngOnChanges(changes: SimpleChanges): void {
    if (this.data.length > 0) {
      if (this.appearance == 'Two-Row') {
        {
          if (this.data.length <= 2) {
            this.firstRowData = this.data;
            this.secondRowData = [];
          }
          else {
            let noOfElemsInFirstRow = Math.ceil(this.data.length / 2);
            for (let i = 0; i < noOfElemsInFirstRow; i++) {
              this.firstRowData.push(this.data[i])
            }
            for (let i = noOfElemsInFirstRow; i < this.data.length; i++) {
              this.secondRowData.push(this.data[i])
            }
          }
        }
      }
    }
  }

  ngOnInit(): void {
  }
}
