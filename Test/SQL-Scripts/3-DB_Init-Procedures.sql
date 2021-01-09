CREATE OR REPLACE FUNCTION insertsubscribers()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ DECLARE
 exist integer;
BEGIN
        IF (TG_OP = 'INSERT' or TG_OP = 'UPDATE') then
            if( new."Blocked" and NEW."Active") then
                new."DateLastBlocked":=now();
            else
                new."DateLastBlocked":=null;
            end if;        
            IF (NEW."IdGroup" is not null) then
            select into exist  count(*) from "TrfRate2" r
            inner join "TrfGroupSubscriber" g  on r."Id" =g."IdRate"
            inner join "TrfRateParam" x on x."IdRate" = r."Id" and x."IdParam" =15 and x."Value" ='0'
             where "IdGroup" =NEW."IdGroup" and r."Active" = true;
                IF (exist != 0) then
                    NEW."Green":=true;
                else
                    NEW."Green":=false;
                end if;
            else
                RAISE INFO ' no group';
                NEW."Green":=false;
            end if;
        END IF;        
       IF (TG_OP = 'INSERT') then
        NEW."DateCreate":=now();
        return new;
       
       elsIF ( TG_OP = 'UPDATE') then
            NEW."DateCreate":=old."DateCreate";            
        INSERT INTO "H_TrfSubscriber"
            ("Id","IdSite", "TAG", "Amount", "AutomaticPay", "Blocked", "Green", "IdGroup", "Address", "Name", "Department",
            "Email", "Plate", "Phone",  "Active", "Days", "Identity", "IdCurrency", "TID",
            "DateLastBlocked","DateCreate", "DateUpdateorDel")
            values
            (OLD."Id",old."IdSite",OLD."TAG", OLD."Amount", OLD."AutomaticPay",
             OLD."Blocked", OLD."Green",OLD."IdGroup", OLD."Address", OLD."Name", OLD."Department",
             old."Email", old."Plate", old."Phone", old."Active",OLD."Days",
             old."Identity", old."IdCurrency", old."TID",
             old."DateLastBlocked",old."DateCreate", now());
         return NEW;
        elsIF ( TG_OP = 'DELETE') then
            INSERT INTO "H_TrfSubscriber"
            ("Id","IdSite", "TAG", "Amount", "AutomaticPay", "Blocked", "Green", "IdGroup",
            "Address", "Name", "Department", "Email", "Plate", "Phone",
            "Active", "Days", "Identity", "IdCurrency", "TID", "DateLastBlocked", "DateCreate", "DateUpdateorDel")
            values
            (old."Id",old."IdSite", old."TAG", old."Amount", old."AutomaticPay", old."Blocked", old."Green",
            old."IdGroup", old."Address", old."Name", old."Department",
            old."Email", old."Plate", old."Phone", old."Active", old."Days",
            old."Identity", old."IdCurrency", old."TID",
            old."DateLastBlocked", old."DateCreate", now());
            RETURN OLD;
        END IF;
        END;
$function$;
CREATE OR REPLACE FUNCTION func_update_country()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
       INSERT INTO "H_Country" ("Id", "DateCreated", "Description", "Name", "DateDelete", "DateUpdate")
       VALUES(OLD."Id", OLD."DateCreated", OLD."Description", OLD."Name", null, now());
   RETURN NEW;
END;
$function$
;
CREATE OR REPLACE FUNCTION func_delete_country()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
       INSERT INTO "H_Country" ("Id", "DateCreated", "Description", "Name", "DateDelete", "DateUpdate")
       VALUES(OLD."Id", OLD."DateCreated", OLD."Description", OLD."Name", now(), null);
   RETURN OLD;
END;
$function$
;
CREATE OR REPLACE FUNCTION func_update_def_site()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
       INSERT INTO "H_Def_Site"
		("IdSite", "Action", "Active", "Address", "Cod", "Description", "Detail", "IdCountry", "IdDataCenter", 
		"IdProvider", "Image", "Lat", "Logic", "Lon", "TokenExpired", "ValetParking", "DateDelete", "DateUpdate")
		values (OLD."IdSite", OLD."Action", OLD."Active", OLD."Address", OLD."Cod", OLD."Description", OLD."Detail", OLD."IdCountry", OLD."IdDataCenter", 
		OLD."IdProvider", OLD."Image", OLD."Lat", OLD."Logic", OLD."Lon", OLD."TokenExpired", OLD."ValetParking", null, now());
   RETURN NEW;
