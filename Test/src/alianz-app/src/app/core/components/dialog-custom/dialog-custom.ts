export enum DialogType {
  Default = 'default',
  Success = 'success',
  Danger = 'alert',
}

export interface DialogCustomData {
  title: string;
  message: string;
  dialogType: DialogType;
}
