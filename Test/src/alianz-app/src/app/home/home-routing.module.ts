import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { HomeComponent } from './home.component';
import { AuthGuard } from '../core/guards/auth.guard';

const homeroutes: Routes = [
  {
    path: '', component: HomeComponent, canActivate: [AuthGuard],
    children: [
    ]

  },
];

@NgModule({
  imports: [RouterModule.forChild(homeroutes)],
  exports: [RouterModule],

})
export class HomeRoutingModule { }
