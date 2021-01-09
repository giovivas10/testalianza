CREATE TABLE "Provider" (
	"Id" int4 NOT NULL,
	"Active" bool NULL,
	"Code" varchar(10) NULL,
	"DateCreated" timestamp NULL,
	"Description" varchar(50) NULL,
	"EncryptMode" varchar(100) NULL,
	"PrivateKey" varchar(5000) NULL,
	"PublicKey" varchar(5000) NULL,
	CONSTRAINT "Provider_pkey" PRIMARY KEY ("Id")
);
CREATE TABLE "Country" (
	"Id" int4 NOT NULL,
	"DateCreated" timestamp NULL,
	"Description" varchar(255) NULL,
	"Name" varchar(255) NULL,
	CONSTRAINT "Country_pkey" PRIMARY KEY ("Id")
);
CREATE TABLE "CustomerTerminal" (
	"Id" int4 NOT NULL,
	"Card" varchar(255) NULL,
	"Ced" varchar(255) NULL,
	"CodDevice" varchar(255) NULL,
	"Email" varchar(255) NULL,
	"IdDevice" varchar(255) NULL,
	"IdProvider" int4 NULL,
	"IdToken" varchar(5000) NULL,
	"IsCustomerBac" bool NULL,
	"Token" varchar(5000) NULL,
	CONSTRAINT "CustomerTerminal_pkey" PRIMARY KEY ("Id"),
	CONSTRAINT "CustomerTerminal_IdProvider_fk" FOREIGN KEY ("IdProvider") REFERENCES "Provider"("Id") on update cascade on delete restrict
);
CREATE TABLE "CustomerPlate" (
	"Id" int4 NOT NULL,
	"Active" bool NULL,
	"Alias" varchar(255) NULL,
	"Ced" varchar(255) NULL,
	"CodTag" varchar(255) NULL,
	"CreateDate" timestamp NULL,
	"Description" varchar(255) NULL,
	"IdProvider" int4 NULL,
	"Plate" varchar(255) NULL,
	"CodEstado" varchar(5) NULL,
	"CodTarjetaCliente" varchar(5) NULL,
	CONSTRAINT "CustomerPlate_pkey" PRIMARY KEY ("Id"),
	CONSTRAINT "CustomerPlate_IdProvider_fk" FOREIGN KEY ("IdProvider") REFERENCES "Provider"("Id") on update cascade on delete restrict
);
CREATE TABLE "Def_Datacenter" (
	"Id" int4 NOT NULL,
	"BaseUrl" varchar(255) NULL,
	"Description" varchar(255) NULL,
	"IdCountry" int4 NULL,
	CONSTRAINT "Def_Datacenter_pkey" PRIMARY KEY ("Id"),
	CONSTRAINT "Def_Datacenter_Country_fk" FOREIGN KEY ("IdCountry") REFERENCES "Country"("Id") on update cascade on delete restrict
);
CREATE TABLE "Def_Site" (
	"IdSite" int4 NOT NULL,
	"Action" int4 NULL,
	"Active" bool NULL,
	"Address" varchar(255) NULL,
	"Cod" varchar(255) NULL,
	"Description" varchar(255) NULL,
	"Detail" varchar(255) NULL,
	"IdCountry" int4 NULL,
	"IdDataCenter" int4 NULL,
	"IdProvider" int4 NULL,
	"Image" varchar(255) NULL,
	"Lat" numeric(15, 10) NULL,
	"Logic" int4 NULL,
	"Lon" numeric(15, 10) NULL,
	"TokenExpired" varchar(5000) NULL,
	"ValetParking" bool NULL,
	CONSTRAINT "Def_Site_pkey" PRIMARY KEY ("IdSite"),
	CONSTRAINT "Def_Site_Provider_fk" FOREIGN KEY ("IdProvider") REFERENCES "Provider"("Id") on update cascade on delete restrict,
	CONSTRAINT "Def_Site_Def_Datacenter_fk" FOREIGN KEY ("IdDataCenter") REFERENCES "Def_Datacenter"("Id") on update cascade on delete restrict
);
CREATE TABLE "Advertising" (
	"Id" int4 NOT NULL,
	"Active" bool NULL,
	"CreateDate" timestamp NULL,
	"Description" varchar(255) NULL,
	"IdProvider" int4 NULL,
	"Lat" numeric(19, 2) NULL,
	"Lon" numeric(19, 2) NULL,
	"Title" varchar(255) NULL,
	CONSTRAINT "Advertising_pkey" PRIMARY KEY ("Id"),
	CONSTRAINT "Advertising_IdProvider_fk" FOREIGN KEY ("IdProvider") REFERENCES "Provider"("Id") on update cascade on delete restrict
);
CREATE TABLE "AdvertisingDefSite" (
	"Id" int4 NOT NULL,
	"IdAdvertising" int4 NULL,
	"IdSite" int4 NULL,
	CONSTRAINT "AdvertisingDefSite_pkey" PRIMARY KEY ("Id"),
	CONSTRAINT "AdvertisingDefSite_Advertising_fk" FOREIGN KEY ("IdAdvertising") REFERENCES "Advertising"("Id") on update cascade on delete restrict,
	CONSTRAINT "AdvertisingDefSite_fk" FOREIGN KEY ("IdSite") REFERENCES "Def_Site"("IdSite") on update cascade on delete restrict
);
CREATE TABLE "CustomerAuthorizedTagToPerson" (
	"Id" int4 NOT NULL,
	"AuthorizedAlias" varchar(255) NULL,
	"AuthorizedCed" varchar(255) NULL,
	"CodTag" varchar(255) NULL,
	"CreateDate" timestamp NULL,
	"IdCustomerTerminal" int4 NULL,
	constraint "CustomerAuthorizedTagToPerson_pkey" primary key ("Id"),
	constraint "CustomerAuthorizedTagToPerson_IdCustomerTerminal_codTag_aut_key" unique ("IdCustomerTerminal", "CodTag", "AuthorizedCed"),
	constraint "CustomerAuthorizedTagToPerson_IdCustomerTerminal_fkey" foreign key ("IdCustomerTerminal") references "CustomerTerminal"("Id") on update cascade on delete restrict
);
CREATE TABLE "CustomerNotification" (
	"Id" int4 NOT NULL,
	"Active" bool NULL,
	"CreateDate" timestamp NULL,
	"Description" varchar(255) NULL,
	"IdCustomerNotificationTypeDetail" int4 NULL,
	"IdCustomerTerminal" int4 NULL,
	"Title" varchar(255) NULL,
	constraint "CustomerNotification_pkey" PRIMARY KEY ("Id"),
	constraint "CustomerNotification_IdCustomerTerminal_fkey" foreign key ("IdCustomerTerminal") references "CustomerTerminal"("Id") on update cascade on delete restrict
);
CREATE TABLE "CustomerNotificationConfiguration" (
	"Id" int4 NOT NULL,
	"Configuration" varchar(255) NULL,
	"IdCustomerTerminal" int4 NULL,
	constraint "CustomerNotificationConfiguration_pkey" PRIMARY KEY ("Id"),
	constraint "CustomerNotificationConfiguration_IdCustomerTerminal_fkey" foreign key ("IdCustomerTerminal") references "CustomerTerminal"("Id") on update cascade on delete restrict
);
CREATE TABLE "CustomerNotificationType" (
	"Id" int4 NOT NULL,
	"Active" bool NULL,
	"Description" varchar(255) NULL,
	"Icon" varchar(255) NULL,
	"Title" varchar(255) NULL,
	CONSTRAINT "CustomerNotificationType_pkey" PRIMARY KEY ("Id")
);
CREATE TABLE "CustomerNotificationTypeDetail" (
	"Id" int4 NOT NULL,
	"Active" bool NULL,
	"Description" varchar(255) NULL,
	"Icon" varchar(255) NULL,
	"IdCustomerNotificationType" int4 NULL,
	constraint "CustomerNotificationTypeDetail_pkey" PRIMARY KEY ("Id"),
	constraint "CustomerNotificationTypeDetail_IdCustomerTerminal_fkey" foreign key ("IdCustomerNotificationType") references "CustomerNotificationType"("Id") on update cascade on delete restrict
);
CREATE TABLE "DefSiteIssueType" (
	"Id" int4 NOT NULL,
	"Active" bool NULL,
	"Description" varchar(255) NULL,
	CONSTRAINT "DefSiteIssueType_pkey" PRIMARY KEY ("Id")
);
CREATE TABLE "DefSiteSchedule" (
	"Id" int4 NOT NULL,
	"Active" bool NULL,
	"AlwaysOpen" bool NULL,
	"ClosingTime" int4 NULL,
	"Day" varchar(255) NULL,
	"IdSite" int4 NULL,
	"OpeningTime" int4 NULL,
	"Rate" numeric(19, 2) NULL,
	CONSTRAINT "DefSiteSchedule_pkey" PRIMARY KEY ("Id"),
	constraint "DefSiteSchedule_Def_Site_fk" foreign key ("IdSite") references "Def_Site"("IdSite") on update cascade on delete restrict
);
CREATE TABLE "Def_Actions" (
	"IdAct" int4 NOT NULL,
	"Description" varchar(255) NULL,
	"JDNI" varchar(255) NULL,
	CONSTRAINT "Def_Actions_pkey" PRIMARY KEY ("IdAct")
);
CREATE TABLE "Def_CalRatesBySite" (
	"Function" int4 NOT NULL,
	"IdSite" int4 NOT NULL,
	"Calcrate" bool NULL,
	"Description" varchar(255) NULL,
	CONSTRAINT "Def_CalRatesBySite_pkey" PRIMARY KEY ("Function", "IdSite"),
	constraint "Def_CalRatesBySite_Def_Site_fk" foreign key ("IdSite") references "Def_Site"("IdSite") on update cascade on delete restrict
);
CREATE TABLE "Def_Claim" (
	"Id" int4 NOT NULL,
	"Description" varchar(255) NULL,
	"Notified" bool NULL,
	"Sync" bool NULL,
	CONSTRAINT "Def_Claim_pkey" PRIMARY KEY ("Id")
);
CREATE TABLE "Def_Configuration" (
	"ClassNamed" varchar(255) NOT NULL,
	"IdSite" int4 NOT NULL,
	"IdSoft" int4 NOT NULL,
	"Method" varchar(255) NOT NULL,
	"Position" int4 NOT NULL,
	"Description" varchar(500) NULL,
	"Param" varchar(500) NULL,
	CONSTRAINT "Def_Configuration_pkey" PRIMARY KEY (
		"ClassNamed",
		"IdSite",
		"IdSoft",
		"Method",
		"Position"
	),
	constraint "Def_Configuration_Def_Site_fk" foreign key ("IdSite") references "Def_Site"("IdSite") on update cascade on delete restrict
);
CREATE TABLE "Def_Function" (
	"Function" int2 NOT NULL,
	"Description" varchar(255) NULL,
	"IdAction" int2 NULL,
	CONSTRAINT "Def_Function_pkey" PRIMARY KEY ("Function")
);
CREATE TABLE "Def_TypeofConnection" (
	"TypeofConnection" int2 NOT NULL,
	"Description" varchar(255) NULL,
	"IdAction" int2 NULL,
	CONSTRAINT "Def_TypeofConnection_pkey" PRIMARY KEY ("TypeofConnection")
);
CREATE TABLE "Def_Places" (
	"IdLane" int4 NOT NULL,
	"IdSite" int4 NOT NULL,
	"CrcReceipt" varchar(255) NULL,
	"DefP" varchar(255) NULL,
	"Description" varchar(255) NULL,
	"Function" int2 NULL,
	"IdAntenna" int2 NULL,
	"IdPCS" int2 NULL,
	"IdSoft" int2 NULL,
	"IpAntenna" varchar(255) NULL,
	"IpPCS" varchar(255) NULL,
	"IpSoft" varchar(255) NULL,
	"PortAntenna" int2 NULL,
	"PortPCS" int2 NULL,
	"PortSoft" int2 NULL,
	"Status" int2 NULL,
	"TimestampStatus" time NULL,
	"TypeofConnection" int2 NULL,
	CONSTRAINT "Def_Places_pkey" PRIMARY KEY ("IdLane", "IdSite"),
	CONSTRAINT "Unq_1_Def_Places" UNIQUE("IdLane", "IdSite", "IdSoft"),
	CONSTRAINT "lnk_Def_Function_Def_Places" FOREIGN KEY ("Function") REFERENCES "Def_Function"("Function") MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT "lnk_Def_TypeofConnection_Def_Places" FOREIGN KEY ("TypeofConnection") REFERENCES "Def_TypeofConnection"("TypeofConnection") MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT
);
CREATE TABLE "Def_Issuer" (
	"Id_Iranor" varchar(255) NOT NULL,
	"Id_Issuer" int4 NOT NULL,
	"ContractProvider" int4 NULL,
	"Description" varchar(255) NULL,
	"KeyRef" int2 NULL,
	"Nom_Issuer" varchar(255) NULL,
	"TypeofContract" varchar(255) NULL,
	CONSTRAINT "Def_Issuer_pkey" PRIMARY KEY ("Id_Iranor", "Id_Issuer")
);
CREATE TABLE "Def_Language" (
	"Id" varchar(255) NOT NULL,
	"Image" bytea NULL,
	"Name" varchar(255) NULL,
	CONSTRAINT "Def_Language_pkey" PRIMARY KEY ("Id")
);
CREATE TABLE "Claim" (
	"Id" int4 NOT NULL,
	"IdSite" int4 NOT NULL,
	"Amount" numeric(19, 2) NULL,
	"ClientName" varchar(255) NULL,
	"DateCreate" timestamp NULL,
	"Download" int4 NULL,
	"IdLane" int4 NULL,
	"IdLaneClaimed" int4 NULL,
	"IdTrip" int8 NULL,
	"IdTripClaimed" int8 NULL,
	"LastName" varchar(255) NULL,
	"NewAmount" numeric(19, 2) NULL,
	"Nquickpass" varchar(255) NULL,
	"Status" int4 NULL,
	"Timestamptrip" timestamp NULL,
	"TimestamptripClaimed" timestamp NULL,
	CONSTRAINT "Claim_pkey" PRIMARY KEY ("Id", "IdSite"),
	CONSTRAINT "Claim_DefSite_fk" FOREIGN KEY ("IdSite") REFERENCES "Def_Site"("IdSite") MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT "Claim_DefPlace_fk" FOREIGN KEY ("IdSite", "IdLane") REFERENCES "Def_Places"("IdSite", "IdLane") MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT
);
CREATE TABLE "Claim_History" (
	"IdSite" int4 NOT NULL,
	"Id" int4 NOT NULL,
	"DateEvent" timestamp NOT NULL,
	"Attach" bytea NULL,
	"Comment" varchar(255) NULL,
	"Download" int4 NULL,
	"Modifiedby" varchar(255) NULL,
	"OldStatus" int4 NULL,
	"Status" int4 NULL,
	CONSTRAINT "Claim_History_pkey" PRIMARY KEY ("IdSite", "Id", "DateEvent"),
	CONSTRAINT "Claim_History_DefSite_fk" FOREIGN KEY ("IdSite") REFERENCES "Def_Site"("IdSite") MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT,
	constraint "Claim_History_Claim_DefSite_fk" foreign key ("Id", "IdSite") references "Claim"("Id", "IdSite") MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT
);
CREATE TABLE "DataParkPrinter" (
	"IdLane" int4 NOT NULL,
	"IdSite" int4 NOT NULL,
	"Url" varchar(255) NULL,
	CONSTRAINT "DataParkPrinter_pkey" PRIMARY KEY ("IdLane", "IdSite"),
	constraint "DataParkPrinter_Def_Site_Def_Places_FK" foreign key ("IdSite", "IdLane") references "Def_Places"("IdSite", "IdLane") on update cascade on delete restrict
);
CREATE TABLE "DataParkTripStatus" (
	"IdStatus" int4 NOT NULL,
	"Description" varchar(255) NULL,
	CONSTRAINT "DataParkTripStatus_pkey" PRIMARY KEY ("IdStatus")
);
CREATE TABLE "QPstatus" (
	"IdQPstatus" int2 NOT NULL,
	"Description" varchar(255) NULL,
	"IdAction" int2 NOT NULL,
	"TRX" varchar(255) NULL,
	CONSTRAINT "QPstatus_pkey" PRIMARY KEY ("IdQPstatus")
);
CREATE TABLE "DataParkTrip" (
	"IdLaneEntry" int4 NOT NULL,
	"IdSite" int4 NOT NULL,
	"IdTripEntry" int8 NOT NULL,
	"Nquickpass" varchar(255) NOT NULL,
	"CreateTickedConfirmedTimestamp" timestamp NULL,
	"CreateTickedReq" varchar(1000) NULL,
	"CreateTickedRes" varchar(1000) NULL,
	"CreateTickedTimestamp" timestamp NULL,
	"DiscountAmount" numeric(19, 2) NULL,
	"DiscountCodesData" varchar(255) NULL,
	"DiscountConfirmedTimestamp" timestamp NULL,
	"DiscountReq" varchar(1000) NULL,
	"DiscountRes" varchar(1000) NULL,
	"DiscountSpec" bool NULL,
	"DiscountTimestamp" timestamp NULL,
	"ExitTicketConfirmedTimestamp" timestamp NULL,
	"ExitTicketReq" varchar(1000) NULL,
	"ExitTicketRes" varchar(1000) NULL,
	"ExitTicketTimestamp" timestamp NULL,
	"IdLaneExit" int4 NULL,
	"IdStatus" int4 NULL,
	"IdTripExit" int8 NULL,
	"ParkingPaymentReference" numeric(19, 2) NULL,
	"PaymentConfirmedTimestamp" timestamp NULL,
	"PaymentReq" varchar(1000) NULL,
	"PaymentRes" varchar(1000) NULL,
	"PaymentTimestamp" timestamp NULL,
	"Ticket" varchar(255) NULL,
	"TicketTotalAmount" numeric(19, 2) NULL,
	"TimestamptripEntry" varchar(255) NULL,
	"TimestamptripExit" varchar(255) NULL,
	"Invoice"  varchar(5000) NULL,
	CONSTRAINT "DataParkTrip_pkey" PRIMARY KEY (
		"IdLaneEntry",
		"IdSite",
		"IdTripEntry",
		"Nquickpass"
	),
	constraint "DataParkTrip_DataParkStatus_fk" foreign key ("IdStatus") references "DataParkTripStatus"("IdStatus") on update cascade on delete restrict,
	constraint "DataParkTrip_Def_Site_fk" foreign key ("IdSite") references "Def_Site"("IdSite") on update cascade on delete restrict,
	constraint "DataParkTrip_Def_Places_01_fk" foreign key ("IdSite", "IdLaneEntry") references "Def_Places"("IdSite", "IdLane") on update cascade on delete restrict,
	constraint "DataParkTrip_Def_Places_02_fk" foreign key ("IdSite", "IdLaneExit") references "Def_Places"("IdSite", "IdLane") on update cascade on delete restrict
);
CREATE TABLE "Def_Msg" (
	"Id" int4 NOT NULL,
	"IdLan" varchar(255) NOT NULL,
	"Msg" varchar(255) NULL,
	CONSTRAINT "Def_Msg_pkey" PRIMARY KEY ("Id", "IdLan"),
	constraint "Def_Msg_Def_Msg_fk" foreign key ("IdLan") references "Def_Language"("Id") on update cascade on delete restrict
);
CREATE TABLE "Def_PCS_protocol" (
	"IdSite" int4 NOT NULL,
	"IdSocket" bytea NOT NULL,
	"Position" int4 NOT NULL,
	"Rx" bool NOT NULL,
	"ColumnRef" varchar(255) NULL,
	"ColumnType" varchar(255) NULL,
	"DataElement" varchar(255) NULL,
	"Description" varchar(255) NULL,
	"Length" int4 NULL,
	"TableRef" varchar(255) NULL,
	"ValueRef" varchar(255) NULL,
	CONSTRAINT "Def_PCS_protocol_pkey" PRIMARY KEY ("IdSite", "IdSocket", "Position", "Rx"),
	constraint "Def_PCS_protocol_Def_Site_fk" foreign key ("IdSite") references "Def_Site"("IdSite") on update cascade on delete restrict
);
CREATE TABLE "DefSiteIssue" (
	"Id" int4 NOT NULL,
	"Active" bool NULL,
	"CreateDate" timestamp NULL,
	"Description" varchar(255) NULL,
	"IdCustomerTerminalReported" int4 NULL,
	"IdPlace" int4 NULL,
	"IdSite" int4 NULL,
	"IdSiteIssueType" int4 NULL,
	"Image" varchar(255) NULL,
	CONSTRAINT "DefSiteIssue_pkey" PRIMARY KEY ("Id"),
	constraint "DefSiteIssue_IdCustomerTerminalReported_fk" foreign key ("IdCustomerTerminalReported") references "CustomerTerminal"("Id") on update cascade on delete restrict,
	constraint "DefSiteIssue_Def_Site_fk" foreign key ("IdSite") references "Def_Site"("IdSite") on update cascade on delete restrict,
	constraint "DefSiteIssue_Def_Places_fk" foreign key ("IdSite", "IdPlace") references "Def_Places"("IdSite", "IdLane") on update cascade on delete restrict,
	constraint "DefSiteIssue_IdSiteIssueType_fkey" foreign key ("IdSiteIssueType") references "DefSiteIssueType"("Id") on update cascade on delete restrict
);
CREATE TABLE "Def_Report" (
	"Nombre_Vista" varchar(255) NOT NULL,
	"IdSite" int4 NOT NULL,
	"Nombre_Reporte" varchar(255) NOT NULL,
	"Imagen1" bytea NULL,
	"Imagen2" bytea NULL,
	"Cuadricula" bool NULL,
	"Auto" bool NULL,
	"Periodo" varchar(2) NULL,
	"CampoFiltro" varchar(20) NULL,
	CONSTRAINT "Def_Report_PK" UNIQUE ("Nombre_Vista", "IdSite"),
	CONSTRAINT "lnk_Report_Site" FOREIGN KEY ("IdSite") REFERENCES "Def_Site"("IdSite")
);
CREATE TABLE "Def_Report_Columns" (
	"Nombre_Vista" varchar(255) NOT NULL,
	"IdSite" int4 NOT NULL,
	"Nombre_Columna" varchar(255) NOT NULL,
	"Totalizada" bool NULL,
	"Retencion" bool NULL,
	CONSTRAINT "Def_Report_Columns_PK" UNIQUE ("Nombre_Vista", "IdSite", "Nombre_Columna"),
	CONSTRAINT "lnk_Column_Report" FOREIGN KEY ("Nombre_Vista", "IdSite") REFERENCES "Def_Report"("Nombre_Vista", "IdSite")
);
CREATE TABLE "Def_TRX_MsgClass" (
	"IdClass" bytea NOT NULL,
	"Action" varchar(255) NULL,
	"Description" varchar(255) NULL,
	"IdSocket" bytea NULL,
	CONSTRAINT "Def_TRX_MsgClass_pkey" PRIMARY KEY ("IdClass")
);
CREATE TABLE "Def_TRX_Status" (
	"IdStatus" bytea NOT NULL,
	"Action" varchar(255) NULL,
	"Description" varchar(255) NULL,
	"IdSocket" bytea NULL,
	CONSTRAINT "Def_TRX_Status_pkey" PRIMARY KEY ("IdStatus")
);
CREATE TABLE "Def_TRX_init" (
	"IdSecuence" int4 NOT NULL,
	"IdSite" int4 NOT NULL,
	"Description" varchar(255) NULL,
	"IdSocket" bytea NULL,
	"IfError" varchar(255) NULL,
	"Reconnect" bool NULL,
	CONSTRAINT "Def_TRX_init_pkey" PRIMARY KEY ("IdSecuence", "IdSite"),
	constraint "Def_TRX_init_Def_Site_fk" foreign key ("IdSite") references "Def_Site"("IdSite") on update cascade on delete restrict
);
CREATE TABLE "Def_TRX_init_Conf" (
	"IdSecuence" int4 NOT NULL,
	"IdSite" int4 NOT NULL,
	"Description" varchar(255) NULL,
	"IdName" varchar(255) NULL,
	"IdSocket" bytea NULL,
	"ValueName" varchar(255) NULL,
	"ValueSocket" bytea NULL,
	CONSTRAINT "Def_TRX_init_Conf_pkey" PRIMARY KEY ("IdSecuence", "IdSite")
);
CREATE TABLE "Def_TRX_init_Conf_Params" (
	"Id" bytea NOT NULL,
	"IdSite" int4 NOT NULL,
	"Name" varchar(255) NOT NULL,
	"Description" varchar(255) NULL,
	"IdRev" bytea NULL,
	CONSTRAINT "Def_TRX_init_Conf_Params_pkey" PRIMARY KEY ("Id", "IdSite", "Name")
);
CREATE TABLE "Def_TRX_protocol" (
	"IdSite" int4 NOT NULL,
	"IdSocket" bytea NOT NULL,
	"Position" int4 NOT NULL,
	"Rx" bool NOT NULL,
	"ColumnRef" varchar(255) NULL,
	"ColumnType" varchar(255) NULL,
	"DataElement" varchar(255) NULL,
	"Description" varchar(255) NULL,
	"Length" int4 NULL,
	"TableRef" varchar(255) NULL,
	"ValueRef" varchar(255) NULL,
	CONSTRAINT "Def_TRX_protocol_pkey" PRIMARY KEY ("IdSite", "IdSocket", "Position", "Rx")
);
CREATE TABLE "Def_Wired" (
	"Class_Named" varchar(255) NOT NULL,
	"IdLane" int4 NOT NULL,
	"IdSite" int4 NOT NULL,
	"IdSoft" int2 NOT NULL,
	"Method" varchar(255) NOT NULL,
	"Out_Class_Method" varchar(255) NOT NULL,
	"Out_Obj_name" varchar(255) NOT NULL,
	"Position" int4 NOT NULL,
	"Out_Class_Input" varchar(255) NULL,
	"Out_Class_Named" varchar(255) NULL,
	"Out_Class_Output" varchar(255) NULL,
	"Out_Obj_location1" int4 NULL,
	"Out_Obj_location2" int4 NULL,
	"Out_Obj_param" varchar(255) NULL,
	"WaitToRun" int8 NULL,
	CONSTRAINT "Def_Wired_pkey" PRIMARY KEY (
		"Class_Named",
		"IdLane",
		"IdSite",
		"IdSoft",
		"Method",
		"Out_Class_Method",
		"Out_Obj_name",
		"Position"
	),	
	constraint "Def_Wired_Def_Places_fk" Foreign key ("IdLane","IdSite","IdSoft") references "Def_Places" ("IdLane", "IdSite", "IdSoft") MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT
);
CREATE TABLE "DiscountType" (
	"Id" int4 NOT NULL,
	"Description" varchar(255) NULL,
	"InDatacenter" bool NULL,
	"Pkey" varchar(255) NULL,
	"PkeyMode" varchar(255) NULL,
	"IdSite" int4 NOT NULL,
	"Value" varchar(255) NULL,
	CONSTRAINT "DiscountType_pkey" PRIMARY KEY ("Id"),
	CONSTRAINT "DiscountType_Def_Site_fk" FOREIGN KEY ("IdSite") REFERENCES "Def_Site"("IdSite") on update cascade on delete restrict
);
CREATE TABLE "DiscountSumHistory" (
	"Id" int4 NOT NULL,
	"DateCreated" timestamp NOT NULL,
	"DateToRecharge" timestamp NULL,
	"DateEnd" timestamp NULL,
	"AutoRecharge" boolean NOT NULL,
	"RechargeTyp" int4  NULL,
	"UserCreate" varchar(255) NULL,
	"TotalAmount" numeric(19, 2) NULL,
	"RechargeAmount" numeric(19, 2) NULL,
	"TripAmount" numeric(19, 2) NULL,
	"CodeTransfer" varchar(255) NULL,
	"Active" boolean NOT NULL,
	"IdSite" int4 NOT NULL,
	"ErrCode" varchar(255) NULL,
	"Commerce" varchar(100) NULL,
	"Accumulated"  boolean NULL,
	"IsAmount" boolean NULL DEFAULT FALSE,
	CONSTRAINT "DiscountSumHistory_pkey" PRIMARY KEY ("Id"),
	CONSTRAINT "DiscountHistory_Def_Site_fk" FOREIGN KEY ("IdSite") REFERENCES "Def_Site"("IdSite") on update cascade on delete restrict
);
CREATE TABLE "Discount" (
	"Id" int4 NOT NULL,
	"Action" int2 NULL,
	"Amount" numeric(19, 2) NULL,
	"DateEnd" timestamp NULL,
	"DateModified" timestamp NULL,
	"DateStart" timestamp NULL,
	"Description" varchar(255) NULL,
	"DiscountTypeId" int4 NULL,
	"Download" int4 NULL,
	"IdDatacenter" int4 NULL,
	"IdDatapark" int4 NULL,
	"IdRateDatapark" varchar(5) NULL,
	"IdSite" int4 NOT NULL,
	"Modified" int2 NULL,
	"Status" int2 NULL,
	"IdSumHis" int4 NULL,
	CONSTRAINT "Discount_pkey" PRIMARY KEY ("Id"),
	CONSTRAINT "Discount_unkey" UNIQUE  ("IdDatacenter"),
	CONSTRAINT "Discount_DiscountType_fk" FOREIGN KEY ("DiscountTypeId") REFERENCES "DiscountType"("Id") on update cascade on delete restrict,
	CONSTRAINT "discount_discohis_fk" FOREIGN KEY ("IdSumHis") REFERENCES "DiscountSumHistory"("Id") on update cascade on delete restrict,
	CONSTRAINT "Discount_Def_Site_fk" FOREIGN KEY ("IdSite") REFERENCES "Def_Site"("IdSite") on update cascade on delete restrict
);
CREATE TABLE "DiscountApplied" (
	"Id" int4 NOT NULL,
	"Code" varchar(255) NULL,
	"Compass" varchar(255) NULL,
	"DateApplied" timestamp NULL,
	"DiscountId" int4 NULL,
	"Download" int4 NULL,
	"IdLane" int4 NULL,
	"IdSite" int4 NOT NULL,
	"IdTrip" int8 NULL,
	"NewAmount" numeric(19, 2) NULL,
	"OldAmount" numeric(19, 2) NULL,
	"Timestamtrip" timestamp NULL,
	CONSTRAINT "DiscountApplied_pkey" PRIMARY KEY ("Id"),
	CONSTRAINT "DiscountApplied_Discount_fk" FOREIGN KEY ("DiscountId") REFERENCES "Discount"("IdDatacenter") on update cascade on delete restrict,
	CONSTRAINT "DiscountApplied_Def_Site_fk" FOREIGN KEY ("IdSite") REFERENCES "Def_Site"("IdSite") on update cascade on delete restrict
);
CREATE TABLE "DiscountParameter" (
	"Id" int4 NOT NULL,
	"Compare" varchar(255) NULL,
	"Cond" varchar(255) NULL,
	"Description" varchar(255) NULL,
	"DiscountType" int4 NULL,
	"Field" varchar(255) NULL,
	"Order" int4 NULL,
	"IdSite" int4 NOT NULL,
	"ValueLenght" int4 NULL,
	CONSTRAINT "DiscountParameter_pkey" PRIMARY KEY ("Id"),
	CONSTRAINT "DiscountParameter_DiscountType_fk" FOREIGN KEY ("DiscountType") REFERENCES "DiscountType"("Id") on update cascade on delete restrict,
	CONSTRAINT "DiscountParameter_Def_Site_fk" FOREIGN KEY ("IdSite") REFERENCES "Def_Site"("IdSite") on update cascade on delete restrict
);
CREATE TABLE "Discount_Dis" (
	"Id" int4 NOT NULL,
	"Code" varchar(255) NULL,
	"Compass" varchar(255) NULL,
	"Date" timestamp NULL,
	"ErrCode" varchar(255) NULL,
	CONSTRAINT "Discount_Dis_pkey" PRIMARY KEY ("Id")
);
CREATE TABLE "TrfClass" (
	"Id" int4 NOT NULL,
	"IdSite" int4 NOT NULL,
	"Axes" int4 NULL,
	"Bus" bool NULL,
	"DoubleWheel" int4 NULL,
	"IoMask" varchar(255) NULL,
	"LaneEntry" bool NULL,
	"LaneExit" bool NULL,
	"Moto" bool NULL,
	"Msg" varchar(255) NULL,
	"UpAxes" int4 NULL,
	CONSTRAINT "TrfClass_pkey" PRIMARY KEY ("Id", "IdSite"),
	CONSTRAINT "TrfClass_Def_Site_fk" FOREIGN KEY ("IdSite") REFERENCES "Def_Site"("IdSite") on update cascade on delete restrict
);
CREATE TABLE "TrfClassPlaces" (
	"IdClass" int4 NOT NULL,
	"IdLane" int4 NOT NULL,
	"IdSite" int4 NOT NULL,
	"ioMask" varchar(255) NULL,
	CONSTRAINT "TrfClassPlaces_pkey" PRIMARY KEY ("IdClass", "IdLane", "IdSite"),
	CONSTRAINT "TrfClassPlaces_Def_Site_fk" FOREIGN KEY ("IdSite") REFERENCES "Def_Site"("IdSite") on update cascade on delete restrict
);
CREATE TABLE "Discount_Pend" (
	"Id" int4 NOT NULL,
	"Applied" int2 NULL,
	"Code" varchar(255) NULL,
	"Compass" varchar(255) NULL,
	"Date" timestamp NULL,
	"DiscountId" int4 NULL,
	"IdSite" int4 NOT NULL,
	CONSTRAINT "Discount_Pend_pkey" PRIMARY KEY ("Id"),
	CONSTRAINT "Discount_Pend_Discount_fk" FOREIGN KEY ("DiscountId") REFERENCES "Discount"("IdDatacenter") on update cascade on delete restrict,
	CONSTRAINT "DiscountPend_Def_Site_fk" FOREIGN KEY ("IdSite") REFERENCES "Def_Site"("IdSite") on update cascade on delete restrict
);
CREATE TABLE "EntryTrips" (
	"IdLane" int4 NOT NULL,
	"IdSite" int4 NOT NULL,
	"IdTrip" int8 NOT NULL,
	"Timestamptrip" timestamp NOT NULL,
	"QPstatus" int2 NULL,
	"CardNumber" int4 NULL,
	"Cauthenticator" varchar(255) NULL,
	"CodTag" varchar(255) NULL,
	"ExpDate" date NULL  DEFAULT '2065-01-31'::date,
	"Facility" int4 NULL,
	"IdClass" int4 NULL,
	"IdCustomerTerminal" int4 NULL,
	"Io" varchar(255) NULL,
	"Nquickpass" varchar(255) NULL,
	"Plate" varchar(255) NULL,
	"Process" bool NULL,
	"Used" bool NULL,
	"consecutive" int4 NULL,
	CONSTRAINT "EntryTrips_pkey" PRIMARY KEY ("IdLane", "IdSite", "IdTrip", "Timestamptrip"),
	CONSTRAINT "EntryTrips_Def_Site_fk" FOREIGN KEY ("IdSite") REFERENCES "Def_Site"("IdSite") on update cascade on delete restrict,
	constraint "EntryTrips_IdCustomerTerminal_fk" foreign key ("IdCustomerTerminal") references "CustomerTerminal"("Id") on update cascade on delete restrict,
	constraint "EntryTrips_Def_Places_fk" foreign key ("IdSite","IdLane") references "Def_Places"("IdSite","IdLane") on update cascade on delete restrict,
	constraint "EntryTrips_TrfClass_fk" foreign key ("IdClass", "IdSite") references "TrfClass"("Id", "IdSite") on update restrict on delete restrict,
	constraint "EntryTrips_QPstatus_fk" foreign key ("QPstatus") references "QPstatus"("IdQPstatus") on update restrict on delete restrict
);
CREATE TABLE "ExitTrip" (
	"IdLane" int4 NOT NULL,
	"IdSite" int4 NOT NULL,
	"IdTrip" int8 NOT NULL,
	"Timestamptrip" timestamp NOT NULL,
	"QPstatus" int2 NULL,
	"Amount" numeric(19, 2) NULL,
	"CardNumber" int4 NULL,
	"Cauthenticator" varchar(255) NULL,
	"ContractProvider" int4 NULL,
	"Download" int4 NULL,
	"EntryQPstatus" int2 NULL,
	"EntryTimestamptrip" timestamp NULL,
	"EntryUsed" bool NULL,
	"ExpDate" date NULL  DEFAULT '2065-01-31'::date,
	"Facility" int4 NULL,
	"IdClass" int4 NULL,
	"IdCustomerTerminal" int4 NULL,
	"IdEntryLane" int4 NULL,
	"IdEntryTrip" int8 NULL,
	"Io" varchar(255) NULL,
	"IssuerCode" int4 NULL,
	"Keyref" int2 NULL,
	"ManualRead" bool NULL,
	"ManufacturerId" int4 NULL,
	"Nquickpass" varchar(255) NULL,
	"OldAmount" numeric(19, 2) NULL,
	"Process" int2 NULL,
	"Remi" bool NULL,
	"RNDRSE" float8 NULL,
	"ServiceCode" int4 NULL,
	"Tax" numeric(19, 2) NULL,
	"TypeofContract" varchar(255) NULL,
	"Used" bool NULL,
	"codTag"  varchar(255) NULL,
	"consecutive" int4 NULL,
	CONSTRAINT "ExitTrip_pkey" PRIMARY KEY ("IdLane", "IdSite", "IdTrip", "Timestamptrip"),
	CONSTRAINT "ExitTrip_Def_Site_fk" FOREIGN KEY ("IdSite") 
		REFERENCES "Def_Site"("IdSite") on update cascade on delete restrict,
	constraint "ExitTrip_IdCustomerTerminal_fk" foreign key ("IdCustomerTerminal") 
		references "CustomerTerminal"("Id") on update cascade on delete restrict,
	constraint "ExitTrip_Def_Places_01_fk" foreign key ("IdSite","IdLane") 
		references "Def_Places"("IdSite","IdLane") on update cascade on delete restrict,	
	constraint "ExitTrip_TrfClass_fk" foreign key ("IdClass", "IdSite") 
		references "TrfClass"("Id", "IdSite") on update restrict on delete restrict, 
    CONSTRAINT "ExitTrip_ENTRY" FOREIGN KEY ("IdEntryLane", "IdSite","IdEntryTrip", "EntryTimestamptrip") 
    	REFERENCES "EntryTrips"("IdLane", "IdSite", "IdTrip", "Timestamptrip")  on update cascade on delete restrict,
    constraint "ExitTrip_QPstatus_fk" foreign key ("QPstatus") references "QPstatus"("IdQPstatus") on update restrict on delete restrict
	);
