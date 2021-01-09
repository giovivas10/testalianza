import { Injectable } from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {GenericService} from './generic.service';
import {Router} from '@angular/router';
import {MatDialog} from '@angular/material';

@Injectable()
export class LogService extends GenericService {

  constructor(protected http: HttpClient, public router: Router, protected dialog: MatDialog) {
    super(http, router, dialog);
  }

}