END;
$function$
;
CREATE OR REPLACE FUNCTION func_delete_def_site()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
       INSERT INTO "H_Def_Site"
		("IdSite", "Action", "Active", "Address", "Cod", "Description", "Detail", "IdCountry", "IdDataCenter", 
		"IdProvider", "Image", "Lat", "Logic", "Lon", "TokenExpired", "ValetParking", "DateDelete", "DateUpdate")
		values (OLD."IdSite", OLD."Action", OLD."Active", OLD."Address", OLD."Cod", OLD."Description", OLD."Detail", OLD."IdCountry", OLD."IdDataCenter", 
		OLD."IdProvider", OLD."Image", OLD."Lat", OLD."Logic", OLD."Lon", OLD."TokenExpired", OLD."ValetParking", now(), null);
   RETURN OLD;
END;
$function$
;
CREATE OR REPLACE FUNCTION func_update_discount()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
       INSERT INTO "H_Discount"
		("Id", "Action", "Amount", "DateEnd", "DateModified", "DateStart", "Description", 
		"DiscountTypeId", "Download", "IdDatacenter", "IdDatapark", "IdSite", "Modified", "Status", "DateDelete", "DateUpdate","IdSumHis")
		VALUES (OLD."Id", OLD."Action", OLD."Amount", OLD."DateEnd", OLD."DateModified", OLD."DateStart", OLD."Description", 
		OLD."DiscountTypeId", OLD."Download", OLD."IdDatacenter", OLD."IdDatapark", OLD."IdSite", OLD."Modified", OLD."Status", null, now(),OLD."IdSumHis");
   RETURN NEW;
END;
$function$
;
CREATE OR REPLACE FUNCTION func_delete_discount()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
       INSERT INTO "H_Discount"
		("Id", "Action", "Amount", "DateEnd", "DateModified", "DateStart", "Description", 
		"DiscountTypeId", "Download", "IdDatacenter", "IdDatapark", "IdSite", "Modified", "Status", "DateDelete", "DateUpdate","IdSumHis")
		VALUES (OLD."Id", OLD."Action", OLD."Amount", OLD."DateEnd", OLD."DateModified", OLD."DateStart", OLD."Description", 
		OLD."DiscountTypeId", OLD."Download", OLD."IdDatacenter", OLD."IdDatapark", OLD."IdSite", OLD."Modified", OLD."Status", now(), null,OLD."IdSumHis");
   RETURN OLD;
END;
$function$
;
CREATE OR REPLACE FUNCTION func_update_discount_pend()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
       INSERT INTO "H_Discount_Pend"
		("Id", "Applied", "Code", "Compass", "Date", "DiscountId", "DateDelete", "DateUpdate")
		VALUES(OLD."Id", OLD."Applied", OLD."Code", OLD."Compass", OLD."Date", OLD."DiscountId", null, now());
   RETURN NEW;
END;
$function$
;
CREATE OR REPLACE FUNCTION func_delete_discount_pend()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
       INSERT INTO "H_Discount_Pend"
		("Id", "Applied", "Code", "Compass", "Date", "DiscountId", "DateDelete", "DateUpdate")
		VALUES(OLD."Id", OLD."Applied", OLD."Code", OLD."Compass", OLD."Date", OLD."DiscountId", now(), null);
   RETURN OLD;
END;
$function$
;
CREATE OR REPLACE FUNCTION func_update_discount_parameter()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
       INSERT INTO "H_DiscountParameter"
		("Id", "Compare", "Cond", "Description", "DiscountType", "Field", "Order", "ValueLenght", "DateDelete", "DateUpdate")
		VALUES(OLD."Id", OLD."Compare", OLD."Cond", OLD."Description", OLD."DiscountType", OLD."Field", OLD."Order", OLD."ValueLenght", null, now());
   RETURN NEW;
END;
$function$
;
CREATE OR REPLACE FUNCTION func_delete_discount_parameter()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
       INSERT INTO "H_DiscountParameter"
		("Id", "Compare", "Cond", "Description", "DiscountType", "Field", "Order", "ValueLenght", "DateDelete", "DateUpdate")
		VALUES(OLD."Id", OLD."Compare", OLD."Cond", OLD."Description", OLD."DiscountType", OLD."Field", OLD."Order", OLD."ValueLenght", now(), null);
   RETURN NEW;
END;
$function$
;
CREATE OR REPLACE FUNCTION func_update_discount_type()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
       INSERT INTO "H_DiscountType"
		("Id", "Description", "InDatacenter", "Pkey", "PkeyMode", "Value", "DateDelete", "DateUpdate")
		VALUES (OLD."Id", OLD."Description", OLD."InDatacenter", OLD."Pkey", OLD."PkeyMode", OLD."Value", null, now());
   RETURN NEW;
