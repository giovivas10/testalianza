import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Router } from '@angular/router';
import { environment } from '../../../environments/environment';
import { MatDialog } from '@angular/material';
import 'url-search-params-polyfill';

@Injectable()
export abstract class GenericService  {

  private static KEY_TOKEN_EXPIRED_MESSAGE = 'token_expired_message';
  protected readonly _baseUrl = '';//Services.BASE_URL_API;
  protected _endPoint: string = "";
  protected _name: string;

  protected httpOptions = {
    headers: new HttpHeaders({
      'Authorization': 'Bearer ' + localStorage.getItem('token'),
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Cache-Control': 'no-cache',
      'Access-Control-Allow-Origin': '*'
    })
  };

  protected httpSecurityOptions = {
    headers: new HttpHeaders({
      'Authorization': 'Bearer ' + localStorage.getItem('token'),
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Cache-Control': 'no-cache',
      'Access-Control-Allow-Origin': '*'
    })
  }

  protected constructor(
    protected http: HttpClient,
    public router: Router,
    protected dialog: MatDialog) {
    this._baseUrl = '';//Services.BASE_URL_API;
  }

  get version(): string {
    return environment.version;
  }
}
