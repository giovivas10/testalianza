
export class Address {
  id: number;
  active: boolean;
  address: string;
  city: string;
  cp: string;
  info: string;
  state: string;

  parseObj() { }
}

export class Client {
  id: number;
  active: boolean;
  cell: string;
  cell2: string;
  company: string;
  genInvoice: boolean;
  idAdress: number;
  identity: string;
  last_Name: string;
  name: string;
  messageToUser: string;
  description: string;


  parseObj() {

  
   }
}


export class ClientLazy {
  id: number;
  active: boolean;
  cell: string;
  cell2: string;
  company: string;
  genInvoice: boolean;
  idAdress: number;
  identity: string;
  last_Name: string;
  name: string;
  description: string;
  parseObj() {  }
}

export class SavingAccount {
  account: string;
  name: string;
  balance: string;
  active:boolean;

  constructor(account: string, name: string, balance: string, active:boolean) {
    this.account = account;
    this.name = name;
    this.balance = balance;
    this.active = active;
  }

  get description(): string {
    return `No.${this.account} [${this.name}] - Saldo ₡${Number(this.balance).toLocaleString()}`;
  }

  parseObj() { }
}

export class CreditCard {
  account: string;
  name: string;
  active:boolean;

  constructor(account: string, name: string, active:boolean) {
    this.account = account;
    this.name = name;
    this.active = active;
  }

  get description(): string {
    return `No.${this.account} [${this.name}]`;
  }

  parseObj() { }
}