END;
$function$
;
CREATE OR REPLACE FUNCTION func_delete_discount_type()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
       INSERT INTO "H_DiscountType"
		("Id", "Description", "InDatacenter", "Pkey", "PkeyMode", "Value", "DateDelete", "DateUpdate")
		VALUES (OLD."Id", OLD."Description", OLD."InDatacenter", OLD."Pkey", OLD."PkeyMode", OLD."Value", now(), null);
   RETURN OLD;
END;
$function$
;
CREATE OR REPLACE FUNCTION func_update_discountapplied()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
       INSERT INTO "H_DiscountApplied"
		("Id", "Code", "Compass", "DateApplied", "DiscountId", "Download", "IdLane", "IdSite", 
		"IdTrip", "NewAmount", "OldAmount", "Timestamtrip", "DateDelete", "DateUpdate")
		values (OLD."Id", OLD."Code", OLD."Compass", OLD."DateApplied", OLD."DiscountId", OLD."Download", OLD."IdLane", OLD."IdSite", 
		OLD."IdTrip", OLD."NewAmount", OLD."OldAmount", OLD."Timestamtrip", null, now());
   RETURN NEW;
END;
$function$
;
CREATE OR REPLACE FUNCTION func_delete_discountapplied()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
       INSERT INTO "H_DiscountApplied"
		("Id", "Code", "Compass", "DateApplied", "DiscountId", "Download", "IdLane", "IdSite", 
		"IdTrip", "NewAmount", "OldAmount", "Timestamtrip", "DateDelete", "DateUpdate")
		values (OLD."Id", OLD."Code", OLD."Compass", OLD."DateApplied", OLD."DiscountId", OLD."Download", OLD."IdLane", OLD."IdSite", 
		OLD."IdTrip", OLD."NewAmount", OLD."OldAmount", OLD."Timestamtrip", now(), null);
   RETURN OLD;
END;
$function$
;
CREATE OR REPLACE FUNCTION func_update_discountsumhistory()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
       INSERT INTO "H_DiscountSumHistory"
		("Id",  "DateCreated", "DateToRecharge", "DateEnd", "AutoRecharge", "UserCreate","RechargeTyp",
		"TotalAmount", "TripAmount", "CodeTransfer", "Active", "ErrCode", "DateDelete", "DateUpdate","Commerce","RechargeAmount" )
		VALUES (OLD."Id", OLD."DateCreated", OLD."DateToRecharge", OLD."DateEnd", OLD."AutoRecharge", OLD."UserCreate", OLD."RechargeTyp",
		OLD."TotalAmount", OLD."TripAmount", OLD."CodeTransfer", OLD."Active", OLD."ErrCode", null, now(),OLD."Commerce",OLD."RechargeAmount");
   RETURN NEW;
END;
$function$
;
CREATE OR REPLACE FUNCTION func_delete_discountsumhistory()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
       INSERT INTO "H_DiscountSumHistory"
		("Id",  "DateCreated", "DateToRecharge", "DateEnd", "AutoRecharge", "UserCreate", "RechargeTyp",
		"TotalAmount", "TripAmount", "CodeTransfer", "Active", "ErrCode", "DateDelete", "DateUpdate","Commerce")
		VALUES (OLD."Id", OLD."DateCreated", OLD."DateToRecharge", OLD."DateEnd", OLD."AutoRecharge", OLD."UserCreate", OLD."RechargeTyp",
		OLD."TotalAmount", OLD."TripAmount", OLD."CodeTransfer", OLD."Active", OLD."ErrCode", now(), null,OLD."Commerce");
   RETURN OLD;
END;
$function$
;
CREATE OR REPLACE FUNCTION insertentrytrips()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
 DECLARE
    _seqname "char";
    _lasttrip integer;   
    BEGIN
        IF (TG_OP = 'DELETE') THEN
   INSERT INTO "H_EntryTrips"
("IdLane", "IdSite",  "Timestamptrip", "QPstatus", "CardNumber", "Cauthenticator", "ExpDate", "Facility", "IdClass",
"IdCustomerTerminal", "Io", "Nquickpass", "Plate", "Process", "Used", "CodTag", consecutive
,deltime)
            SELECT   
             OLD."IdLane", OLD."IdSite",  OLD."Timestamptrip", OLD."QPstatus", OLD."CardNumber",
             OLD."Cauthenticator", OLD."ExpDate", OLD."Facility", OLD."IdClass",
