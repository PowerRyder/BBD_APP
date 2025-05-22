import { Component, OnInit } from '@angular/core';
import { SharedModule } from 'src/app/shared/shared.module';
import { DetailsService } from '../services/details.service';
import { AccountsService } from 'src/app/accounts/accounts.service';

@Component({
  selector: 'app-top-three',
  standalone: true,
  imports: [SharedModule],
  templateUrl: './top-three.component.html',
  styleUrls: ['./top-three.component.scss']
})
export class TopThreeComponent implements OnInit {
  // dataSource: any[] = []
  data : any []=[]
  constructor(private details: DetailsService , public accounts : AccountsService) { }

  async ngOnInit() {
   let details = await (await this.details.gettopsponseredReport()).data
    this.data = details
    console.log("deta", this.data)
  }

}