CREATE TABLE "H_AntennaStatus" (
	"Equipment" varchar(255) NOT NULL,
	"Timestamp" timestamp NOT NULL,
	"Type" varchar(255) NOT NULL,
	"Comment" varchar(255) NULL,
	"Download" int4 NULL,
	"Value" varchar(255) NULL,
	CONSTRAINT "H_AntennaStatus_pkey" PRIMARY KEY ("Equipment", "Timestamp", "Type")
);
CREATE TABLE "QPV_Status" (
	"IdStatus" int4 NOT NULL,
	"IdSoft" int2 NOT NULL,
	"IdLane" int4 NOT NULL,
	"Description" varchar(40) NOT NULL,
	"Status" varchar(20) NOT NULL,
	"Timestamp" timetz NOT NULL,
	"Type" varchar(20) NOT NULL,
	"IdSite" int4 not null,
	CONSTRAINT id_status PRIMARY KEY ("IdStatus", "IdSoft", "IdLane", "IdSite"),
	CONSTRAINT "lnk_QPV_Status_Def_Places" FOREIGN KEY ("IdLane", "IdSite") REFERENCES "Def_Places" ("IdLane", "IdSite") MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT
	);
CREATE TABLE "Remittance_list" (
	"IdRemittance" int4 NOT NULL,
	"IdSite" int4 NOT NULL,
	"PTrans" bool NULL,
	"Fields" int4 NULL,
	"FileName" varchar(255) NULL,
	"GenTimestamp" timestamp NULL,
	"ProcessedOk" bool NULL,
	"SendTimestamp" timestamp NULL,
	"TotalAmount" numeric(19, 2) NULL,
	CONSTRAINT "Remittance_list_pkey" PRIMARY KEY ("IdRemittance", "IdSite"),
	CONSTRAINT "Remittance_list_Def_Site_fk" FOREIGN KEY ("IdSite") REFERENCES "Def_Site"("IdSite") on update cascade on delete restrict
);
CREATE TABLE "RemittancedTrips" (
	"IdLane" int4 NOT NULL,
	"IdSite" int4 NOT NULL,
	"IdTrip" int8 NOT NULL,
	"TimestampTrip" timestamp NOT NULL,
	"QPstatus" int2 NULL,
	"Amount" numeric(19, 2) NULL,
	"Cauthenticator" varchar(255) NULL,
	"ContractProvider" int4 NULL,
	"EntryQPstatus" int2 NULL,
	"EntryTimestamptrip" timestamp NULL,
	"EntryUsed" bool NULL,
	"ExpDate" date NULL,
	"IdEntryLane" int4 NULL,
	"IdEntryTrip" int8 NULL,
	"IdRemittance" int4 NULL,
	"IssuerCode" int4 NULL,
	"KeyRef" int2 NULL,
	"ManualRead" bool NULL,
	"ManufacturerId" int4 NULL,
	"Nquickpass" varchar(255) NULL,
	"OldAmount" numeric(19, 2) NULL,
	"Process" bool NULL,
	"RNDRSE" float8 NULL,
	"ServiceCode" int4 NULL,
	"Tax" numeric(19, 2) NULL,
	"TypeofContract" varchar(255) NULL,
	"Used" bool NULL,
	CONSTRAINT "RemittancedTrips_pkey" PRIMARY KEY ("IdLane", "IdSite", "IdTrip", "TimestampTrip"),
	constraint "RemittancedTrips_Def_Places_fk" foreign key ("IdLane", "IdSite") references "Def_Places"("IdLane", "IdSite") on update cascade on delete restrict,
	constraint "RemittancedTrips_Remittance_list_fk" foreign key ("IdRemittance", "IdSite") references "Remittance_list"("IdRemittance", "IdSite") on update cascade on delete restrict
);
CREATE TABLE "Schedule" (
	"Id" int4 NOT NULL,
	"IdAct" int4 NOT NULL,
	"IdSite" int4 NOT  NULL,
	"IdSoft" int4 NOT NULL,
	"DayM" varchar(255) NULL,
	"DayW" varchar(255) NULL,
	"Description" varchar(255) NULL,
	"Hour" varchar(255) NULL,
	"Minute" varchar(255) NULL,
	"Month" varchar(255) NULL,
	"Second" varchar(255) NULL,
	"Year" varchar(255) NULL,
	CONSTRAINT "Schedule_pkey"  PRIMARY KEY  ("Id", "IdAct", "IdSite", "IdSoft"),
	CONSTRAINT "Schedule_Def_Site_fk" FOREIGN KEY ("IdSite") REFERENCES "Def_Site"("IdSite") on update cascade on delete restrict
);
CREATE TABLE "TerminalSession" (
	"Session" varchar(255) NOT NULL,
	"CreateDate" timestamp NULL,
	"IdProvider" int4 NULL,
	"IdSite" int4 NULL,
	CONSTRAINT "TerminalSession_pkey" PRIMARY KEY ("Session"),
	CONSTRAINT "TerminalSession_Def_Site_fk" FOREIGN KEY ("IdSite") REFERENCES "Def_Site"("IdSite") on update cascade on delete restrict,
	CONSTRAINT "TerminalSession_Provider_fk" FOREIGN KEY ("IdProvider") REFERENCES "Provider"("Id") on update cascade on delete restrict
);
CREATE TABLE "TrfBody" (
	"Id" int4 NOT NULL,
	"IdSite" int4 NOT NULL,
	"Attach" bool NULL,
	"Body" varchar(255) NULL,
	"Date" bool NULL,
	"Link" varchar(255) NULL,
	"Subject" varchar(255) NULL,
	"TypeReport" varchar(255) NULL,
	CONSTRAINT "TrfBody_pkey" PRIMARY KEY ("Id", "IdSite"),
	CONSTRAINT "TrfBody_Def_Site_fk" FOREIGN KEY ("IdSite") REFERENCES "Def_Site"("IdSite") on update cascade on delete restrict
);
CREATE TABLE "TrfCurrency" (
	"Id" int4 NOT NULL,
	"Amount" numeric(19, 2) NULL,
	"Date" timestamp NULL,
	"Description" varchar(255) NULL,
	CONSTRAINT "TrfCurrency_pkey" PRIMARY KEY ("Id")
);
CREATE TABLE "TrfRate2" (
	"Id" int8 NOT NULL,
	"IdSite" int4 NOT NULL,
	"Active" bool NULL,
	"Description" varchar(255) NULL,
	"Priority" int4 NULL,
	CONSTRAINT "TrfRate2_pkey" PRIMARY KEY ("Id", "IdSite"),
	CONSTRAINT "TrfRate2_Def_Site_fk" FOREIGN KEY ("IdSite") REFERENCES "Def_Site"("IdSite") on update cascade on delete restrict
);
CREATE TABLE "TrfCycle2" (
	"Id" int4 NOT NULL,
	"Amount" numeric(19, 2) NULL,
	"EndMinute" int4 NULL,
	"IdCyclePart" int4 NULL,
	"IdRate" int4 NULL,
	"IdSite" int4 NOT NULL,
	"InitMinute" int4 NULL,
	"Order" int4 NULL,
	"Replay" int4 NULL,
	CONSTRAINT "TrfCycle2_pk" PRIMARY KEY ("Id"),
	constraint "TrfCycle2_TrfRate2_fk" foreign key ("IdRate","IdSite") references "TrfRate2"("Id","IdSite") on update cascade on delete restrict
);
CREATE TABLE "TrfDefParam" (
	"Id" int4 NOT NULL,
	"Cod" varchar(255) NULL,
	"Description" varchar(255) NULL,
	"IsCheck" bool NULL,
	"TypeDes" varchar(255) NULL,
	CONSTRAINT "TrfDefParam_pkey" PRIMARY KEY ("Id")
);
CREATE TABLE "TrfEmail" (
	"Id" int4 NOT NULL,
	"IdSite" int4 NOT NULL,
	"Active" bool NULL,
	"Email" varchar(255) NULL,
	"IdAct" int4 NULL,
	"IdBody" int4 NULL,
	"IdReport" varchar(50) NULL,
	"IdSchedule" int4 NULL,
	"IdSoft" int4 NULL,
	"Param" varchar(255) NULL,
	CONSTRAINT "TrfEmail_pk" PRIMARY KEY ("Id", "IdSite"),
	CONSTRAINT "TrfEmail_Def_Site_fk" FOREIGN KEY ("IdSite") REFERENCES "Def_Site"("IdSite") ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT "TrfEmail_Schedule_fk" FOREIGN KEY ("IdSchedule", "IdAct", "IdSoft", "IdSite") REFERENCES "Schedule"("Id", "IdAct", "IdSoft", "IdSite") ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT "TrfEmail_TrfBody_fk" FOREIGN KEY ("IdBody", "IdSite") REFERENCES "TrfBody"("Id", "IdSite") ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT trfemail_fk FOREIGN KEY ("IdReport", "IdSite") REFERENCES "Def_Report"("Nombre_Vista", "IdSite")
);
CREATE TABLE "TrfGroupSubscriber" (
	"IdGroup" int4 NOT NULL,
	"IdSite" int4 NOT NULL,
	"Days" varchar(255) NULL,
	"Description" varchar(255) NULL,
	"FinishTime" varchar(255) NULL,
	"IdRate" int4 NULL,
	"StartTime" varchar(255) NULL,
	CONSTRAINT "TrfGroupSubscriber_pkey" PRIMARY KEY ("IdGroup", "IdSite"),
	constraint "TrfGroupSubscriber_TrfRate2_fk" foreign key ("IdRate", "IdSite") references "TrfRate2"("Id", "IdSite") on update cascade on delete restrict
);
CREATE TABLE "TrfLog" (
	"Id" int8 NOT NULL,
	"IdSite" int4 NOT NULL,
	"Action" varchar(255) NULL,
	"Date" timestamp NULL,
	"Description" varchar(255) NULL,
	"From" varchar(255) NULL,
	"User" varchar(255) NULL,
	CONSTRAINT "TrfLog_pkey" PRIMARY KEY ("Id", "IdSite"),
	CONSTRAINT "TrfLog_Def_Site_fk" FOREIGN KEY ("IdSite") REFERENCES "Def_Site"("IdSite") on update cascade on delete restrict
);
CREATE TABLE "TrfMenu" (
	"IdMenu" int4 NOT NULL,
	"IdSubMenu" int4 NOT NULL,
	"DateCreated" timestamp NULL,
	"Description" varchar(255) NULL,
	"Icon" varchar(255) NULL,
	"Name" varchar(255) NULL,
	"WebPage" varchar(255) NULL,
	CONSTRAINT "TrfMenu_pkey" PRIMARY KEY ("IdMenu", "IdSubMenu")
);
CREATE TABLE "TrfRole" (
	"Id" int4 NOT NULL,
	"Active" bool NULL,
	"DateCreated" timestamp NULL,
	"Description" varchar(255) NULL,
	"Name" varchar(255) NULL,
	CONSTRAINT "TrfRole_pkey" PRIMARY KEY ("Id")
);
CREATE TABLE "TrfMenu_x_Role" (
	"IdMenu" int4 NOT NULL,
	"IdRole" int4 NOT NULL,
	"IdSubMenu" int4 NOT NULL,
	"DateCreated" timestamp NULL,
	"DateUpdated" timestamp NULL,
	"Permissions" int4 NULL,
	CONSTRAINT "TrfMenu_x_Role_pkey" PRIMARY KEY ("IdMenu", "IdRole", "IdSubMenu"),
	CONSTRAINT "TrfMenu_x_Role_TrfMenu_fk" FOREIGN KEY ("IdMenu", "IdSubMenu") REFERENCES "TrfMenu"("IdMenu", "IdSubMenu") on update cascade on delete restrict,
	CONSTRAINT "TrfMenu_x_Role_TrfRole_fk" FOREIGN KEY ("IdRole") REFERENCES "TrfRole"("Id") on update cascade on delete restrict
);
CREATE TABLE "TrfRateParam" (
	"EntryExit" bool NOT NULL,
	"IdParam" int4 NOT NULL,
	"IdRate" int4 NOT NULL,
	"IdSite" int4 NOT NULL,
	"Description" varchar(255) NULL,
	"Value" varchar(255) NULL,
	CONSTRAINT "TrfRateParam_pkey" PRIMARY KEY ("EntryExit", "IdParam", "IdRate", "IdSite"),
	constraint "TrfRateParam_TrfRate2_fk" foreign key ("IdRate", "IdSite") references "TrfRate2"("Id", "IdSite") on update cascade on delete restrict
);
CREATE TABLE "TrfRetentions" (
	"Id" int4 NOT NULL,
	"IdSite" int4 NOT NULL,
	"Action" bool NULL,
	"Active" bool NULL,
	"Description" varchar(255) NULL,
	"Edit" bool NULL,
	"Percent" numeric(19, 2) NULL,
	CONSTRAINT "TrfRetentions_pkey" PRIMARY KEY ("Id", "IdSite"),
	CONSTRAINT "TrfRetentions_Def_Site_fk" FOREIGN KEY ("IdSite") REFERENCES "Def_Site"("IdSite") on update cascade on delete restrict
);
CREATE TABLE "TrfSubscriber" (
	"Id" int4 NOT NULL,
	"IdSite" int4 NOT NULL,
	"TAG" varchar(255) NOT NULL,
	"Active" bool NULL,
	"Address" varchar(255) NULL,
	"Amount" numeric(19, 2) NULL,
	"AutomaticPay" bool NULL,
	"Blocked" bool NULL,
	"DateCreate" timestamp NULL DEFAULT now(),
	"DateLastBlocked" timestamp NULL,
	"Days" varchar(255) NULL,
	"Department" varchar(255) NULL,
	"Email" varchar(255) NULL,
	"Green" bool NULL,
	"IdCurrency" int4 NULL,
	"IdGroup" int4 NULL,
	"Identity" varchar(255) NULL,
	"Name" varchar(255) NULL,
	"Phone" varchar(255) NULL,
	"Plate" varchar(255) NULL,
	"TID" varchar(255) NULL,
	CONSTRAINT "TrfSubscriber_pkey" PRIMARY KEY ("Id", "IdSite", "TAG"),
	CONSTRAINT "TrfSubscriber_Def_Site_fk" FOREIGN KEY ("IdSite") REFERENCES "Def_Site"("IdSite") on update cascade on delete restrict,
	CONSTRAINT "TrfSubscriber_TrfCurrency_fk" FOREIGN KEY ("IdCurrency") REFERENCES "TrfCurrency"("Id") on update cascade on delete restrict
);
ALTER TABLE "TrfSubscriber" ADD CONSTRAINT trfsubscriber_un UNIQUE ("TAG","IdSite");
CREATE TABLE "TrfUser" (
	"Id" int4 NOT NULL,
	"Active" bool NULL,
	"CreatedBy" varchar(255) NULL,
	"DateCreated" timestamp NULL,
	"DateExpired" timestamp NULL,
	"DateUpdated" timestamp NULL,
	"Department" varchar(255) NULL,
	"Email" varchar(255) NULL,
	"IdSite" int4 NULL,
	"LastName" varchar(255) NULL,
	"Name" varchar(255) NULL,
	"Password" varchar(255) NULL,
	"PwdExpired" timestamp NULL,
	CONSTRAINT "TrfUser_pkey" PRIMARY KEY ("Id"),
	CONSTRAINT "TrfUser_Def_Site_fk" FOREIGN KEY ("IdSite") REFERENCES "Def_Site"("IdSite") on update cascade on delete restrict
);
CREATE TABLE "TrfUser_Role_Site" (
	"IdRole" int4 NOT NULL,
	"IdSite" int4 NOT NULL,
	"IdUser" int4 NOT NULL,
	"DateCreated" timestamp NULL,
	CONSTRAINT "TrfUser_Role_Site_pkey" PRIMARY KEY ("IdRole", "IdSite", "IdUser"),
	CONSTRAINT "TrfUser_Role_Site_Def_Site_fk" FOREIGN KEY ("IdSite") REFERENCES "Def_Site"("IdSite") on update cascade on delete restrict,
	CONSTRAINT "TrfUser_Role_Site_TrfRole_fk" FOREIGN KEY ("IdRole") REFERENCES "TrfRole"("Id") on update cascade on delete restrict,
	CONSTRAINT "TrfUser_Role_Site_TrfUser_fk" FOREIGN KEY ("IdUser") REFERENCES "TrfUser"("Id") on update cascade on delete restrict
);
CREATE TABLE "H_Max_Rate" (
	"IdTrip" int4 NOT NULL,
	"IdLane" int4 NOT NULL,
	"Timestamptrip" timestamptz NOT NULL,
	"UpdateTime" timestamptz NOT NULL,
	"Amount" numeric(15,2) NULL,
	"CAuthenticator" varchar(10) NULL,
	"ContractProvider" int4 NULL,
	"EntryQPstatus" int4 NULL,
	"EntryTimestampTrip" timestamptz NULL,
	"EntryUsed" bool NULL,
	"ExpDate" date NULL,
	"IdEntryLane" int4 NULL,
	"IdEntryTrip" int4 NULL,
	"IssuerCode" int4 NULL,
	"KeyRef" int4 NULL,
	"ManualRead" bool NULL,
	"ManufacturerId" int4 NULL,
	"NewAmount" numeric(15,2) NULL,
	"NQuickPass" varchar(20) NULL,
	"Process" int4 NULL,
	"QPstatus" int4 NULL,
	"Rndrse" float8 NULL,
	"ServiceCode" int4 NULL,
	"Tax" numeric(15,2) NULL,
	"TypeofContract" varchar(4) NULL,
	"Used" bool NULL,
	"UserDb" varchar(255) NULL,
	"IdSite" int4 NOT null,
	CONSTRAINT pk_max_rate PRIMARY KEY ("IdTrip", "IdLane", "Timestamptrip", "UpdateTime")
);
CREATE TABLE "TrfTemaplate_Site" (
	"IdTempl" int4 NOT NULL,
	"IdSite" int4 NOT NULL,
	"dateCreate" timestamptz NULL,
	"Description" VARCHAR(2044) NULL,
	CONSTRAINT "TrfTemaplateSite_pkey" PRIMARY KEY ("IdTempl", "IdSite")
);
CREATE TABLE "TrfTempComboType" (
	"Value" varchar(100) NOT NULL,
	"Description" varchar(500) NOT NULL,
	"Active" bool NOT NULL DEFAULT true,
	CONSTRAINT "TrfTempComboType_pkey" PRIMARY KEY ("Value")
);
CREATE TABLE "TrfTemplate" (
	"Id" int4 NOT NULL,
	"Description" varchar(500) NOT NULL,
	"DefaultDescription" varchar(100) NOT NULL,
	"Active" bool NOT NULL DEFAULT true,
	"Editable" bool NOT NULL DEFAULT true,
	CONSTRAINT "TrfTemplate_pkey" PRIMARY KEY ("Id")
);
CREATE TABLE "TrfTemplateParam" (
	"IdTempl" int4 NOT NULL,
	"IdParam" int4 NOT NULL,
	"EntryExit" bool NOT NULL DEFAULT false,
	"Description" varchar(50) NOT NULL,
	"ComboType" varchar(50) NOT NULL,
	"Optional" bool NOT NULL DEFAULT false,
	"EditEntryExit" bool NOT NULL DEFAULT true,
	"DefaultValue" varchar(100) NOT NULL,
	"DefaultDescription" varchar(100) NOT NULL,
	CONSTRAINT "TrfTemplateParam_pkey" PRIMARY KEY ("IdTempl", "IdParam", "EntryExit")
);
CREATE TABLE "Def_Status_TAG" (
	"Id" int4 NOT NULL,
	"Code" varchar(10) NOT NULL,
	"Description" varchar(100) NULL,
	"Action" int4 NULL,
	"NextStatus" varchar(100) NULL,
	"IdProvider" int4 NOT NULL,
	"Configuration" varchar(1000) NULL,
	CONSTRAINT "Def_Status_TAG_pkey" PRIMARY KEY ("Id", "Code", "IdProvider")
);
CREATE UNIQUE INDEX idx_def_status_tag_pk ON "Def_Status_TAG" USING btree ("Id");
CREATE INDEX idx_Def_Status_TAG_01 ON "Def_Status_TAG" USING btree ("IdProvider");
ALTER TABLE "Def_Status_TAG" ADD CONSTRAINT "Def_Status_TAG_IdProvider_fkey" FOREIGN KEY ("IdProvider") REFERENCES "Provider"("Id");
CREATE TABLE "H_Country" (
	"Id" int4 NOT NULL,
	"DateCreated" timestamp NULL,
	"Description" varchar(255) NULL,
	"Name" varchar(255) NULL,
	"DateDelete" timestamp NULL,
	"DateUpdate" timestamp NULL
);
CREATE INDEX idx_H_Country_01 ON "H_Country" USING btree ("DateDelete");
CREATE INDEX idx_H_Country_02 ON "H_Country" USING btree ("DateUpdate");
CREATE TABLE "H_Def_Site" (
	"IdSite" int4 NOT NULL DEFAULT 1,
	"Action" int4 NULL,
	"Active" bool NULL,
	"Address" varchar(255) NULL,
	"Cod" varchar(255) NULL,
	"Description" varchar(255) NULL,
	"Detail" varchar(255) NULL,
	"IdCountry" int4 NULL,
	"IdDataCenter" int4 NULL,
	"IdProvider" int4 NULL,
	"Image" varchar(255) NULL,
	"Lat" numeric(19,2) NULL,
	"Logic" int4 NULL,
	"Lon" numeric(19,2) NULL,
	"TokenExpired" varchar(5000) NULL,
	"ValetParking" bool NULL,
	"DateDelete" timestamp NULL,
	"DateUpdate" timestamp NULL
);
CREATE INDEX idx_H_Def_Site_01 ON "H_Def_Site" USING btree ("DateDelete");
CREATE INDEX idx_H_Def_Site_02 ON "H_Def_Site" USING btree ("DateUpdate");
CREATE TABLE "H_Discount" (
	"Id" int4 NOT NULL,
	"Action" int2 NULL,
	"Amount" numeric(19,2) NULL,
	"DateEnd" timestamp NULL,
	"DateModified" timestamp NULL,
	"DateStart" timestamp NULL,
	"Description" varchar(255) NULL,
	"DiscountTypeId" int4 NULL,
	"Download" int4 NULL,
	"IdDatacenter" int4 NULL,
	"IdDatapark" int4 NULL,
	"IdSite" int4 NULL,
	"Modified" int2 NULL,
	"Status" int2 null,
	"DateDelete" timestamp NULL,
	"IdSumHis" int4 NULL,
	"DateUpdate" timestamp NULL
);
CREATE INDEX idx_H_Discount_01 ON "H_Discount" USING btree ("DateDelete");
CREATE INDEX idx_H_Discount_02 ON "H_Discount" USING btree ("DateUpdate");
CREATE TABLE "H_Discount_Pend" (
	"Id" int4 NOT NULL,
	"Applied" int2 NULL,
	"Code" varchar(255) NULL,
	"Compass" varchar(255) NULL,
	"Date" timestamp NULL,
	"DiscountId" int4 NULL,
	"DateDelete" timestamp NULL,
	"DateUpdate" timestamp NULL
);
CREATE INDEX idx_H_Discount_Pend_01 ON "H_Discount_Pend" USING btree ("DateDelete");
CREATE INDEX idx_H_Discount_Pend_02 ON "H_Discount_Pend" USING btree ("DateUpdate");
CREATE TABLE "H_DiscountParameter" (
	"Id" int4 NOT NULL,
	"Compare" varchar(255) NULL,
	"Cond" varchar(255) NULL,
	"Description" varchar(255) NULL,
	"DiscountType" int4 NULL,
	"Field" varchar(255) NULL,
	"Order" int4 NULL,
	"ValueLenght" int4 NULL,
	"DateDelete" timestamp NULL,
	"DateUpdate" timestamp NULL
);
CREATE INDEX idx_H_DiscountParameter_01 ON "H_DiscountParameter" USING btree ("DateDelete");
CREATE INDEX idx_H_DiscountParameter_02 ON "H_DiscountParameter" USING btree ("DateUpdate");
CREATE TABLE "H_DiscountType" (
	"Id" int4 NOT NULL,
	"Description" varchar(255) NULL,
	"InDatacenter" bool NULL,
	"Pkey" varchar(255) NULL,
	"PkeyMode" varchar(255) NULL,
	"Value" varchar(255) NULL,
	"DateDelete" timestamp NULL,
	"DateUpdate" timestamp NULL
);
CREATE INDEX idx_H_DiscountType_01 ON "H_DiscountType" USING btree ("DateDelete");
CREATE INDEX idx_H_DiscountType_02 ON "H_DiscountType" USING btree ("DateUpdate");
CREATE TABLE "H_DiscountApplied" (
	"Id" int4 NOT NULL,
	"Code" varchar(255) NULL,
	"Compass" varchar(255) NULL,
	"DateApplied" timestamp NULL,
	"DiscountId" int4 NULL,
	"Download" int4 NULL,
	"IdLane" int4 NULL,
	"IdSite" int4 NULL,
	"IdTrip" int8 NULL,
	"NewAmount" numeric(19,2) NULL,
	"OldAmount" numeric(19,2) NULL,
	"Timestamtrip" timestamp NULL,
	"DateDelete" timestamp NULL,
	"DateUpdate" timestamp NULL
);
CREATE INDEX idx_H_DiscountApplied_01 ON "H_DiscountApplied" USING btree ("DateDelete");
CREATE INDEX idx_H_DiscountApplied_02 ON "H_DiscountApplied" USING btree ("DateUpdate");
CREATE TABLE "H_DiscountSumHistory" (
	"Id" int4 NOT NULL,
	"DateCreated" timestamp NULL,
	"DateToRecharge" timestamp NULL,
	"DateEnd" timestamp NULL,
	"AutoRecharge" bool NULL,
	"RechargeTyp" int4  NULL,
	"UserCreate" varchar(255) NULL,
	"TotalAmount" numeric(19,2) NULL,
	"TripAmount" numeric(19,2) NULL,
	"CodeTransfer" varchar(255) NULL,
	"Active" bool NULL,
	"ErrCode" varchar(255) NULL,
	"DateDelete" timestamp NULL,
	"Commerce" varchar(100) NULL,
	"DateUpdate" timestamp NULL,
	"RechargeAmount" numeric(19, 2) NULL
);
CREATE TABLE "H_EntryTrips" (
	"IdLane" int4 NULL,
	"IdSite" int4 NULL,
	"IdTrip" int8 NULL,
	"Timestamptrip" timestamp  NULL,
	"QPstatus" int2 NULL,
	"CardNumber" int4 NULL,
	"Cauthenticator" varchar(255) NULL,
	"CodTag" varchar(255) NULL,
	"ExpDate" date NULL,
	"Facility" int4 NULL,
	"IdClass" int4 NULL,
	"IdCustomerTerminal" int4 NULL,
	"Io" varchar(255) NULL,
	"Nquickpass" varchar(255) NULL,
	"Plate" varchar(255) NULL,
	"Process" bool NULL,
	"Used" bool NULL,
	consecutive int4 NULL,
	deltime timestamp NOT NULL
);
CREATE TABLE "H_ExitTrip" (
	"IdLane" int4 NULL,
	"IdSite" int4 NULL,
	"IdTrip" int8 NULL,
	"Timestamptrip" timestamp NULL,
	"QPstatus" int2 NULL,
	"Amount" numeric(19,2) NULL,
	"CardNumber" int4 NULL,
	"Cauthenticator" varchar(255) NULL,
	"ContractProvider" int4 NULL,
	"Download" int4 NULL,
	"EntryQPstatus" int2 NULL,
	"EntryTimestamptrip" timestamp NULL,
	"EntryUsed" bool NULL,
	"ExpDate" date NULL,
	"Facility" int4 NULL,
	"IdClass" int4 NULL,
	"IdCustomerTerminal" int4 NULL,
	"IdEntryLane" int4 NULL,
	"IdEntryTrip" int8 NULL,
	"Io" varchar(255) NULL,
	"IssuerCode" int4 NULL,
	"Keyref" int2 NULL,
	"ManualRead" bool NULL,
	"ManufacturerId" int4 NULL,
	"Nquickpass" varchar(255) NULL,
	"OldAmount" numeric(19,2) NULL,
	"Process" int2 NULL,
	"Remi" bool NULL,
	"RNDRSE" float8 NULL,
	"ServiceCode" int4 NULL,
	"Tax" numeric(19,2) NULL,
	"TypeofContract" varchar(255) NULL,
	"Used" bool NULL,
	"codTag" varchar(255) NULL,
	consecutive int4 null,
	deltime timestamp NOT NULL
);
CREATE TABLE "H_TrfSubscriber" (
	"Id" int4  NULL,
	"IdSite" int4 NULL,
	"TAG" varchar(255) NULL,
	"Active" bool NULL,
	"Address" varchar(255) NULL,
	"Amount" numeric(19,2) NULL,
	"AutomaticPay" bool NULL,
	"Blocked" bool NULL,
	"DateCreate" timestamp NULL DEFAULT now(),
	"DateLastBlocked" timestamp NULL,
	"Days" varchar(255) NULL,
	"Department" varchar(255) NULL,
	"Email" varchar(255) NULL,
	"Green" bool NULL,
	"IdCurrency" int4 NULL,
	"IdGroup" int4 NULL,
	"Identity" varchar(255) NULL,
	"Name" varchar(255) NULL,
	"Phone" varchar(255) NULL,
	"Plate" varchar(255) NULL,
	"TID" varchar(255) NULL,
	"DateUpdateorDel" timestamp NULL DEFAULT now()
);
CREATE INDEX idx_H_DiscountSumHistory_01 ON "H_DiscountSumHistory" USING btree ("DateDelete");
CREATE INDEX idx_H_DiscountSumHistory_02 ON "H_DiscountSumHistory" USING btree ("DateUpdate");
CREATE INDEX "DataParkTrip_Idx01" ON "DataParkTrip" USING btree ("IdSite", "Nquickpass", "IdStatus");
ALTER TABLE "DataParkTrip" ADD CONSTRAINT "DataParkStatusFK" FOREIGN KEY ("IdStatus") REFERENCES "DataParkTripStatus"("IdStatus");
ALTER TABLE "DataParkTrip" ADD CONSTRAINT "Def_SiteFK" FOREIGN KEY ("IdSite") REFERENCES "Def_Site"("IdSite");
ALTER TABLE "DataParkTrip" ALTER COLUMN "PaymentReq" TYPE varchar(1000) USING "PaymentReq"::varchar;
CREATE INDEX idx_customerterminal_01
ON "CustomerTerminal" ("IdProvider", "Ced");
CREATE INDEX idx_customerterminal_02
ON "CustomerTerminal" ("IdProvider", "Ced", "Card");
CREATE INDEX idx_customerterminal_03
ON "CustomerTerminal" ("IdProvider", "Ced", "Card", "Email");
CREATE INDEX idx_customerterminal_04
ON "CustomerTerminal" ("IdProvider", "Ced", "Card", "Email", "Token");
CREATE INDEX idx_customerterminal_05
ON "CustomerTerminal" ("Ced");
CREATE INDEX idx_customerterminal_06
ON "CustomerTerminal" ("Ced", "IdDevice");
CREATE INDEX idx_customerterminal_07
ON "CustomerTerminal" ("Ced", "IdDevice", "CodDevice");
CREATE INDEX idx_provider_01
ON "Provider" ("Code");
CREATE INDEX idx_provider_02
ON "Provider" ("Id");
CREATE INDEX idx_provider_03
ON "Provider" ("Code", "Id");
CREATE INDEX idx_def_configuration_01
ON "Def_Configuration" ("IdSoft", "Position", "Method", "ClassNamed");
CREATE INDEX idx_def_configuration_02
ON "Def_Configuration" ("ClassNamed", "IdSoft", "Position", "Method");
CREATE INDEX idx_def_site_01
ON "Def_Site" ("Cod", "IdProvider");
CREATE INDEX idx_def_site_02
ON "Def_Site" ("Cod", "IdSite", "IdProvider");
CREATE INDEX idx_def_site_03
ON "Def_Site" ("IdSite", "IdProvider");
CREATE INDEX idx_def_site_04
ON "Def_Site" ("IdProvider", "Lon", "Lat", "Logic");
CREATE INDEX idx_def_site_05
ON "Def_Site" ("IdProvider");
CREATE INDEX idx_def_site_06
ON "Def_Site" ("IdSite");
CREATE INDEX idx_def_site_07
ON "Def_Site" ("Cod");
CREATE INDEX idx_defsiteschedule_01
ON "DefSiteSchedule" ("IdSite");
CREATE INDEX idx_advertising_01
ON "Advertising" ("IdProvider", "Lon", "Lat");
CREATE INDEX idx_def_places_01
ON "Def_Places" ("IdLane", "IdSite");
CREATE INDEX idx_entrytrips_01
ON "EntryTrips" ("IdCustomerTerminal", "IdLane", "IdSite", "Timestamptrip");
CREATE INDEX idx_entrytrips_02
ON "EntryTrips" ("IdLane", "IdSite", "consecutive");
CREATE INDEX idx_entrytrips_03
ON "EntryTrips" ("IdLane", "IdSite", "consecutive", "Timestamptrip", "Process");
CREATE INDEX idx_entrytrips_04
ON "EntryTrips" ("CodTag", "IdSite", "Process", "IdCustomerTerminal");
CREATE INDEX idx_exittrip_01
ON "ExitTrip" ("IdCustomerTerminal", "IdLane", "IdSite", "Timestamptrip");
CREATE INDEX idx_exittrip_02
ON "ExitTrip" ("IdLane", "IdSite", "consecutive");