OLD."IdCustomerTerminal", OLD."Io", OLD."Nquickpass", OLD."Plate", OLD."Process", OLD."Used", OLD."CodTag"
, OLD. consecutive,now();
            RETURN OLD;
         ELSIF  (TG_OP = 'INSERT') THEN
	     IF NEW."IdTrip" is NULL THEN
		      SELECT INTO _seqname  c.relkind
				FROM   pg_class     c
					JOIN   pg_namespace n ON n.oid = c.relnamespace
					WHERE  c.relname = 'entry'||trim(to_char(new."IdLane",'99999999999'))    
				AND    n.nspname = current_schema();  
			IF NOT FOUND THEN      
					select  max(a."IdTrip") into _lasttrip
					from  "EntryTrips" a where "IdLane"=new."IdLane";
					IF (NOT FOUND or _lasttrip is NULL )THEN
						_lasttrip:=0;
					END IF;
					EXECUTE 'CREATE SEQUENCE ' ||current_schema()||'.' 
					      || 'entry'||trim(to_char(new."IdLane",'99999999999')) ||'   START '||_lasttrip+1 ;
			END IF;
			NEW."IdTrip":=nextval(current_schema()||'.'||'entry'||trim(to_char(new."IdLane",'99999999999')));
	     END IF;	  	
	   RETURN NEW;
        END IF;
        RETURN NULL;
    END;
$function$
;
CREATE OR REPLACE FUNCTION insertexittrips()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
   DECLARE
    _seqname "char";
    _lasttrip integer;
    BEGIN
        IF (TG_OP = 'DELETE') THEN
        INSERT INTO "H_ExitTrip"
("IdLane", "IdSite", "IdTrip", "Timestamptrip", "QPstatus", "Amount", "CardNumber", "Cauthenticator", 
"ContractProvider", "Download", "EntryQPstatus", "EntryTimestamptrip", "EntryUsed", "ExpDate", "Facility", 
"IdClass", "IdCustomerTerminal", "IdEntryLane", "IdEntryTrip", "Io", "IssuerCode", "Keyref", "ManualRead", 
"ManufacturerId", "Nquickpass", "OldAmount", "Process", "Remi", "RNDRSE", "ServiceCode", "Tax", "TypeofContract", 
"Used", "codTag", consecutive,deltime)
            SELECT   
             OLD."IdLane",  OLD."IdSite",  OLD."IdTrip",  OLD."Timestamptrip",  OLD."QPstatus",  OLD."Amount",  OLD."CardNumber",  OLD."Cauthenticator", 
 OLD."ContractProvider",  OLD."Download",  OLD."EntryQPstatus",  OLD."EntryTimestamptrip",  OLD."EntryUsed",  OLD."ExpDate",  OLD."Facility", 
 OLD."IdClass",  OLD."IdCustomerTerminal",  OLD."IdEntryLane",  OLD."IdEntryTrip",  OLD."Io",  OLD."IssuerCode",  OLD."Keyref",  OLD."ManualRead", 
 OLD."ManufacturerId",  OLD."Nquickpass",  OLD."OldAmount",  OLD."Process",  OLD."Remi",  OLD."RNDRSE",  OLD."ServiceCode", 
 OLD."Tax",  OLD."TypeofContract", 
 OLD."Used", OLD. "codTag", OLD. consecutive,now();
	ELSIF  (TG_OP = 'INSERT') THEN
	     IF NEW."IdTrip" is NULL THEN	      
		      SELECT INTO _seqname  c.relkind
				FROM   pg_class     c
					JOIN   pg_namespace n ON n.oid = c.relnamespace
					WHERE  c.relname = 'exit'||trim(to_char(new."IdLane",'99999999999'))    
				AND    n.nspname = current_schema();  
			IF NOT FOUND THEN      
					select max(a."IdTrip")  into _lasttrip 
					from  "ExitTrip" a where "IdLane"=new."IdLane";
					IF (NOT FOUND or _lasttrip is NULL ) THEN
						_lasttrip:=0;
					END IF;
					EXECUTE 'CREATE SEQUENCE ' ||current_schema()||'.' 
					      || 'exit'||trim(to_char(new."IdLane",'99999999999')) ||'   START '||_lasttrip+1 ;
			END IF;
			NEW."IdTrip":=nextval(current_schema()||'.'||'exit'||trim(to_char(new."IdLane",'99999999999')));
	     END IF;
	   RETURN NEW;
        END IF;
        RETURN NULL;
    END;
$function$
;





