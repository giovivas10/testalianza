INSERT INTO "Def_Function"
("Function", "Description", "IdAction")
VALUES(3, 'ExitTrips', 1);
INSERT INTO "Def_Function"
("Function", "Description", "IdAction")
VALUES(2, 'ExitTrips', 0);
INSERT INTO "Def_Function"
("Function", "Description", "IdAction")
VALUES(1, 'EntryTrips', 0);
INSERT INTO "Def_Function"
("Function", "Description", "IdAction")
VALUES(0, 'ExitTrips', 0);
INSERT INTO "Def_Function"
("Function", "Description", "IdAction")
VALUES(4, 'ExitTrips', 2);
INSERT INTO "Def_Function"
("Function", "Description", "IdAction")
VALUES(5, 'ExitTrips', 2);
INSERT INTO "Def_TypeofConnection"
("TypeofConnection", "Description", "IdAction")
VALUES(0, 'Default', 0);
commit;
INSERT INTO "Def_TypeofConnection"
("TypeofConnection", "Description", "IdAction")
VALUES(1, 'Default', 1);
INSERT INTO "Def_Site"
("IdSite", "Action", "Active", "Address", "Cod", "Description", "Detail", "IdCountry", "IdDataCenter", "IdProvider", "Image", "Lat", "Logic", "Lon", "TokenExpired", "ValetParking")
VALUES(-1, 1, false, NULL, '000000', 'Todos Los Sitios', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL);
commit;
INSERT INTO "TrfUser"
("Id", "Name", "LastName", "Department", "CreatedBy", "Active", "DateCreated", "DateExpired", "DateUpdated", "Email",
"Password", "PwdExpired", "IdSite")
VALUES(1, 'ETC', 'ETC Peajes Electronicos', 'TI', 'etc@etc-latam.com', true, '2020-01-21 15:08:00.840', NULL, NULL, 'etc@etc-latam.com', 'gieZQBan8/5qFiaJi2+TV3kLOuv7xPvBDOyHNnwvvfeLtMXGasg6ba7zvu5Z8CnfpoBgsT3qW/xx
C3T6tUO49g==', NULL, -1);
insert into "TrfRole"
("Id", "Name", "Description", "Active", "DateCreated")
values(1, 'Administrador', 'Administrador del Sistema', true, '2020-01-22 16:16:49.048');
INSERT INTO "TrfUser_Role_Site"
("IdRole", "IdSite", "IdUser", "DateCreated")
VALUES(1, -1, 1, now());
commit;
insert into "TrfMenu"
("IdMenu", "IdSubMenu", "Name", "Description", "Icon", "WebPage", "DateCreated")
values(1, 0, 'Administracion', 'Modulo de Administracion', null, null, '2020-01-22 16:16:18.934');
insert into "TrfMenu"
("IdMenu", "IdSubMenu", "Name", "Description", "Icon", "WebPage", "DateCreated")
values(1, 1, 'Parametros', 'Parametros del Sistema', null, 'https://etcparking.etcpeajes.com:8446/#/param', '2020-01-22 16:16:18.938');
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(1, 2, '2020-01-29 14:47:45.745', 'Schedules', NULL, 'Schedules', 'https://etcparking.etcpeajes.com:8454/#/schedule');
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(1, 3, '2020-01-29 14:47:45.745', 'Acciones', NULL, 'Acciones', 'https://etcparking.etcpeajes.com:8454/#/def-action');
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(1, 4, '2020-01-22 16:16:18.000', 'Cuerpos de Correos', NULL, 'Cuerpos de Correos', 'https://etcparking.etcpeajes.com:8445/#/body');
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(2, 0, '2020-01-22 16:16:18.934', 'Modulo de Seguridad', NULL, 'Seguridad', NULL);
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(2, 1, '2020-01-29 14:47:45.745', 'Rol', NULL, 'Rol', 'https://etcparking.etcpeajes.com:8445/#/rol');
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(2, 2, '2020-01-30 16:16:18.938', 'Menu', '', 'Menu', 'https://etcparking.etcpeajes.com:8445/#/menu');
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(2, 3, '2020-01-30 16:16:18.938', 'Usuarios', '', 'Usuarios', 'https://etcparking.etcpeajes.com:8445/#/user');
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(2, 4, '2020-01-30 16:16:18.000', 'Dashboard', NULL, 'Dashboard', 'https://etcparking.etcpeajes.com:8445/#/dashboard');
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(3, 0, NULL, 'Modulo Subscriptores', NULL, 'Subscriptores', NULL);
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(3, 1, '2020-01-30 16:16:18.000', 'Subscriptores', NULL, 'Subscriptores', 'https://etcparking.etcpeajes.com:8448/#/subscribers');
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(3, 2, '2020-01-30 16:16:18.000', 'Grupos de Subscriptores', NULL, 'Grupos', 'https://etcparking.etcpeajes.com:8448/#/groups');
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(4, 0, '2020-03-23 16:16:18.934', 'Modulo de Tarifas', 'monetization_on', 'Tarifas', NULL);
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(4, 2, '2020-03-23 14:47:45.745', 'Administración de Plantillas', 'list_alt', 'Administración de Plantillas', 'https://etcparking.etcpeajes.com:8449/#/trftemplate');
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(4, 3, '2020-03-23 14:47:45.745', 'Wizzard', 'star', 'Wizzard', 'https://etcparking.etcpeajes.com:8449/#/trfratecreate');
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(4, 1, '2020-03-23 14:47:45.745', 'Configuración Detallada', 'tab', 'Configuración Detallada', 'https://etcparking.etcpeajes.com:8449/#/trfrate');
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(4, 5, '2020-04-24 18:34:06.883', 'Proyección', 'insert_chart', 'Proyeccion', 'https://etcparking.etcpeajes.com:8449/#/Export');
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "Name", "Description", "Icon", "WebPage", "DateCreated")
values(5, 0, 'Descuentos', 'Modulo de Descuentos', null, null, '2020-01-22 16:16:18.934');
insert into "TrfMenu" ("IdMenu", "IdSubMenu", "Name", "Description", "Icon", "WebPage", "DateCreated")
values(5, 1, 'Configuración', 'Configuración Detallada  Descuentos', null, 'https://etcparking.etcpeajes.com:8447/#/disco-conf', '2020-01-29 14:47:45.745');
insert into "TrfMenu" ("IdMenu", "IdSubMenu", "Name", "Description", "Icon", "WebPage", "DateCreated")
values(5, 2, 'Generación', 'Generación de QR', null, 'https://etcparking.etcpeajes.com:8447/#/disco-generator-menu', '2020-01-29 14:47:45.745');
insert into "TrfMenu" ("IdMenu", "IdSubMenu", "Name", "Description", "Icon", "WebPage", "DateCreated")
values(5, 3, 'Pendientes', 'Descuentos Pendientes de Aplicar', null, 'https://etcparking.etcpeajes.com:8447/#/disco-pend', '2020-01-29 14:47:45.745');
insert into "TrfMenu" ("IdMenu", "IdSubMenu", "Name", "Description", "Icon", "WebPage", "DateCreated")
values(5, 4, 'Aplicados', 'Descuentos Aplicados', null, 'https://etcparking.etcpeajes.com:8447/#/disco-applied', '2020-01-29 14:47:45.745');
insert into "TrfMenu" ("IdMenu", "IdSubMenu", "Name", "Description", "Icon", "WebPage", "DateCreated")
values(5, 5, 'Descartados', 'Descuentos Descartados', null, 'https://etcparking.etcpeajes.com:8447/#/disco-dis', '2020-01-29 14:47:45.745');
insert into "TrfMenu" ("IdMenu", "IdSubMenu", "Name", "Description", "Icon", "WebPage", "DateCreated")
values(5, 6, 'Wizard', 'Wizzard', null, 'https://etcparking.etcpeajes.com:8447#/disco-wizard', '2020-01-29 14:47:45.745');
insert into "TrfMenu" ("IdMenu", "IdSubMenu", "Name", "Description", "Icon", "WebPage", "DateCreated")
values(5, 7, 'Limite', 'Descuentos con Limites', null, 'https://etcparking.etcpeajes.com:8447/#/disco-limit', '2020-01-29 14:47:45.745');
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(9, 0, '2020-04-17 16:16:18.934', 'Modulo de Remesas', NULL, 'Remesas', NULL);
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(9, 1, '2020-04-17 16:16:18.938', 'Consulta/Re-Envio', NULL, 'Consulta/Re-envio', 'https://etcparking.etcpeajes.com:8451//#/remittance');
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(10, 0, '2020-01-22 16:16:18.934', 'Reportes', NULL, 'Reportes', NULL);
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(10, 1, '2020-01-29 14:47:45.745', 'Administración de Reportes', NULL, 'Configuración', 'https://etcparking.etcpeajes.com:8455/#/config-reports');
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(10, 2, '2020-01-29 14:47:45.745', 'Reportes', NULL, 'Reportes', 'https://etcparking.etcpeajes.com:8455/#/reports');
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(6, 0, '2020-01-29 14:47:45.745', 'AutoCLose', NULL, 'AutoClose', 'null');
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(6, 1, '2020-01-29 14:47:45.745', 'Cierre Manual', NULL, 'Cierre Manual', 'https://etcparking.etcpeajes.com:8453/#/autoclose');
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(11, 0, '2020-01-29 14:47:45.745', 'Reclamos', NULL, 'Reclamos', 'null');
INSERT INTO "TrfMenu" ("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(11, 1, '2020-01-29 14:47:45.745', 'Reclamos', NULL, 'Reclamos', 'https://etcparking.etcpeajes.com:8456/#/claim');
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(7, 0, '2020-01-29 14:47:45.000', 'Transitos', NULL, 'Transitos', NULL);
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(8, 0, '2020-01-29 14:47:45.000', 'Listas', NULL, 'Listas', NULL);
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(12, 0, '2020-01-29 14:47:45.000', 'Condominios', NULL, 'Condominios', NULL);
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(13, 0, '2020-01-29 14:47:45.000', 'DataPark', NULL, 'DataPark', NULL);
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(14, 0, '2020-01-29 14:47:45.000', 'Notificaciones', NULL, 'Notificaciones', NULL);
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(15, 0, '2020-01-29 14:47:45.000', 'Facturación', NULL, 'Facturación', NULL);
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(16, 0, '2020-09-25 15:48:00.000', 'Modulo de Parqueos', NULL, 'Parqueaderos', NULL);
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(16, 1, '2020-09-25 15:48:00.000', 'Administracion de Parqueos Pequeños', NULL, 'Mini Parqueos', 'https://etcparking.etcpeajes.com:8445/#/miniparqueo');
INSERT INTO "TrfMenu"
("IdMenu", "IdSubMenu", "DateCreated", "Description", "Icon", "Name", "WebPage")
VALUES(4, 6, '2020-07-30 18:34:06.883', 'Proyección Específica', 'money',
'Proyeccion Específica', 'https://etcparking.etcpeajes.com:8449/#/AmountRate');
insert into "TrfUser_Role_Site" ("IdRole", "IdSite", "IdUser") 
select 1, "IdSite", 1 from "Def_Site" where "IdSite">=0 ;
insert into "TrfMenu_x_Role" ("IdMenu", "IdSubMenu", "IdRole", "Permissions")
select "IdMenu", "IdSubMenu", 1,15 from "TrfMenu";
commit;
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(32, 'MaxMinuteEndDay', 'minutes < MaxMin until end of day', true, 'Integer,20   Ojo  mimutos hasta fin de día de entrada o sal"Id"a dependiendo de CheckEntry');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(33, 'MinMinuteEndDay', 'minutes > MinMin until end of day', true, 'Integer,20   Ojo  mimutos hasta fin de día de entrada o sal"Id"a dependiendo de CheckEntry');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(1, 'DateInit', 'Check Date > Param', true, 'Date, yyyy-MM-dd hh:mm:ss.SSS    ');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(2, 'DateEnd', 'Check Date < Param', true, 'Date, yyyy-MM-dd hh:mm:ss.SSS    ');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(3, 'HourInit', 'Check Hour > Param ', true, 'Hour,hh:mm');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(4, 'HourEnd', 'Check Hour < Param', true, 'Hour,hh:mm');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(5, 'DayBefore', 'Check > 1day', true, 'Integer,1');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(6, 'DayWeek', 'Check day of week', true, 'Day,  L:M:X:J:V:S:D   Los días activos separados de :');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(7, 'MaxMinute', 'minutes < MaxMin', true, 'Integer,20');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(8, 'MinMinute', 'minutes > MinMin', true, 'Integer,20');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(9, 'DayYear', 'Check Day Year', true, 'Integer,204  día del año, 1-365');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(10, 'CheckClass', 'Check Class', true, 'Integer,1   "Id" de la tabla Class');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(11, 'MaxNaturalDays', 'natural days>param', true, 'Integer,1');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(12, 'MinNaturalDays', 'natural days<=param', true, 'Integer,1');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(13, 'NDayBefore', 'Check < 1day', true, 'Integer,1');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(14, 'CheckOther', 'Check other Rate recursive', true, 'Integer,2  "Id" de la tabla TrfRate2');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(15, 'Amount', 'amount (if nothing else for all time)', false, 'Decimal,5.8');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(16, 'Daily', 'days * amount', false, 'NoUsado, CualquierValor  (Una descripción)');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(17, 'ByMinutes', 'minutes * amount', false, 'NoUsado, CualquierValor  (Una descripción)');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(18, 'ByCyles', 'runCycle calc', false, 'NoUsado, CualquierValor  (Una descripción)');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(19, 'SumOther', 'calc amount + other  rate (value)', false, 'Integer,2  "Id" de la tabla TrfRate2, lo que suma es el campo amount');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(20, 'PercentOther', 'amount (in %) * other rate (value)', false, 'Integer,2  "Id" de la tabla TrfRate2, el % es el campo amount');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(21, 'NaturalDaily', 'Natural days (24h) *amount', false, 'NoUsado, CualquierValor  (Una descripción)');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(22, 'CalcBetween', 'Calc rate between apply Range', false, 'NoUsado, CualquierValor  (Una descripción)');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(23, 'EndDayHour', 'Hour in next day to cons"Id"er end ', false, 'Hour,hh:mm  ó hh   (si no lleva : se toma como entero para la hora)');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(24, 'RestMinutes', 'calc + other rate', false, 'Integer,20   resta esos minutos del lo que quede');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(25, 'RunOneTime', 'calc the rate only 1 time', true, 'Integer,1   numero de veces que se puede calc esa tarifa en ese trip');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(26, 'DailyDayWeek', 'days (Only the Day Week)* amount ', false, 'NoUsado, CualquierValor  (Una descripción)');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(27, 'EndDay', 'End Rate in End of the Day', false, 'NoUsado, CualquierValor  (Una descripción)');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(28, 'RunOneTimeDay', 'calc the rate only 1 time each day', true, 'Integer,1   numero de veces que se puede calc esa tarifa en ese trip x día');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(29, 'CycleEndIn', 'End Calc Cycle in <0 or <=0', false, 'NoUsado, CualquierValor  (Una descripción)');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(30, 'DayBeforeHour', 'Check Hour > Param +1day', true, 'Hour,hh:mm');
INSERT INTO "TrfDefParam"
("Id", "Cod", "Description", "IsCheck", "TypeDes")
VALUES(31, 'Group', 'is Rate for Subcriber', true, 'NoUsado, CualquierValor  (Una descripción)');
commit;
INSERT INTO "TrfTempComboType"
("Value", "Description", "Active")
VALUES('date', 'Fechas', true);
INSERT INTO "TrfTempComboType"
("Value", "Description", "Active")
VALUES('text', 'Texto', true);
INSERT INTO "TrfTempComboType"
("Value", "Description", "Active")
VALUES('number', 'Numeros', true);
INSERT INTO "TrfTempComboType"
("Value", "Description", "Active")
VALUES('hour', 'Horas:Minutos', true);
commit;
INSERT INTO "QPstatus"
("IdQPstatus", "TRX", "Description", "IdAction")
VALUES(-3, NULL, 'Next Step', 1);
INSERT INTO "QPstatus"
("IdQPstatus", "TRX", "Description", "IdAction")
VALUES(0, '80', 'OBE OK', 0);
INSERT INTO "QPstatus"
("IdQPstatus", "TRX", "Description", "IdAction")
VALUES(-1, '81', 'OBE not OK', 0);
INSERT INTO "QPstatus"
("IdQPstatus", "TRX", "Description", "IdAction")
VALUES(1, '82', 'OBE with Low balance', 0);
INSERT INTO "QPstatus"
("IdQPstatus", "TRX", "Description", "IdAction")
VALUES(-2, '83', 'OBE not OK not beep', 0);
commit;
INSERT INTO "Def_Actions"
("IdAct", "Description", "JDNI")
VALUES(1, 'Discount: Close All Trips', 'https://etcparking.etcpeajes.com:8447/Discount/api/v1/etc/closetrips/all');
INSERT INTO "Def_Actions"
("IdAct", "Description", "JDNI")
VALUES(2, 'Discount: Get Applied Discount', 'https://etcparking.etcpeajes.com:8447/Discount/api/v1/etc/discount/getdiscoapplied');
INSERT INTO "Def_Actions"
("IdAct", "Description", "JDNI")
VALUES(3, 'Discount:Upload Created Discount', 'https://etcparking.etcpeajes.com:8447/Discount/api/v1/etc/discount/uploaddisco');
INSERT INTO "Def_Actions"
("IdAct", "Description", "JDNI")
VALUES(4, 'Discount:Check Discount Applied Download', 'https://etcparking.etcpeajes.com:8447/Discount/api/v1/etc/discount/checkdiscodownload');
INSERT INTO "Def_Actions"
("IdAct", "Description", "JDNI")
VALUES(5, 'Discount:Auto Renove Limits', 'https://etcparking.etcpeajes.com:8447/Discount/api/v1/etc/discounthistory/checkdiscodownload');
INSERT INTO "Def_Actions"
("IdAct", "Description", "JDNI")
VALUES(9, 'Tarifas: Calculo del Monto Trips', 'https://etcparking.etcpeajes.com:8449/api/v1/etc/schedule/CalAllRate');
INSERT into "Def_Actions"
("IdAct", "Description", "JDNI")
VALUES(10, 'Insertar Clasificación', 'https://etcparking.etcpeajes.com:8449/api/v1/etc/schedule/GetClass');
INSERT INTO "Def_Actions"
("IdAct", "Description", "JDNI")
VALUES(11, 'AutoClose: Cierre automatico', 'https://etcparking.etcpeajes.com:8453/api/v1/etc/schedule/autoclose');
INSERT INTO "Def_Actions"
("IdAct", "Description", "JDNI")
VALUES(12, 'Remittance: Envio Remesas', 'https://etcparking.etcpeajes.com:8451/parking/api/remittance/remittance/buildschedule');
INSERT INTO "Def_Actions"
("IdAct", "Description", "JDNI")
VALUES(13, 'Remittance: Re Envio Remesas', 'https://etcparking.etcpeajes.com:8451/parking/api/remittance/remittance/sendmanualschedule');
INSERT INTO "Def_Actions"
("IdAct", "Description", "JDNI")
VALUES(15, 'Listas: get Issuer', 'https://etcparking.etcpeajes.com:8450/schedule/getIssuer');
INSERT INTO "Def_Actions"
("IdAct", "Description", "JDNI")
VALUES(16, 'Listas: get Sites', 'https://etcparking.etcpeajes.com:8450/schedule/getSites');
INSERT INTO "Def_Actions"
("IdAct", "Description", "JDNI")
VALUES(19, 'Listas: Obtener Listas', 'https://etcparking.etcpeajes.com:8450/schedule/getListV1');
INSERT INTO "Def_Actions"
("IdAct", "Description", "JDNI")
VALUES(20, 'Listas: Crear Listas Locales', 'https://etcparking.etcpeajes.com:8450/schedule/getGLocal');
INSERT INTO "Def_Actions"
("IdAct", "Description", "JDNI")
VALUES(17, 'Listas: get defList (Parqueo)', 'https://etcparking.etcpeajes.com:8450/schedule/getDefList');
INSERT INTO "Def_Actions"
("IdAct", "Description", "JDNI")
VALUES(18, 'Listas: get defTemplates (ws_parking)', 'https://etcparking.etcpeajes.com:8450/schedule/getTemplate');
INSERT INTO "Def_Actions"
("IdAct", "Description", "JDNI")
VALUES(21, 'Trips: Subir Trips', 'https://etcparking.etcpeajes.com:8460/transits/api/v1/etc/uploadtrips');
INSERT INTO "Def_Actions"
("IdAct", "Description", "JDNI")
VALUES(22, 'Notificación: Notificar entradas/salidas', 'https://etcparking.etcpeajes.com:8457/api/v1/etc/uploadtrips');
INSERT INTO "Def_Actions"
("IdAct", "Description", "JDNI")
VALUES(23, 'Reportes Automaticos', 'https://etcparking.etcpeajes.com:8455/api/v1/etc/reports/ReportSchedule');
INSERT INTO "Def_Actions"
("IdAct", "Description", "JDNI")
VALUES(24, 'Bajar Controversias', 'https://etcparking.etcpeajes.com:8456/api/v1/etc/shcedule/updateparking');
INSERT INTO "Def_Actions"
("IdAct", "Description", "JDNI")
VALUES(25, 'Cerrar Claim', 'https://etcparking.etcpeajes.com:8456/api/v1/etc/shcedule/closeClaimAuto');
INSERT INTO "Def_Actions"
("IdAct", "Description", "JDNI")
VALUES(26,
 'Tarifas: Union de Entradas/Salidas ', 'https://etcparking.etcpeajes.com:8449/api/v1/etc/schedule/ExitCheck');
INSERT INTO "Schedule"
("Id", "IdAct", "IdSite", "IdSoft", "DayM", "DayW", "Description", "Hour", "Minute", "Month", "Second", "Year")
VALUES(1, 1, -1, 0, NULL, NULL, 'Descuentos: Cierre Trips', '00', '10', NULL, '1', NULL);
INSERT INTO "Schedule"
("Id", "IdAct", "IdSite", "IdSoft", "DayM", "DayW", "Description", "Hour", "Minute", "Month", "Second", "Year")
VALUES(3, 3, -1, 0, NULL, NULL, 'Descuentos: Subida Descuentos creados', NULL, '*/20', NULL, '2', NULL);
INSERT INTO "Schedule"
("Id", "IdAct", "IdSite", "IdSoft", "DayM", "DayW", "Description", "Hour", "Minute", "Month", "Second", "Year")
VALUES(5, 5,-1, 0, NULL, NULL, 'Descuentos: Renovación automática de Límites', '0', '1', NULL, '4', NULL);
INSERT INTO "Schedule"
("IdAct", "Id", "DayM", "DayW", "Description", "Hour", "Minute", "Month", "Second", "Year", "IdSoft","IdSite")
VALUES(9, 9, NULL, NULL, 'Calc Rates', '11', '11', NULL, '15', NULL, 0,-1);
INSERT INTO "Schedule"
("IdAct", "Id", "DayM", "DayW", "Description", "Hour", "Minute", "Month", "Second", "Year", "IdSoft","IdSite")
VALUES(10, 10, NULL, NULL, 'Calc Class', '14', '07', NULL, '10', '2099', 0,-1);
INSERT INTO "Schedule"
("IdAct", "Id", "DayM", "DayW", "Description", "Hour", "Minute", "Month", "Second", "Year", "IdSoft","IdSite")
VALUES(15, 15, NULL, NULL, 'download Issuer to etc-mini-list', '1', '09', NULL, '21', NULL, 0,-1);
INSERT INTO "Schedule"
("IdAct", "Id", "DayM", "DayW", "Description", "Hour", "Minute", "Month", "Second", "Year", "IdSoft","IdSite")
VALUES(16, 16, NULL, NULL, 'download Sites to etc-mini-list', '1', '19', NULL, '21', NULL, 0,-1);
INSERT INTO "Schedule"
("IdAct", "Id", "DayM", "DayW", "Description", "Hour", "Minute", "Month", "Second", "Year", "IdSoft","IdSite")
VALUES(18, 18, NULL, NULL, 'download templates to etc-mini-list', '1', '29', NULL, '21', NULL, 0,-1);
commit;
insert into "DataParkTripStatus" ("IdStatus", "Description")
values (1, 'Registered'),
	   (2, 'Created Registered'),
	   (3, 'Created Confirmed'),	  
	   (4, 'Created Retry'),
	   (5, 'Discount Registered'),
	   (6, 'Discount Confirmed'),
	   (7, 'Discount Retry'),
	   (8, 'Payment Registered'),
	   (9, 'Payment Confirmed'),
	   (10,'Payment Retry'),
	   (11,'Exit Registered'),
	   (12,'Exit Confirmed'),
	   (13,'Exit Retry'),
	   (14,'UpdateRegistered'),
   	   (15,'UpdateConfirmed'),
	   (16,'UpdateRetry'),
	   (17,'Closed');
INSERT INTO "DataParkTripStatus" ("IdStatus", "Description") VALUES(18, 'Cargado DataCenter');
INSERT INTO "DefSiteIssueType" ("Id", "Description", "Active")
VALUES(1, 'Aguja no levanta', true);
INSERT INTO "DefSiteIssueType" ("Id", "Description", "Active")
VALUES(2, 'Descuento con Código QR inválido', true);
INSERT INTO "DefSiteIssueType" ("Id", "Description", "Active")
VALUES(3, 'Cobro incorrecto', true);
INSERT INTO "DefSiteIssueType" ("Id", "Description", "Active")
VALUES(4, 'Da ticket en entrada', true);
INSERT INTO "Def_Claim"
("Id", "Description", "Notified", "Sync")
VALUES(1, 'Creado', true, true);
INSERT INTO "Def_Claim"
("Id", "Description", "Notified", "Sync")
VALUES(2, 'Notificado', false, false);
INSERT INTO "Def_Claim"
("Id", "Description", "Notified", "Sync")
VALUES(3, 'Rechazado', false, true);
INSERT INTO "Def_Claim"
("Id", "Description", "Notified", "Sync")
VALUES(4, 'Rechazado-Cerrado', false, false);
INSERT INTO "Def_Claim"
("Id", "Description", "Notified", "Sync")
VALUES(5, 'OK', false, true);
INSERT INTO "Def_Claim"
("Id", "Description", "Notified", "Sync")
VALUES(6, 'Cerrado', false, false);
INSERT INTO "Def_Claim"
("Id", "Description", "Notified", "Sync")
VALUES(7, 'Auto-OK', true, true);
INSERT INTO "Def_Claim"
("Id", "Description", "Notified", "Sync")
VALUES(8, 'Re Abierto', true, true);
commit;
INSERT INTO "Def_Configuration"
("ClassNamed", "IdSoft", "Method", "Position", "Param", "Description", "IdSite")
VALUES('com.etc.wsparking.Remittance.Param', 0, 'init', 4, '1', 'Limite de Dias para el recalculo de Tarifas', -1);
INSERT INTO "Def_Configuration"
("ClassNamed", "IdSoft", "Method", "Position", "Param", "Description", "IdSite")
VALUES('com.etc.wsparking.Remittance.Param', 0, 'init', 0, '1', 'Id del Parqueo (ver Def_Sites)', -1);
INSERT INTO "Def_Configuration"
("ClassNamed", "IdSoft", "Method", "Position", "Param", "Description", "IdSite")
VALUES('com.etc.wsparking.Remittance.Param', 0, 'init', 1, '/tmp/qpv/input', 'Carpeta donde tomar remesas manuales', -1);
INSERT INTO "Def_Configuration"
("ClassNamed", "IdSoft", "Method", "Position", "Param", "Description", "IdSite")
VALUES('com.etc.wsparking.lane.protocol.ListFactory', 0, 'listWithTID', 0, 'true', 'Define listas con id para el país', -1);
INSERT INTO "Def_Configuration"
("ClassNamed", "IdSoft", "Method", "Position", "Param", "Description", "IdSite")
VALUES('com.etc.wsparking.manager.controller.ParkingController', 0, 'notifyParkingNear', 0, '10', 'Rango GPS +/- para buscar parqueos cercanos', -1);
INSERT INTO "Def_Configuration"
("ClassNamed", "IdSoft", "Method", "Position", "Param", "Description", "IdSite")
VALUES('com.etc.wsparking.Remittance.Param', 0, 'init', 3, 'false', 'Funcion de Remesas en modo Demo', -1);
INSERT INTO "Def_Configuration"
("ClassNamed", "IdSoft", "Method", "Position", "Param", "Description", "IdSite")
VALUES('com.etc.wsparking.manager.controller.ParamsController', 0, 'urlMedia', 0, '/media', 'URL para media', -1);
INSERT INTO "Def_Configuration"
("ClassNamed", "IdSoft", "Method", "Position", "Param", "Description", "IdSite")
VALUES('com.etc.wsparking.manager.controller.ParamsController', 0, 'pathMedia', 0, '/var/Workspace/compassx/media',
'Ruta del directorio para las imágenes', -1);
INSERT INTO "Def_Configuration"
("ClassNamed", "IdSoft", "Method", "Position", "Param", "Description", "IdSite")
VALUES('com.etc.wsparking.lib.jpa.Dao', 0, 'init', 0, '10', 'Registros por página para la páginación', -1);
INSERT INTO "Def_Configuration"
("ClassNamed", "IdSoft", "Method", "Position", "Param", "Description", "IdSite")
VALUES('manager.controller.CustomerNotificationController', 0, 'saveConfiguration', 0,
			'{\"config\": \"value\"}', 'Configuración por defecto de las notificaciones del cliente', -1);
INSERT INTO "Def_Configuration"
("ClassNamed", "IdSoft", "Method", "Position", "Param", "Description", "IdSite")
VALUES('com.etc.wsparking.manager.controller.CustomerController', 0, 'trips', 1, '3', 'Id del banco para consutla de tránsitos', -1);
INSERT INTO "Def_Configuration"
("ClassNamed", "IdSoft", "Method", "Position", "Param", "Description", "IdSite")
VALUES('com.etc.wsparking.lib.utils.GenerateCodeQR', 0, 'generateQRCodeImageP', 0, '/var/Workspace/compassx/static/parking/qr_keys',
'Ruta de las llaves para generar QR Parqueos', -1);
INSERT INTO "Def_Configuration"
("ClassNamed", "IdSoft", "Method", "Position", "Param", "Description", "IdSite")
VALUES('com.etc.wsparking.manager.controller.TripController', 0, 'sendTxToETCMini', 0, 'true',
'Indica si se envian entradas y salidas al ETC Mini configurado en el sitio de los transitos', -1);
INSERT INTO "Def_Configuration"
("ClassNamed", "IdSoft", "Method", "Position", "Param", "Description", "IdSite")
VALUES('com.etc.wsparking.lib.discount.DiscountManager', 0, 'discount', 1, 'https://etcparking.etcpeajes.com:8447/Discount/api/v1',
'Webservice Descuentos', -1);
INSERT INTO "Def_Configuration"
("ClassNamed", "IdSoft", "Method", "Position", "Param", "Description", "IdSite")
select 'com.etc.wsparking.lib.utils.Constants.init', 0, 'urlDataCenter', 0, "BaseUrl"||'/EtcPeajes/api/v1',
'URL Datacenter para el servicio REST', -1 from "Def_Datacenter" ;
INSERT INTO "Def_Configuration"
("ClassNamed", "IdSoft", "Method", "Position", "Param", "Description", "IdSite")
VALUES('com.etc.wsparking.manager.controller.GoogleController', 0, 'init', 0, 
'PATHFIREBASE', 'Ruta datos de acceso para servicio de Google', -1);
INSERT INTO "Def_Configuration"
("ClassNamed", "IdSoft", "Method", "Position", "Param", "Description", "IdSite")
VALUES('com.etc.wsparking.manager.controller.GoogleController', 0, 'init', 1, 'URLFIREBASE', 'URL del proyecto de Google', -1);
INSERT INTO "Def_Configuration"
("ClassNamed", "IdSoft", "Method", "Position", "Param", "Description", "IdSite")
VALUES('com.etc.wsparking.manager.controller.GoogleController', 0, 'valTokenIdFront', 0, 'false', 'validar IddToken de Firebase', -1);
INSERT INTO "Def_Configuration"
("ClassNamed", "IdSite", "IdSoft", "Method", "Position", "Description", "Param")
VALUES('com.etc.wsparking.manager.controller.TripController',-1, 0, 'applyEntry', 0,
'Indicador de si se valida el tag en listas al grabar una entrada', 'false');
INSERT INTO "Def_Configuration"
("ClassNamed", "IdSite", "IdSoft", "Method", "Position", "Description", "Param")
VALUES('com.etc.parking.lib.notified.AutoNotify', -1, 0, 'notify', 2, 'Busca solo en las salidas exit(true/false)', 'false');
INSERT INTO "Def_Configuration" ("ClassNamed", "IdSite", "IdSoft", "Method", "Position", "Description", "Param") 
VALUES('com.etc.wsparking.manager.controller.TripController', -1, 0, 'applyEntry', 1, 'URL del microservicio de listas',
'https://etcparking.etcpeajes.com:8450/');
commit;
update "TrfMenu" set "WebPage"=REPLACE ("WebPage", ':8446', ':8446/parking_params');
update "TrfMenu" set "WebPage"=REPLACE ("WebPage", ':8454', ':8454/parking_schedule');
update "TrfMenu" set "WebPage"=REPLACE ("WebPage", ':8448', ':8448/parking_subscribers');
update "TrfMenu" set "WebPage"=REPLACE ("WebPage", ':8449', ':8449/parking_rates');
update "TrfMenu" set "WebPage"=REPLACE ("WebPage", ':8447', ':8447/Discount');
update "TrfMenu" set "WebPage"=REPLACE ("WebPage", ':8451', ':8451/parking_remittance');
update "TrfMenu" set "WebPage"=REPLACE ("WebPage", ':8455', ':8455/parking_reports');
update "TrfMenu" set "WebPage"=REPLACE ("WebPage", ':8453', ':8453/LibAutoClose');
update "TrfMenu" set "WebPage"=REPLACE ("WebPage", ':8456', ':8456/parking_controversies');
update "Def_Actions" set "JDNI"=REPLACE ("JDNI", ':8446', ':8446/parking_params');
update "Def_Actions" set "JDNI"=REPLACE ("JDNI", ':8454', ':8454/parking_schedule');
update "Def_Actions" set "JDNI"=REPLACE ("JDNI", ':8448', ':8448/parking_subscribers');
update "Def_Actions" set "JDNI"=REPLACE ("JDNI", ':8449', ':8449/parking_rates');
update "Def_Actions" set "JDNI"=REPLACE ("JDNI", ':8451', ':8451/parking_remittance');
update "Def_Actions" set "JDNI"=REPLACE ("JDNI", ':8455', ':8455/parking_reports');
update "Def_Actions" set "JDNI"=REPLACE ("JDNI", ':8453', ':8453/LibAutoClose');
update "Def_Actions" set "JDNI"=REPLACE ("JDNI", ':8456', ':8456/parking_controversies');
update "Def_Actions" set "JDNI"=REPLACE ("JDNI", ':8457', ':8457/parking_notification');
update "Def_Actions" set "JDNI"=REPLACE ("JDNI", ':8460', ':8460/parking_transits');
commit;
