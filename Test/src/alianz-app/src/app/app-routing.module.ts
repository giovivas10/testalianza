import { NgModule, InjectionToken } from '@angular/core';
import { Routes, RouterModule, ActivatedRouteSnapshot } from '@angular/router';
import { AuthGuard } from './core/guards/auth.guard';
import { HomeComponent } from './home/home.component';

const externalUrlProvider = new InjectionToken('externalUrlRedirectResolver');
const deactivateGuard = new InjectionToken('deactivateGuard');

const routes: Routes = [

  {
    path: '', redirectTo: 'home', pathMatch: 'full'
  },
  {
    path: 'home', component: HomeComponent, canActivate: [AuthGuard]
  }
]


@NgModule({
  imports: [RouterModule.forRoot(routes, { useHash: true })],
  exports: [RouterModule],
  providers: [
     AuthGuard,
    {
      provide: externalUrlProvider,
      useValue: (route: ActivatedRouteSnapshot) => {
        const externalUrl = route.paramMap.get('externalUrl');
        window.open(externalUrl, '_self');
      },
    },
    {
      provide: deactivateGuard,
      useValue: () => {
        console.log('Guard function is called!')
        return false;
      }
    }

  ]
})
export class AppRoutingModule { }
