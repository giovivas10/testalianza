import { BrowserModule } from '@angular/platform-browser';
import { NgModule, CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MAT_DATE_LOCALE, MatToolbarModule, MatSidenavModule, MatFormFieldModule, MatInputModule, MatButtonModule, MatProgressBarModule, MatProgressSpinnerModule, MatIconModule, MatListModule, MatTableModule, MatSortModule, MatDialogModule, MatCheckboxModule, MatChipsModule, MatTooltipModule, MatExpansionModule, MatSelectModule, MatDatepickerModule, MatNativeDateModule, MatSlideToggleModule, MatTabsModule, MatStepperModule, MatRadioModule, MatRippleModule, MatSnackBarModule, MatButtonToggleModule } from '@angular/material';
import { HomeComponent } from './home/home.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { CommonModule } from '@angular/common';
import { NotFoundComponent } from './not-found.component';  // External Component not Found

import { MatCardModule } from '@angular/material/card';
import { JsonpModule } from '@angular/http';
import { DialogCustomComponent } from './core/components/dialog-custom/dialog-custom.component';
import { DialogConfirmComponent } from './core/components/dialog-confirm/dialog-confirm.component';

import {MatMenuModule} from '@angular/material/menu';

@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    NotFoundComponent, // External Error not Foun Page

    /* My Components commons */
    DialogConfirmComponent,
    DialogCustomComponent,

  ],
  imports: [
    MatMenuModule,
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule,
    CommonModule,

    JsonpModule,

    /* Material */
    MatToolbarModule,
    MatSidenavModule,
    MatFormFieldModule,
    MatInputModule,
    MatButtonModule,
    MatCardModule,
    MatProgressBarModule,
    MatProgressSpinnerModule,
    MatIconModule,
    MatListModule,
    MatTableModule,
    MatSortModule,
    MatDialogModule,
    MatCheckboxModule,
    MatChipsModule,
    MatTooltipModule,
    MatExpansionModule,
    MatSelectModule,
    MatDatepickerModule,
    MatNativeDateModule,
    MatSlideToggleModule,
    MatTabsModule,
    MatStepperModule,
    MatRadioModule,
    MatRippleModule,
    MatSnackBarModule,
    MatButtonToggleModule
  ],
  entryComponents: [
    DialogConfirmComponent,
    DialogCustomComponent
  ],
  providers: [
    { provide: MAT_DATE_LOCALE, useValue: 'es-CR' },
    // {
    //   provide: HTTP_INTERCEPTORS,
    //   useClass: AuthInterceptorService,
    //   multi: true
    // }
  ],
  schemas: [CUSTOM_ELEMENTS_SCHEMA],
  bootstrap: [AppComponent]
})
export class AppModule { }
