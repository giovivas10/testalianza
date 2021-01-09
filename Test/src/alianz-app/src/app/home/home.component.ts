import { Component, OnInit, AfterViewInit, ChangeDetectorRef } from '@angular/core';
import { JwtHelperService } from '@auth0/angular-jwt';
import { MediaMatcher } from '@angular/cdk/layout';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css'],
  providers: []
})
export class HomeComponent implements OnInit {

  footer: string;
  tokenHelper = new JwtHelperService();
  height: number;
  token: string
  userSystem: any;

  displayedColumns: string[] = ['SharedKey', 'BussinesId', 'Email', 'Phone', 'DataAdded'];
  dataSource = ELEMENT_DATA;


  ngOnInit() {

  }

  mobileQuery: MediaQueryList;
  private _mobileQueryListener: () => void;

  constructor(changeDetectorRef: ChangeDetectorRef, media: MediaMatcher) {
    this.mobileQuery = media.matchMedia('(max-width: 600px)');
    this._mobileQueryListener = () => changeDetectorRef.detectChanges();
    this.mobileQuery.addListener(this._mobileQueryListener);
  }

  ngOnDestroy(): void {
    this.mobileQuery.removeListener(this._mobileQueryListener);
  }

}

const ELEMENT_DATA: PeriodicElement[] = [
  { SharedKey: 'jgutierrez', BussinesId: 'Juliana Gutierrez', Email: 'jgutierrez@gmail.com', Phone: '3219876543', DataAdded: new Date() }
];

export interface PeriodicElement {
  SharedKey: string;
  BussinesId: String;
  Email: String;
  Phone: string;
  DataAdded: Date;
}
