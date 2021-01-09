import {Component, Inject} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';
import { DialogCustomData, DialogType } from './dialog-custom';

@Component({
  selector: 'app-dialog-custom',
  templateUrl: './dialog-custom.component.html',
  styleUrls: ['./dialog-custom.component.css']
})
export class DialogCustomComponent {

  constructor(
    public dialogRef: MatDialogRef<DialogCustomComponent>,
    @Inject(MAT_DIALOG_DATA) public data: DialogCustomData) {

    if (!data.title) {
      switch (data.dialogType) {
        case DialogType.Default: data.title = 'Mensaje'; break;
        case DialogType.Success: data.title = 'Felicidades!'; break;
        case DialogType.Danger: data.title = 'Lo sentimos!'; break;
        default: data.title = 'Mensaje'; break;
      }
    }

    if (!data.message) {
      switch (data.dialogType) {
        case DialogType.Default: data.message = 'Mensaje para usuario'; break;
        case DialogType.Success: data.message = 'Proceso realizado correctamente'; break;
        case DialogType.Danger: data.message = 'No se puede realizar el proceso en este momento'; break;
        default: data.message = ''; break;
      }
    }
  }

  get classCSS(): string {
    return this.data.dialogType ? this.data.dialogType.toString() : 'default';
  }

  get icon(): string {
    switch (this.data.dialogType) {
      case DialogType.Success: return 'check_circle';
      case DialogType.Danger: return 'clear';
      default: return null;
    }
  }

}
