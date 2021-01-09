import { Injectable } from '@angular/core';
import { CanActivate, ActivatedRouteSnapshot, RouterStateSnapshot, Router } from '@angular/router';
import { MatSnackBar } from '@angular/material/snack-bar';
import { Observable } from 'rxjs';
import { GenericService } from '../services/core';

@Injectable()
export class ReportAccountingGuard implements CanActivate {

  constructor(private router: Router, public snackBar: MatSnackBar) { }

  canActivate(next: ActivatedRouteSnapshot, state: RouterStateSnapshot):
    Observable<boolean> | Promise<boolean> | boolean {

    if (this.hasPermission(state.url)) {
      return true;
    }

    return false;
  }

  private hasPermission(url: string): boolean {

    return false;
  }
}
