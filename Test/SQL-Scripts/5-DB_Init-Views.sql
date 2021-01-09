create view V_H_Def_Site as
select *
from "H_Def_Site";
create view V_H_Discount as
select *
from "H_Discount";
create view V_H_Discount_Pend as
select *
from "H_Discount_Pend";
create view V_H_DiscountApplied as
select *
from "H_DiscountApplied";
create or replace view 
"DataParkAutoClosedTrips" as
select 
dpt."IdLaneEntry", dpt."IdSite", 
dpt."IdTripEntry", dpt."Nquickpass", ext."Amount", ext."OldAmount",
ext."IdLane" as "IdLaneExit", ext."IdTrip" as "IdTripExit",
ext."Timestamptrip" as "TimestamptripExit"
from "DataParkTrip" dpt 
join "EntryTrips" etr on etr."IdTrip" = dpt."IdTripEntry" 
					  and etr."IdLane"  = dpt."IdLaneEntry"  
					  and etr."IdSite"  = dpt."IdSite"  
					  and etr."Nquickpass" = dpt."Nquickpass"
					  and etr."Process" = true --entrada ya cerrada tambien					  
join "ExitTrip" ext on ext."IdEntryLane"  = etr."IdLane" 
					  and ext."IdEntryTrip"  = etr."IdTrip" 
					  and ext."IdSite" = etr."IdSite"
					  and ext."Process" = 2 --ya con tarifa y cerrada
join "Def_Places" plc on plc."IdSite"  = ext."IdSite" 
					  and plc."IdLane" = ext."IdLane" 
					  and plc."Function" = 4 --solo la linea de cierre automatico
where dpt."IdStatus"  in (3,6);
CREATE OR REPLACE VIEW uv_searchbydisp
AS SELECT et."IdSite" AS "Id Sitio",
    ds."Description" AS "Sitio",
    et."IdTrip" AS "Consecutivo",
    et."Nquickpass" AS "Dispositivo",
    dp."Description" AS "Carril",
    et."EntryTimestamptrip" AS "Fecha Entrada",
    et."Timestamptrip" AS "Fecha Salida",
    (date_part('epoch'::text, age(et."Timestamptrip", et."EntryTimestamptrip")) / 60::double precision)::numeric::integer AS "Minutos",
        CASE
            WHEN et."OldAmount" = NULL::numeric THEN et."Amount"
            ELSE et."OldAmount"
        END AS "Monto"
   FROM "ExitTrip" et
     JOIN "Def_Places" dp ON et."IdLane" = dp."IdLane" AND et."IdSite" = dp."IdSite"
     JOIN "Def_Site" ds ON ds."IdSite" = et."IdSite";
CREATE OR REPLACE VIEW mmdi.uv_transdetail
AS SELECT et."IdSite" AS "Id Sitio",
    et."IdTrip" AS "Consecutivo",
    dpe."Description" AS "Carril Entrada",
    dps."Description" AS "Carril Salida",
    et."EntryTimestamptrip" AS "Entrada",
    et."Timestamptrip" AS "Salida",
    date_part('epoch'::text, age(et."Timestamptrip", et."EntryTimestamptrip")) / 60::double precision AS "Minutos",
    et."Nquickpass" AS "TAG",
        CASE
            WHEN et."OldAmount" is NULL THEN et."Amount"
            ELSE et."OldAmount"
        END AS "Monto"
   FROM "ExitTrip" et
     JOIN "Def_Places" dpe ON et."IdEntryLane" = dpe."IdLane" AND et."IdSite" = dpe."IdSite"
     JOIN "Def_Places" dps ON et."IdLane" = dps."IdLane" AND et."IdSite" = dps."IdSite";
CREATE OR REPLACE VIEW uv_pendentrance
AS SELECT et."IdSite" AS "Id Sitio",
    ds."Description" AS "Sitio",
    et."IdTrip" AS "Consecutivo",
    et."Nquickpass" AS "Dipositivo",
    dp."Description" AS "Carril",
    et."Timestamptrip" AS "Fecha Entrada"
   FROM "EntryTrips" et
     JOIN "Def_Places" dp ON et."IdLane" = dp."IdLane" AND et."IdSite" = dp."IdSite"
     JOIN "Def_Site" ds ON ds."IdSite" = et."IdSite"
  WHERE et."Process" = false;
CREATE OR REPLACE VIEW ws_parking.int_remittancetrip
AS SELECT rt."IdSite" AS "Id Sitio",
    ds."Description" AS "Sitio",
    rl."IdRemittance" AS "Id Remesa",
    rt."Nquickpass" AS "Dispositivo",
    dp."Description" AS "Carril Entrada",
    et."EntryTimestamptrip" AS "Fecha Entrada",
    dp."Description" AS "Carril Salida",
    et."Timestamptrip" AS "Fecha Salida",
     TO_CHAR(date_trunc('second', et."Timestamptrip"::timestamp) - date_trunc('second', et."EntryTimestamptrip"::timestamp),'DD HH24:MI:SS')
     as "Estadia",
        CASE
            WHEN et."OldAmount" IS NULL THEN rt."Amount"
            ELSE et."OldAmount"
        END AS "Monto",
    ( SELECT
                CASE
                    WHEN c.conteo = 0 THEN rt."Amount"
                    ELSE da."NewAmount"
                END AS "Monto Final"
           FROM ( SELECT count(*) AS conteo
                   FROM ( SELECT dt."InDatacenter"
                           FROM "DiscountApplied" dap
                             JOIN "Discount" d ON dap."DiscountId" = d."IdDatacenter"
                             JOIN "DiscountType" dt ON d."DiscountTypeId" = dt."Id"
                          WHERE rt."IdLane" = dap."IdLane" AND rt."IdSite" = dap."IdSite" AND rt."IdTrip" = dap."IdTrip") re
                  WHERE et."OldAmount" IS NULL) c) AS "Monto Final"
   FROM "RemittancedTrips" rt
     JOIN "Remittance_list" rl ON rl."IdRemittance" = rt."IdRemittance" AND rl."IdSite" = rt."IdSite"
     JOIN "ExitTrip" et ON rt."IdLane" = et."IdLane" AND rt."IdSite" = et."IdSite" AND rt."IdTrip" = et."IdTrip"
     JOIN "Def_Places" dp ON dp."IdLane" = et."IdLane" AND dp."IdSite" = et."IdSite"
     JOIN "Def_Site" ds ON ds."IdSite" = et."IdSite"
     LEFT JOIN "DiscountApplied" da ON rt."IdLane" = da."IdLane" AND rt."IdSite" = da."IdSite" AND rt."IdTrip" = da."IdTrip"
  WHERE rl."IdRemittance" = rt."IdRemittance" AND rl."IdSite" = rt."IdSite" AND rt."IdLane" = et."IdLane" AND
  rt."IdSite" = et."IdSite" AND rt."IdTrip" = et."IdTrip" AND rt."Nquickpass"::text = et."Nquickpass"::text;
CREATE OR REPLACE VIEW uv_remittancetrip
AS SELECT ir."Id Sitio",
    ir."Sitio",
    ir."Id Remesa",
    rl."GenTimestamp" AS "Fecha Generación",
    rl."SendTimestamp" AS "Fecha de Envío",
    ir."Dispositivo",
    ir."Carril Entrada",
    ir."Fecha Entrada",
    ir."Carril Salida",
    ir."Fecha Salida",
    ir."Estadia",
    ir."Monto",
    ir."Monto" - ir."Monto Final" AS "Descuento",
    ir."Monto Final"
   FROM int_remittancetrip ir
     JOIN "Remittance_list" rl ON rl."IdRemittance" = ir."Id Remesa"
  WHERE rl."IdRemittance" = ir."Id Remesa" AND rl."IdSite" = ir."Id Sitio";
CREATE OR REPLACE VIEW uv_remittancetotal
AS SELECT rl."IdSite" AS "Id Sitio",
    ds."Description" AS "Sitio",
    rl."IdRemittance" AS "Id Remesa",
    rl."GenTimestamp" AS "Fecha de Generacion",
    rl."SendTimestamp" AS "Fecha de Envio",
    rl."Fields" AS "Cantidad Transitos",
    sum(
        CASE
            WHEN et."OldAmount" IS NULL THEN rt."Amount"
            ELSE et."OldAmount"
        END) AS "Monto",
    COALESCE(sum(
        CASE
            WHEN (( SELECT count(*) AS count
               FROM "DiscountType" dt
              WHERE dt."IdSite" = rl."IdSite")) = 0 THEN et."OldAmount" - et."Amount"
            ELSE da."OldAmount" - da."NewAmount"
        END), 0::numeric) AS "Descuentos",
    sum(
        CASE
            WHEN et."OldAmount" IS NULL THEN rt."Amount"
            ELSE et."OldAmount"
        END) - COALESCE(sum(
        CASE
            WHEN (( SELECT count(*) AS count
               FROM "DiscountType" dt
              WHERE dt."IdSite" = rl."IdSite")) = 0 THEN et."OldAmount" - et."Amount"
            ELSE da."OldAmount" - da."NewAmount"
        END),0) AS "Monto Final"
   FROM "Remittance_list" rl
     LEFT JOIN "Def_Site" ds ON ds."IdSite" = rl."IdSite"
     LEFT JOIN "RemittancedTrips" rt ON rt."IdRemittance" = rl."IdRemittance" AND rt."IdSite" = rl."IdSite"
     LEFT JOIN "ExitTrip" et ON et."IdTrip" = rt."IdTrip" AND et."IdLane" = rt."IdLane" AND et."Nquickpass"::text = rt."Nquickpass"::text
     LEFT JOIN "DiscountApplied" da ON da."IdTrip" = rt."IdTrip" AND da."IdLane" = rt."IdLane" AND da."Compass"::text = rt."Nquickpass"::text
  WHERE rl."SendTimestamp" IS NOT NULL AND rt."IdRemittance" = rl."IdRemittance" AND rt."IdSite" = rl."IdSite" AND et."IdTrip" = rt."IdTrip" AND et."IdLane" = rt."IdLane" AND et."Nquickpass"::text = rt."Nquickpass"::text
  GROUP BY rl."IdRemittance", rl."IdSite", rl."GenTimestamp", rl."SendTimestamp", rl."Fields", ds."Description"
  ORDER BY rl."SendTimestamp" DESC;
CREATE OR REPLACE FUNCTION tmp_consumousuario(idsite text, fecha_inicio date, fecha_final date, tag text)
 RETURNS TABLE("Id Sitio" integer, "Sitio" text, "Id Usuario" integer, "Razón Social" text, "Departamento" text, "Grupo" text, "Correo" text, "Consecutivo" integer, "Carril Entrada" text, "Fecha Entrada" date, "Carril Salida" text, "Fecha Salida" date, "Minutos" integer, "Monto" integer)
 LANGUAGE plpgsql
AS $function$
DECLARE
    reg RECORD;
    regsitios RECORD;
    obj RECORD;
    curppal refcursor;
    cur_sitios refcursor;
BEGIN
    OPEN cur_sitios FOR select unnest(string_to_array(idsite,',')) AS site;
        LOOP
            FETCH cur_sitios INTO regsitios;
            EXIT WHEN NOT FOUND;
            OPEN curppal FOR
                SELECT ts."IdSite" AS "Id Sitio",
                    ds."Description" as "Sitio",
                    ts."Id" as "Id Usuario",
                    ts."Name" as "Razón Social",
                    ts."Department" as "Departamento",
                    tgs."Description" As "Grupo",
                    ts."Email" as "Correo",
                    rt."IdTrip" as "Consecutivo",
                    dpe."Description" as "Carril Entrada",
                    rt."EntryTimestamptrip"  as "Fecha Entrada",
                    dp."Description" as "Carril Salida",
                    rt."TimestampTrip"  as "Fecha Salida",
                    (date_part('epoch'::text, age(rt."TimestampTrip", rt."EntryTimestamptrip")) / 60::double precision)::numeric::integer AS "Minutos",
                    rt."Amount" as "Monto"
                from
                    "TrfSubscriber" ts
                    inner join "RemittancedTrips" rt
                    on ts."TAG" = rt."Nquickpass"
                    inner join "TrfGroupSubscriber" tgs
                    on ts."IdGroup" = tgs."IdGroup"
                    inner join "Def_Places" dp
                    on rt."IdLane" = dp."IdLane"
                    inner join "Def_Site" ds
                    on ds."IdSite" = rt."IdSite"
                    inner join "Def_Places" dpe
                    on rt."IdEntryLane" = dpe."IdLane"
                where
                    rt."TimestampTrip" >= fecha_inicio and
                    rt."TimestampTrip" <= fecha_final and
                    ts."TAG" = TAG and
                    rt."IdSite" = CAST(regsitios.site as integer);
                LOOP
                    FETCH curppal INTO reg;
                    EXIT WHEN NOT FOUND;
                    "Id Sitio":= CAST(regsitios.site as integer);
                    "Sitio" := reg."Sitio";
                    "Id Usuario" := reg."Id Usuario";
                    "Razón Social" := reg."Razón Social";
                    "Departamento" := reg."Departamento";
                    "Grupo" := reg."Grupo";
                    "Correo" := reg."Correo";
                    "Consecutivo" := reg."Consecutivo";
                    "Carril Entrada" := reg."Carril Entrada";
                    "Fecha Entrada" := reg."Fecha Entrada";
                    "Carril Salida" := reg."Carril Salida";
                    "Fecha Salida" := reg."Fecha Salida";
                    "Minutos" := reg."Minutos";
                    "Monto" := reg."Monto";
                    RETURN NEXT;
                END LOOP;

            CLOSE curppal;
        END LOOP;
    CLOSE cur_sitios;

    RETURN;
END $function$;
CREATE OR REPLACE FUNCTION spreport_consumousuario(ofset integer, vlimit integer, idsite text, fecha_inicio date, fecha_final date, tag text)
 RETURNS TABLE("Id Sitio" integer, "Sitio" text, "Id Usuario" integer, "Razón Social" text, "Departamento" text, "Grupo" text, "Correo" text, "Consecutivo" integer, "Carril Entrada" text, "Fecha Entrada" date, "Carril Salida" text, "Fecha Salida" date, "Minutos" integer, "Monto" integer)
 LANGUAGE plpgsql
AS $function$
DECLARE
BEGIN
    IF ofset = 0 THEN
        ofset:= NULL;
    END IF;
    IF vlimit = 0 THEN
        vlimit:= NULL;
    END IF;
    RETURN QUERY select * from tmp_consumousuario(idsite, fecha_inicio, fecha_final, TAG) LIMIT vlimit OFFSET ofset;
END $function$;
CREATE OR REPLACE FUNCTION tmp_entradasalida(idsite text, fecha_inicio date, fecha_final date, segmentado boolean)
 RETURNS TABLE("Id Sitio" integer, "Sitio" text, "Tipo" text, "Detalle" text, "Cantidad" integer)
 LANGUAGE plpgsql
AS $function$
DECLARE
    reg RECORD;
    regsitios RECORD;
    obj RECORD;
    curppal refcursor;
    cur_sitios refcursor;
BEGIN
    IF segmentado = false THEN
        OPEN curppal FOR
            SELECT et."IdEntryLane" AS "IdLane", ds."Description" as "Sitio", 'Entrada' AS "Tipo", dp."Description" AS "Detalle", COUNT(*) AS "Cantidad"
            FROM "ExitTrip" et
            INNER JOIN "Def_Places" dp ON et."IdEntryLane" = dp."IdLane" AND et."IdSite" = dp."IdSite"
            AND DATE(et."EntryTimestamptrip") BETWEEN fecha_inicio AND fecha_final AND CAST(et."IdSite" as varchar) = any(string_to_array(idsite,','))
            inner join "Def_Site" ds on ds."IdSite" = et."IdSite"
            GROUP BY et."IdEntryLane", dp."Description", ds."Description"
            UNION ALL
            SELECT
            et."IdLane" AS "IdLane",ds."Description" as "Sitio", 'Salida' AS "Tipo", dp."Description" AS "Detalle", COUNT(*) AS "Cantidad"
            FROM "ExitTrip" et
            INNER JOIN "Def_Places" dp ON et."IdLane" = dp."IdLane" AND et."IdSite" = dp."IdSite"
            AND DATE(et."Timestamptrip") BETWEEN fecha_inicio AND fecha_final AND CAST(et."IdSite" as varchar) = any(string_to_array(idsite,','))
            inner join "Def_Site" ds on ds."IdSite" = et."IdSite"
            GROUP BY et."IdLane", dp."Description", ds."Description";
            LOOP
                FETCH curppal INTO reg;
                EXIT WHEN NOT FOUND;
                "Id Sitio":= NULL;
                "Sitio" := reg."Sitio";
                "Tipo":= reg."Tipo";
                "Detalle":= reg."Detalle";
                "Cantidad":= reg."Cantidad";
                RETURN NEXT;
            END LOOP;
        CLOSE curppal;
    ELSE
        OPEN cur_sitios FOR select unnest(string_to_array(idsite,',')) AS site;
            LOOP
                FETCH cur_sitios INTO regsitios;
                EXIT WHEN NOT FOUND;

                OPEN curppal FOR
                    SELECT et."IdEntryLane" AS "IdLane",ds."Description" as "Sitio", 'Entrada' AS "Tipo", dp."Description" AS "Detalle", COUNT(*) AS "Cantidad"
                    FROM "ExitTrip" et
                    INNER JOIN "Def_Places" dp ON et."IdEntryLane" = dp."IdLane" AND et."IdSite" = dp."IdSite"
                    AND DATE(et."EntryTimestamptrip") BETWEEN fecha_inicio AND fecha_final AND CAST(et."IdSite" as varchar) = regsitios.site
                    inner join "Def_Site" ds on ds."IdSite" = et."IdSite"
                    GROUP BY et."IdEntryLane", dp."Description", ds."Description"
                    UNION ALL
                    SELECT
                    et."IdLane" AS "IdLane", ds."Description" as "Sitio", 'Salida' AS "Tipo", dp."Description" AS "Detalle",    COUNT(*) AS "Cantidad"
                    FROM "ExitTrip" et
                    INNER JOIN "Def_Places" dp ON et."IdLane" = dp."IdLane" AND et."IdSite" = dp."IdSite"
                    AND DATE(et."Timestamptrip") BETWEEN fecha_inicio AND fecha_final AND CAST(et."IdSite" as varchar) = regsitios.site
                    inner join "Def_Site" ds on ds."IdSite" = et."IdSite"
                    GROUP BY et."IdLane", dp."Description", ds."Description";
                    LOOP
                        FETCH curppal INTO reg;
                        EXIT WHEN NOT FOUND;
                        "Id Sitio":= CAST(regsitios.site as integer);
                        "Sitio" := reg."Sitio";
                        "Tipo":= reg."Tipo";
                        "Detalle":= reg."Detalle";
                        "Cantidad":= reg."Cantidad";
                        RETURN NEXT;
                    END LOOP;
                CLOSE curppal;
            END LOOP;
        CLOSE cur_sitios;
    END IF;
    RETURN;
END $function$
;
CREATE OR REPLACE FUNCTION spreport_entradasalida(ofset integer, vlimit integer, idsite text, fecha_inicio date, fecha_final date, segmentado boolean)
 RETURNS TABLE("Id Sitio" integer, "Sitio" text, "Tipo" text, "Detalle" text, "Cantidad" integer)
 LANGUAGE plpgsql
AS $function$
DECLARE
BEGIN     --Validacion de parametros de entrada paginacion
    IF ofset = 0 THEN
        ofset:= NULL;
    END IF;
    IF vlimit = 0 THEN
        vlimit:= NULL;
    END IF;
    RETURN QUERY select * from tmp_entradasalida(idsite, fecha_inicio, fecha_final, segmentado) LIMIT vlimit OFFSET ofset;
END $function$
;
CREATE OR REPLACE FUNCTION tmp_ocupaciondiashoras(idsite text, fecha_inicio date, fecha_final date, monto_cero boolean, segmentado boolean)
 RETURNS TABLE("Id Sitio" integer, "Sitio" text, "Fecha" date, "H0" integer, "H1" integer, "H2" integer, "H3" integer, "H4" integer, "H5" integer, "H6" integer, "H7" integer, "H8" integer, "H9" integer, "H10" integer, "H11" integer, "H12" integer, "H13" integer, "H14" integer, "H15" integer, "H16" integer, "H17" integer, "H18" integer, "H19" integer, "H20" integer, "H21" integer, "H22" integer, "H23" integer, "MAX" integer, "MIN" integer, "MED" integer, "TOTAL" integer)
 LANGUAGE plpgsql
AS $function$
DECLARE
    reg RECORD;
    regsitios RECORD;
    obj RECORD;
    cur_dias refcursor;
    cur_sitios refcursor;
    cur_segmentado refcursor;
    acum_0 int4;
    acum_1 int4;
    acum_2 int4;
    acum_3 int4;
    acum_4 int4;
    acum_5 int4;
    acum_6 int4;
    acum_7 int4;
    acum_8 int4;
    acum_9 int4;
    acum_10 int4;
    acum_11 int4;
    acum_12 int4;
    acum_13 int4;
    acum_14 int4;
    acum_15 int4;
    acum_16 int4;
    acum_17 int4;
    acum_18 int4;
    acum_19 int4;
    acum_20 int4;
    acum_21 int4;
    acum_22 int4;
    acum_23 int4;
    hour_tmp int4;
    arraydays integer[];
    sqlvar text;
BEGIN
    IF segmentado = false THEN
        OPEN cur_dias FOR
            SELECT DISTINCT DATE(et."EntryTimestamptrip") AS entrydate, ds."Description" as "Sitio"
            FROM "ExitTrip" et
            inner join "Def_Site" ds on ds."IdSite" = et."IdSite"
            WHERE DATE(et."EntryTimestamptrip") BETWEEN fecha_inicio AND fecha_final
            AND CAST(et."IdSite" as varchar) = any(string_to_array(idsite,','));
            LOOP
                FETCH cur_dias INTO reg;
                EXIT WHEN NOT FOUND;
                acum_0:= 0;
                acum_1:= 0;
                acum_2:= 0;
                acum_3:= 0;
                acum_4:= 0;
                acum_5:= 0;
                acum_6:= 0;
                acum_7:= 0;
                acum_8:= 0;
                acum_9:= 0;
                acum_10:= 0;
                acum_11:= 0;
                acum_12:= 0;
                acum_13:= 0;
                acum_14:= 0;
                acum_15:= 0;
                acum_16:= 0;
                acum_17:= 0;
                acum_18:= 0;
                acum_19:= 0;
                acum_20:= 0;
                acum_21:= 0;
                acum_22:= 0;
                acum_23:= 0;
                hour_tmp:= 0;
                sqlvar:= format('select et."EntryTimestamptrip" as timetrip FROM "ExitTrip" et WHERE DATE(et."EntryTimestamptrip") =' || quote_literal('%s'), reg.entrydate);
                IF monto_cero = false THEN
                     sqlvar := sqlvar || ' AND (CASE WHEN et."OldAmount" IS NULL THEN et."Amount" ELSE et."OldAmount" END) > 0';
                END IF;
                FOR obj IN EXECUTE sqlvar
                LOOP
                    hour_tmp:= CAST(date_part('hour', obj.timetrip) as INTEGER);
                    CASE hour_tmp
                        WHEN 0 THEN
                            acum_0:= acum_0 + 1;
                        WHEN 1 THEN
                            acum_1:= acum_1 + 1;
                        WHEN 2 THEN
                            acum_2:= acum_2 + 1;
                        WHEN 3 THEN
                            acum_3:= acum_3 + 1;
                        WHEN 4 THEN
                            acum_4:= acum_4 + 1;
                        WHEN 5 THEN
                            acum_5:= acum_5 + 1;
                        WHEN 6 THEN
                            acum_6:= acum_6 + 1;
                        WHEN 7 THEN
                            acum_7:= acum_7 + 1;
                        WHEN 8 THEN
                            acum_8:= acum_8 + 1;
                        WHEN 9 THEN
                            acum_9:= acum_9 + 1;
                        WHEN 10 THEN
                            acum_10:= acum_10 + 1;
                        WHEN 11 THEN
                            acum_11:= acum_11 + 1;
                        WHEN 12 THEN
                            acum_12:= acum_12 + 1;
                        WHEN 13 THEN
                            acum_13:= acum_13 + 1;
                        WHEN 14 THEN
                            acum_14:= acum_14 + 1;
                        WHEN 15 THEN
                            acum_15:= acum_15 + 1;
                        WHEN 16 THEN
                            acum_16:= acum_16 + 1;
                        WHEN 17 THEN
                            acum_17:= acum_17 + 1;
                        WHEN 18 THEN
                            acum_18:= acum_18 + 1;
                        WHEN 19 THEN
                            acum_19:= acum_19 + 1;
                        WHEN 20 THEN
                            acum_20:= acum_20 + 1;
                        WHEN 21 THEN
                            acum_21:= acum_21 + 1;
                        WHEN 22 THEN
                            acum_22:= acum_22 + 1;
                        WHEN 23 THEN
                            acum_23:= acum_23 + 1;
                    END CASE;
                END LOOP;
                "Sitio" := reg."Sitio";
                "Fecha":= reg.entrydate;
                "H0":= acum_0;
                "H1":= acum_1;
                "H2":= acum_2;
                "H3":= acum_3;
                "H4":= acum_4;
                "H5":= acum_5;
                "H6":= acum_6;
                "H7":= acum_7;
                "H8":= acum_8;
                "H9":= acum_9;
                "H10":= acum_10;
                "H11":= acum_11;
                "H12":= acum_12;
                "H13":= acum_13;
                "H14":= acum_14;
                "H15":= acum_15;
                "H16":= acum_16;
                "H17":= acum_17;
                "H18":= acum_18;
                "H19":= acum_19;
                "H20":= acum_20;
                "H21":= acum_21;
                "H22":= acum_22;
                "H23":= acum_23;
                arraydays:= ARRAY[acum_0, acum_1, acum_2, acum_3, acum_4, acum_5, acum_6, acum_7, acum_8, acum_9, acum_10, acum_11, acum_12, acum_13, acum_14, acum_15, acum_16, acum_17, acum_18, acum_19, acum_20, acum_21, acum_22, acum_23];
                SELECT MIN(dayvalue) INTO "MIN" FROM unnest(arraydays) as dayvalue;
                SELECT MAX(dayvalue) INTO "MAX" FROM unnest(arraydays) as dayvalue;
                SELECT AVG(dayvalue) INTO "MED" FROM unnest(arraydays) as dayvalue;
                BEGIN
                    sqlvar:= 'SELECT count(*) FROM "ExitTrip" et';
                    IF monto_cero = false THEN
                         sqlvar := sqlvar || ' WHERE (CASE WHEN et."OldAmount" IS NULL THEN et."Amount" ELSE et."OldAmount" END) > 0';
                    END IF;
                    sqlvar := sqlvar || format(' GROUP BY DATE(et."EntryTimestamptrip") HAVING DATE(et."EntryTimestamptrip") = ' || quote_literal('%s') || ' ORDER BY DATE(et."EntryTimestamptrip")', reg.entrydate);
                    EXECUTE sqlvar INTO "TOTAL";
                    EXCEPTION
                    WHEN others THEN
                        "TOTAL":= null;
                        RAISE EXCEPTION 'TOTAL % not found', DATE(et."EntryTimestamptrip");
                END;
                IF "TOTAL" IS NULL THEN
                    "TOTAL" = 0;
                END IF;
                RETURN NEXT;
            END LOOP;
        CLOSE cur_dias;
    ELSE
        OPEN cur_sitios FOR select unnest(string_to_array(idsite,',')) AS site;
            LOOP
                FETCH cur_sitios INTO regsitios;
                EXIT WHEN NOT FOUND;
                OPEN cur_dias FOR
                    SELECT DISTINCT DATE(et."EntryTimestamptrip") AS entrydate, ds."Description" as "Sitio"
                    FROM "ExitTrip" et
                    inner join "Def_Site" ds on ds."IdSite" = et."IdSite"
                    WHERE DATE(et."EntryTimestamptrip") BETWEEN fecha_inicio AND fecha_final
                    AND et."IdSite" = CAST(regsitios.site as integer);
                    LOOP
                        FETCH cur_dias INTO reg;
                        EXIT WHEN NOT FOUND;
                        acum_0:= 0;
                        acum_1:= 0;
                        acum_2:= 0;
                        acum_3:= 0;
                        acum_4:= 0;
                        acum_5:= 0;
                        acum_6:= 0;
                        acum_7:= 0;
                        acum_8:= 0;
                        acum_9:= 0;
                        acum_10:= 0;
                        acum_11:= 0;
                        acum_12:= 0;
                        acum_13:= 0;
                        acum_14:= 0;
                        acum_15:= 0;
                        acum_16:= 0;
                        acum_17:= 0;
                        acum_18:= 0;
                        acum_19:= 0;
                        acum_20:= 0;
                        acum_21:= 0;
                        acum_22:= 0;
                        acum_23:= 0;
                        hour_tmp:= 0;
                        sqlvar:= format('select et."EntryTimestamptrip" as timetrip FROM "ExitTrip" et WHERE DATE(et."EntryTimestamptrip") =' || quote_literal('%s') || ' AND et."IdSite" = CAST(%s as integer)', reg.entrydate, regsitios.site);
                        IF monto_cero = false THEN
                             sqlvar := sqlvar || ' AND (CASE WHEN et."OldAmount" IS NULL THEN et."Amount" ELSE et."OldAmount" END) > 0';
                        END IF;
                        FOR obj IN EXECUTE sqlvar
                        LOOP
                            hour_tmp:= CAST(date_part('hour', obj.timetrip) as INTEGER);
                            CASE hour_tmp
                                WHEN 0 THEN
                                    acum_0:= acum_0 + 1;
                                WHEN 1 THEN
                                    acum_1:= acum_1 + 1;
                                WHEN 2 THEN
                                    acum_2:= acum_2 + 1;
                                WHEN 3 THEN
                                    acum_3:= acum_3 + 1;
                                WHEN 4 THEN
                                    acum_4:= acum_4 + 1;
                                WHEN 5 THEN
                                    acum_5:= acum_5 + 1;
                                WHEN 6 THEN
                                    acum_6:= acum_6 + 1;
                                WHEN 7 THEN
                                    acum_7:= acum_7 + 1;
                                WHEN 8 THEN
                                    acum_8:= acum_8 + 1;
                                WHEN 9 THEN
                                    acum_9:= acum_9 + 1;
                                WHEN 10 THEN
                                    acum_10:= acum_10 + 1;
                                WHEN 11 THEN
                                    acum_11:= acum_11 + 1;
                                WHEN 12 THEN
                                    acum_12:= acum_12 + 1;
                                WHEN 13 THEN
                                    acum_13:= acum_13 + 1;
                                WHEN 14 THEN
                                    acum_14:= acum_14 + 1;
                                WHEN 15 THEN
                                    acum_15:= acum_15 + 1;
                                WHEN 16 THEN
                                    acum_16:= acum_16 + 1;
                                WHEN 17 THEN
                                    acum_17:= acum_17 + 1;
                                WHEN 18 THEN
                                    acum_18:= acum_18 + 1;
                                WHEN 19 THEN
                                    acum_19:= acum_19 + 1;
                                WHEN 20 THEN
                                    acum_20:= acum_20 + 1;
                                WHEN 21 THEN
                                    acum_21:= acum_21 + 1;
                                WHEN 22 THEN
                                    acum_22:= acum_22 + 1;
                                WHEN 23 THEN
                                    acum_23:= acum_23 + 1;
                            END CASE;
                        END LOOP;
                        "Id Sitio":= CAST(regsitios.site as integer);
                        "Sitio" := reg."Sitio";
                        "Fecha":= reg.entrydate;
                        "H0":= acum_0;
                        "H1":= acum_1;
                        "H2":= acum_2;
                        "H3":= acum_3;
                        "H4":= acum_4;
                        "H5":= acum_5;
                        "H6":= acum_6;
                        "H7":= acum_7;
                        "H8":= acum_8;
                        "H9":= acum_9;
                        "H10":= acum_10;
                        "H11":= acum_11;
                        "H12":= acum_12;
                        "H13":= acum_13;
                        "H14":= acum_14;
                        "H15":= acum_15;
                        "H16":= acum_16;
                        "H17":= acum_17;
                        "H18":= acum_18;
                        "H19":= acum_19;
                        "H20":= acum_20;
                        "H21":= acum_21;
                        "H22":= acum_22;
                        "H23":= acum_23;
                        arraydays:= ARRAY[acum_0, acum_1, acum_2, acum_3, acum_4, acum_5, acum_6, acum_7, acum_8, acum_9, acum_10, acum_11, acum_12, acum_13, acum_14, acum_15, acum_16, acum_17, acum_18, acum_19, acum_20, acum_21, acum_22, acum_23];
                        SELECT MIN(dayvalue) INTO "MIN" FROM unnest(arraydays) as dayvalue;
                        SELECT MAX(dayvalue) INTO "MAX" FROM unnest(arraydays) as dayvalue;
                        SELECT AVG(dayvalue) INTO "MED" FROM unnest(arraydays) as dayvalue;
                        BEGIN
                            sqlvar:= format('SELECT count(*) FROM "ExitTrip" et WHERE et."IdSite" = CAST(%s as integer)', regsitios.site);
                            IF monto_cero = false THEN
                                 sqlvar := sqlvar || ' AND (CASE WHEN et."OldAmount" IS NULL THEN et."Amount" ELSE et."OldAmount" END) > 0';
                            END IF;
                            sqlvar := sqlvar || format(' GROUP BY DATE(et."EntryTimestamptrip") HAVING DATE(et."EntryTimestamptrip") = ' || quote_literal('%s') || ' ORDER BY DATE(et."EntryTimestamptrip")', reg.entrydate);
                            EXECUTE sqlvar INTO "TOTAL";
                            EXCEPTION
                            WHEN others THEN
                                "TOTAL":= null;
                                RAISE EXCEPTION 'TOTAL % not found', DATE(et."EntryTimestamptrip");
                        END;
                        IF "TOTAL" IS NULL THEN
                            "TOTAL" = 0;
                        END IF;
                        RETURN NEXT;
                    END LOOP;
                CLOSE cur_dias;                --RETURN NEXT;
            END LOOP;
        CLOSE cur_sitios;
    END IF;
    RETURN;
END $function$
;
CREATE OR REPLACE FUNCTION spreport_ocupaciondiashoras(ofset integer, vlimit integer, idsite text, fecha_inicio date, fecha_final date, monto_cero boolean, segmentado boolean)
 RETURNS TABLE("Id Sitio" integer, "Sitio" text, "Fecha" date, "H0" integer, "H1" integer, "H2" integer, "H3" integer, "H4" integer, "H5" integer, "H6" integer, "H7" integer, "H8" integer, "H9" integer, "H10" integer, "H11" integer, "H12" integer, "H13" integer, "H14" integer, "H15" integer, "H16" integer, "H17" integer, "H18" integer, "H19" integer, "H20" integer, "H21" integer, "H22" integer, "H23" integer, "MAX" integer, "MIN" integer, "MED" integer, "TOTAL" integer)
 LANGUAGE plpgsql
AS $function$
DECLARE
BEGIN     --Validacion de parametros de entrada paginacion
    IF ofset = 0 THEN
        ofset:= NULL;
    END IF;
    IF vlimit = 0 THEN
        vlimit:= NULL;
    END IF;
    RETURN QUERY select * from tmp_ocupaciondiashoras(idsite, fecha_inicio, fecha_final, monto_cero, segmentado) LIMIT vlimit OFFSET ofset;
END $function$
;
CREATE OR replace FUNCTION spreport_tiempoestadia (IN ofset int4, IN vlimit int4, IN idsite TEXT, IN fecha_inicio date, IN fecha_final date, IN periodo_duracion_minutos int4, IN monto_cero bool, IN segmentado bool)
RETURNS
	TABLE(
		"Id Sitio" int4,
		"Fecha" date,
		"Duracion de Estadia" text,
		"Vehiculos en ese periodo" int4,
		"Porcentaje" int4,
		"Monto" int4
	) as $BODY$
DECLARE
BEGIN
    IF ofset = 0 THEN
		ofset:= NULL;
	END IF;
	IF vlimit = 0 THEN
		vlimit:= NULL;
	END IF;
	RETURN QUERY select * from tmp_tiempoestadia(idsite, fecha_inicio, fecha_final, periodo_duracion_minutos, monto_cero, segmentado) as p Where p."Vehiculos en ese periodo" > 0 LIMIT vlimit OFFSET ofset;
END $BODY$ LANGUAGE 'plpgsql';
CREATE OR replace FUNCTION tmp_tiempoestadia (IN idsite TEXT, IN fecha_inicio date, IN fecha_final date, IN periodo_duracion_minutos int4, IN monto_cero bool, IN segmentado bool)
RETURNS
	TABLE(
		"Id Sitio" int4,
		"Fecha" date,
		"Duracion de Estadia" text,
		"Vehiculos en ese periodo" int4,
		"Porcentaje" int4,
		"Monto" int4
	) as $BODY$
DECLARE
    reg RECORD;
	regsitios RECORD;
	obj RECORD;
	cur_dias refcursor;
	cur_sitios refcursor;
	cur_segmentado refcursor;
	totalreg int4;
	indice int4;
	duracion text;
	valinf int4;
	valsup int4;
	regdia int4;
	vehiculosper int4;
	montocalc int4;
BEGIN
	IF segmentado = false THEN
		OPEN cur_dias FOR
	   		SELECT DISTINCT DATE(et."EntryTimestamptrip") AS entrydate
			FROM "ExitTrip" et
			WHERE DATE(et."EntryTimestamptrip") BETWEEN fecha_inicio AND fecha_final
			AND CAST(et."IdSite" as varchar) = any(string_to_array(idsite,','));
			LOOP
				FETCH cur_dias INTO reg;
				EXIT WHEN NOT FOUND;
				indice:= 0;
				totalreg:= 1440/periodo_duracion_minutos;
				LOOP
					valinf:= (indice * periodo_duracion_minutos);
					valsup:= ((indice + 1) * periodo_duracion_minutos);
					duracion:= TO_CHAR(format('%s minute', valinf)::interval, 'HH24h:MIm') || ' <-> ' || TO_CHAR(format('%s minute', valsup)::interval, 'HH24h:MIm');
					BEGIN
						SELECT COUNT(*) INTO regdia FROM "ExitTrip" et WHERE DATE(et."EntryTimestamptrip") = reg.entrydate GROUP BY DATE(et."EntryTimestamptrip");
						EXCEPTION
					        WHEN others THEN
					        regdia:= null;
				            RAISE EXCEPTION 'regdia % not found', reg.entrydate;
					END;
					BEGIN
						SELECT count(*) INTO vehiculosper FROM "ExitTrip" et  WHERE DATE(et."EntryTimestamptrip") = reg.entrydate
						AND CAST(EXTRACT(epoch FROM age(et."Timestamptrip", et."EntryTimestamptrip"))/60 AS INTEGER) >= valinf
						AND CAST(EXTRACT(epoch FROM age(et."Timestamptrip", et."EntryTimestamptrip"))/60 AS INTEGER) < valsup;
						EXCEPTION
					        WHEN others THEN
					        vehiculosper:= null;
				            RAISE EXCEPTION 'vehiculosper % not found', reg.entrydate;
					END;
					BEGIN
						SELECT SUM(CASE WHEN et."OldAmount" IS NULL THEN et."Amount" ELSE et."OldAmount" END) INTO montocalc
						FROM "ExitTrip" et  WHERE DATE(et."EntryTimestamptrip") = reg.entrydate
						AND CAST(EXTRACT(epoch FROM age(et."Timestamptrip", et."EntryTimestamptrip"))/60 AS INTEGER) >= valinf
						AND CAST(EXTRACT(epoch FROM age(et."Timestamptrip", et."EntryTimestamptrip"))/60 AS INTEGER) < valsup;
						EXCEPTION
					        WHEN others THEN
					        montocalc:= null;
				            RAISE EXCEPTION 'montocalc % not found', reg.entrydate;
					END;
					IF montocalc IS NULL THEN
						montocalc:= 0;
					END IF;
					"Porcentaje":= (vehiculosper * 100) / regdia;
					"Fecha":= reg.entrydate;
				   	"Duracion de Estadia":=duracion;
				   	"Vehiculos en ese periodo":= vehiculosper;
				   	"Monto":= montocalc;
				   	indice:= indice + 1;
			   		IF indice >= totalreg THEN
				        EXIT;  -- exit loop
				    END IF;
				   	RETURN NEXT;
				END LOOP;--RETURN NEXT;
			END LOOP;
		CLOSE cur_dias;
	ELSE
		OPEN cur_sitios FOR select unnest(string_to_array(idsite,',')) AS site;
			LOOP
				FETCH cur_sitios INTO regsitios;
				EXIT WHEN NOT FOUND;
				OPEN cur_dias FOR
			   		SELECT DISTINCT DATE(et."EntryTimestamptrip") AS entrydate
					FROM "ExitTrip" et
					WHERE DATE(et."EntryTimestamptrip") BETWEEN fecha_inicio AND fecha_final
					AND et."IdSite" = CAST(regsitios.site as integer);
					LOOP
						FETCH cur_dias INTO reg;
						EXIT WHEN NOT FOUND;
						indice:= 0;
						totalreg:= 1440/periodo_duracion_minutos;
						LOOP
							valinf:= (indice * periodo_duracion_minutos);
							valsup:= ((indice + 1) * periodo_duracion_minutos);
							duracion:= TO_CHAR(format('%s minute', valinf)::interval, 'HH24h:MIm') || ' <-> ' || TO_CHAR(format('%s minute', valsup)::interval, 'HH24h:MIm');
							BEGIN
								SELECT COUNT(*) INTO regdia FROM "ExitTrip" et
								WHERE DATE(et."EntryTimestamptrip") = reg.entrydate AND et."IdSite" = CAST(regsitios.site as integer) GROUP BY DATE(et."EntryTimestamptrip");
								EXCEPTION
							        WHEN others THEN
							        regdia:= null;
						            RAISE EXCEPTION 'regdia % not found', reg.entrydate;
							END;
							BEGIN
								SELECT count(*) INTO vehiculosper FROM "ExitTrip" et  WHERE DATE(et."EntryTimestamptrip") = reg.entrydate
								AND et."IdSite" = CAST(regsitios.site as integer)
								AND CAST(EXTRACT(epoch FROM age(et."Timestamptrip", et."EntryTimestamptrip"))/60 AS INTEGER) >= valinf
								AND CAST(EXTRACT(epoch FROM age(et."Timestamptrip", et."EntryTimestamptrip"))/60 AS INTEGER) < valsup;
								EXCEPTION
							        WHEN others THEN
							        vehiculosper:= null;
						            RAISE EXCEPTION 'vehiculosper % not found', reg.entrydate;
							END;
							BEGIN
								SELECT SUM(CASE WHEN et."OldAmount" IS NULL THEN et."Amount" ELSE et."OldAmount" END) INTO montocalc
								FROM "ExitTrip" et  WHERE DATE(et."EntryTimestamptrip") = reg.entrydate
								AND et."IdSite" = CAST(regsitios.site as integer)
								AND CAST(EXTRACT(epoch FROM age(et."Timestamptrip", et."EntryTimestamptrip"))/60 AS INTEGER) >= valinf
								AND CAST(EXTRACT(epoch FROM age(et."Timestamptrip", et."EntryTimestamptrip"))/60 AS INTEGER) < valsup;
								EXCEPTION
							        WHEN others THEN
							        montocalc:= null;
						            RAISE EXCEPTION 'montocalc % not found', reg.entrydate;
							END;
							IF montocalc IS NULL THEN
								montocalc:= 0;
							END IF;
							"Id Sitio" = CAST(regsitios.site as integer);
							"Porcentaje":= (vehiculosper * 100) / regdia;
							"Fecha":= reg.entrydate;
						   	"Duracion de Estadia":=duracion;
						   	"Vehiculos en ese periodo":= vehiculosper;
						   	"Monto":= montocalc;
						   	indice:= indice + 1;
					   		IF indice >= totalreg THEN
						        EXIT;  -- exit loop
						    END IF;
						   	RETURN NEXT;
						END LOOP; --RETURN NEXT;
					END LOOP;
				CLOSE cur_dias;	--RETURN NEXT;
			END LOOP;
		CLOSE cur_sitios;
	END IF;
	RETURN;
END $BODY$ LANGUAGE 'plpgsql';
CREATE OR REPLACE FUNCTION tmp_totaltransitos(idsite text, fecha_inicio date, fecha_final date, cobro_excesivo integer, segmentado boolean)
 RETURNS TABLE("Id Sitio" integer, "Sitio" text, "Fecha" date, "Minutos" integer, "Gratis" integer, "Normal" integer, "Excesiva" integer, "Cantidad" integer, "Monto" integer)
 LANGUAGE plpgsql
AS $function$
DECLARE
    reg RECORD;
    regsitios RECORD;
    obj RECORD;
    cur_dias refcursor;
    cur_sitios refcursor;
    cur_segmentado refcursor;
    green bool := false;
    calc_amount int4:= 0;
    acum_amount int4:= 0;
    acum_minutes int4:= 0;
    total int4;
    cont_gratis int4:= 0;
    cont_normal int4:= 0;
    cont_exc int4:= 0;
BEGIN
    --Validacion de parametros de entrada paginacion
    IF segmentado = false THEN
        OPEN cur_dias FOR
            SELECT DISTINCT DATE(et."EntryTimestamptrip") AS entrydate, ds."Description" as "Sitio"
            FROM "ExitTrip" et
            inner join "Def_Site" ds on ds."IdSite" = et."IdSite"
            WHERE DATE(et."EntryTimestamptrip") BETWEEN fecha_inicio AND fecha_final
            AND CAST(et."IdSite" as varchar) = any(string_to_array(idsite,','));
            LOOP
                -- fetch row into the film
                FETCH cur_dias INTO reg;
                -- exit when no more row to fetch
                EXIT WHEN NOT FOUND;
                calc_amount:= 0;
                acum_amount:= 0;
                acum_minutes:= 0;
                cont_gratis:= 0;
                cont_normal:= 0;
                cont_exc:= 0;
                FOR obj IN  SELECT et."Amount", et."OldAmount",
                            (EXTRACT(epoch FROM age(et."Timestamptrip", et."EntryTimestamptrip"))/60)::numeric::integer AS minutes, et."Nquickpass"
                            FROM "ExitTrip" et
                            WHERE DATE(et."EntryTimestamptrip") = reg.entrydate
                LOOP
                    --Calculo del total del monto para el dia
                    IF obj."OldAmount" IS NULL THEN
                        calc_amount:= obj."Amount";
                    ELSE
                        calc_amount:= obj."OldAmount";
                    END IF;
                    acum_amount:= acum_amount + calc_amount;
                                      --Calculo del total de minutos para el dia
                    acum_minutes:= acum_minutes + obj.minutes;
                             --Calculo de tipo de entrada
                    BEGIN
                        SELECT ts."Green" INTO green FROM "H_TrfSubscriber" ts WHERE ts."TAG" = obj."Nquickpass"
                        AND DATE(ts."DateUpdateorDel") = reg.entrydate LIMIT 1;
                        EXCEPTION
                        WHEN others THEN
                            green:= null;
                            RAISE EXCEPTION 'green % not found', reg."Nquickpass";
                    END;
                    IF green = true AND calc_amount < cobro_excesivo THEN
                        cont_gratis:= cont_gratis + 1;
                    ELSIF calc_amount < cobro_excesivo THEN
                        cont_normal:= cont_normal + 1;
                    ELSIF calc_amount >= cobro_excesivo THEN
                        cont_exc:= cont_exc + 1;
                    END IF;
                END LOOP;      --Asignacion de variables
                "Sitio" := reg."Sitio";
                "Fecha" := reg.entrydate;
                "Monto":= acum_amount;
                "Minutos":= acum_minutes;
                "Gratis" := cont_gratis;
                "Normal" := cont_normal;
                "Excesiva" := cont_exc;
                BEGIN  --Calculo de cantidad de registros encontrados para las fechas
                    SELECT count(*) INTO "Cantidad" FROM "ExitTrip" et
                    GROUP BY DATE(et."EntryTimestamptrip")
                    HAVING DATE(et."EntryTimestamptrip") = reg.entrydate ORDER BY DATE(et."EntryTimestamptrip");
                    EXCEPTION
                    WHEN others THEN
                        "Cantidad":= null;
                        RAISE EXCEPTION 'CANTIDAD % not found', DATE(et."EntryTimestamptrip");
                END;
                RETURN NEXT;
            END LOOP;
        CLOSE cur_dias;
    ELSE
        OPEN cur_sitios FOR select unnest(string_to_array(idsite,',')) AS site;
            LOOP
                FETCH cur_sitios INTO regsitios;
                EXIT WHEN NOT FOUND;
                OPEN cur_dias FOR
                    SELECT DISTINCT DATE(et."EntryTimestamptrip") AS entrydate, ds."Description" as "Sitio"
                    FROM "ExitTrip" et
                    inner join "Def_Site" ds on ds."IdSite" = et."IdSite"
                    WHERE DATE(et."EntryTimestamptrip") BETWEEN fecha_inicio AND fecha_final
                    AND et."IdSite" = CAST(regsitios.site as integer);
                    LOOP
                        FETCH cur_dias INTO reg;
                        EXIT WHEN NOT FOUND;
                        calc_amount:= 0;
                        acum_amount:= 0;
                        acum_minutes:= 0;
                        cont_gratis:= 0;
                        cont_normal:= 0;
                        cont_exc:= 0;
                        FOR obj IN  SELECT et."Amount", et."OldAmount",
                                    (EXTRACT(epoch FROM age(et."Timestamptrip", et."EntryTimestamptrip"))/60)::numeric::integer AS minutes, et."Nquickpass"
                                    FROM "ExitTrip" et
                                    WHERE DATE(et."EntryTimestamptrip") = reg.entrydate AND et."IdSite" = CAST(regsitios.site as integer)
                        LOOP   --Calculo del total del monto para el dia
                            IF obj."OldAmount" IS NULL THEN
                                calc_amount:= obj."Amount";
                            ELSE
                                calc_amount:= obj."OldAmount";
                            END IF;
                            acum_amount:= acum_amount + calc_amount;  --Calculo del total de minutos para el dia
                            acum_minutes:= acum_minutes + obj.minutes;
                             BEGIN
                                SELECT ts."Green" INTO green FROM "H_TrfSubscriber" ts WHERE ts."TAG" = obj."Nquickpass"
                                AND DATE(ts."DateUpdateorDel") = reg.entrydate LIMIT 1;
                                EXCEPTION
                                WHEN others THEN
                                    green:= null;
                                    RAISE EXCEPTION 'green % not found', reg."Nquickpass";
                            END;
                            IF green = true AND calc_amount < cobro_excesivo THEN
                                cont_gratis:= cont_gratis + 1;
                            ELSIF calc_amount < cobro_excesivo THEN
                                cont_normal:= cont_normal + 1;
                            ELSIF calc_amount >= cobro_excesivo THEN
                                cont_exc:= cont_exc + 1;
                            END IF;
                        END LOOP;
                        "Id Sitio":= CAST(regsitios.site as integer);
                        "Sitio" := reg."Sitio";
                        "Fecha" := reg.entrydate;
                        "Monto":= acum_amount;
                        "Minutos":= acum_minutes;
                        "Gratis" := cont_gratis;
                        "Normal" := cont_normal;
                        "Excesiva" := cont_exc;
                        BEGIN
                            SELECT count(*) INTO "Cantidad" FROM "ExitTrip" et
                            where et."IdSite" = CAST(regsitios.site as integer)
                            GROUP BY DATE(et."EntryTimestamptrip")
                            HAVING DATE(et."EntryTimestamptrip") = reg.entrydate
                            ORDER BY DATE(et."EntryTimestamptrip");
                            EXCEPTION
                            WHEN others THEN
                                "Cantidad":= null;
                                RAISE EXCEPTION 'CANTIDAD % not found', DATE(et."EntryTimestamptrip");
                        END;
                      RETURN NEXT;
                    END LOOP;
                CLOSE cur_dias; --RETURN NEXT;
            END LOOP;
        CLOSE cur_sitios;
    END IF;
    RETURN;
END $function$
;
CREATE OR REPLACE FUNCTION spreport_totaltransitos(ofset integer, vlimit integer, idsite text, fecha_inicio date, fecha_final date, cobro_excesivo integer, segmentado boolean)
 RETURNS TABLE("Id Sitio" integer, "Sitio" text, "Fecha" date, "Minutos" integer, "Gratis" integer, "Normal" integer, "Excesiva" integer, "Cantidad" integer, "Monto" integer)
 LANGUAGE plpgsql
AS $function$
DECLARE
BEGIN  --Validacion de parametros de entrada paginacion
    IF ofset = 0 THEN
        ofset:= NULL;
    END IF;
    IF vlimit = 0 THEN
        vlimit:= NULL;
    END IF;
    RETURN QUERY select * from tmp_totaltransitos(idsite, fecha_inicio, fecha_final, cobro_excesivo, segmentado) LIMIT vlimit OFFSET ofset;
END $function$
;
CREATE OR REPLACE VIEW uv_claimlist
AS SELECT c."IdSite" AS "Id Sitio",
    ds."Description" AS "Sitio",
    c."Id" AS "Id Reclamo",
    c."DateCreate" AS "Fecha Creacion",
    c."Nquickpass" AS "Dispositivo",
    et."EntryTimestamptrip" AS "Fecha Entrada",
    c."Timestamptrip" AS "Fecha Salida",
    (date_part('epoch'::text, age(et."Timestamptrip", et."EntryTimestamptrip")) / 60::double precision)::numeric::integer AS "Minutos",
        CASE
            WHEN et."OldAmount" IS NULL THEN rt."Amount"
            ELSE et."OldAmount"
        END AS "Monto Transito",
    c."NewAmount" AS "Monto Reclamo",
        CASE
            WHEN et."OldAmount" IS NULL THEN rt."Amount"
            ELSE et."OldAmount"
        END - c."NewAmount" AS "Diferencia",
    dc."Description" AS "Estatus"
   FROM "Claim" c
     JOIN "ExitTrip" et ON c."IdTrip" = et."IdTrip" AND c."IdSite" = et."IdSite"
     JOIN "RemittancedTrips" rt ON rt."IdTrip" = et."IdTrip" AND rt."IdSite" = et."IdSite"
     JOIN "Def_Site" ds ON ds."IdSite" = c."IdSite"
     JOIN "Def_Claim" dc ON c."Status" = dc."Id";
CREATE OR REPLACE VIEW uv_discountapplieddet
AS SELECT et."IdSite" AS "Id Sitio",
    ds."Description" AS "Sitio",
    et."Nquickpass" AS "Dispositivo",
    d."Description" AS "Descuento",
    et."EntryTimestamptrip" AS "Fecha Entrada",
    da."DateApplied" AS "Fecha Descuento",
    et."Timestamptrip" AS "Fecha Salida",
    (date_part('epoch'::text, age(et."Timestamptrip", et."EntryTimestamptrip")) / 60::double precision)::numeric::integer AS "Minutos"
   FROM "DiscountApplied" da
     JOIN "ExitTrip" et ON et."IdSite" = da."IdSite" AND da."IdTrip" = et."IdTrip"
     JOIN "Def_Site" ds ON ds."IdSite" = da."IdSite"
     JOIN "Discount" d ON d."IdDatacenter" = da."DiscountId";
CREATE OR REPLACE VIEW uv_discountappliedsum
AS SELECT d."IdSite" AS "Id Sitio",
    ds."Description" AS "Sitio",
    d."Description" AS "Tipo Descuento",
    (sum(da."OldAmount") - sum(da."NewAmount"))::integer AS "Monto  a Aplicar",
    count(1)::integer AS "Vehículos ConDescuento",
    sum(da."OldAmount")::integer AS "Monto Anterior",
    sum(da."NewAmount")::integer AS "Monto Final"
   FROM "DiscountApplied" da
     JOIN "Discount" d ON da."IdSite" = d."IdSite" AND da."DiscountId" = d."IdDatacenter"
     JOIN "Def_Site" ds ON ds."IdSite" = da."IdSite"
  GROUP BY d."IdSite", ds."Description", d."Description";
CREATE OR REPLACE VIEW uv_transitosgrupos
AS SELECT et."IdSite" AS "Id Sitio",
    ds."Description" AS "Sitio",
    et."IdTrip" AS "Consecutivo",
    et."Nquickpass" AS "Dispositivo",
    et."IdEntryLane" AS "Carril Entrada",
    et."EntryTimestamptrip" AS "Fecha Entrada",
    et."IdLane" AS "Carril Salida",
    et."Timestamptrip" AS "Fecha Salida",
    (date_part('epoch'::text, age(et."Timestamptrip", et."EntryTimestamptrip")) / 60::double precision)::numeric::integer AS "Minutos",
        CASE
            WHEN et."OldAmount" IS NULL THEN et."Amount"
            ELSE et."OldAmount"
        END AS "Monto",
    tgs."IdGroup" AS "Id Grupo",
    tgs."Description" AS "Descripcion Grupo"
   FROM "ExitTrip" et
     JOIN "TrfGroupSubscriber" tgs ON et."IdSite" = tgs."IdSite"
     JOIN "Def_Site" ds ON ds."IdSite" = et."IdSite";
CREATE OR REPLACE VIEW uv_transitsresum
AS SELECT et."IdSite" AS "Id Sitio",
    ds."Description" AS "Sitio",
    (et."Timestamptrip"::date) :: timestamp AS "Fecha",
    count(
        CASE
            WHEN et."Amount" = 0::numeric THEN et."Nquickpass"
            ELSE NULL::character varying
        END) AS "Transitos Monto 0",
    count(
        CASE
            WHEN et."Amount" > 0::numeric THEN et."Nquickpass"
            ELSE NULL::character varying
        END) AS "Transitos con Monto",
    count(*) AS "Total Transitos",
    sum(
        CASE
            WHEN et."OldAmount" IS NULL THEN et."Amount"
            ELSE et."OldAmount"
        END) AS "Monto",
    COALESCE(sum(
        CASE
            WHEN (( SELECT count(*) AS count
               FROM "DiscountType" dt
              WHERE dt."IdSite" = et."IdSite")) = 0 THEN et."OldAmount" - et."Amount"
            ELSE da."OldAmount" - da."NewAmount"
        END), 0::numeric) AS "Descuentos",
    sum(
        CASE
            WHEN et."OldAmount" IS NULL THEN et."Amount"
            ELSE et."OldAmount"
        END) - COALESCE(sum(
        CASE
            WHEN (( SELECT count(*) AS count
               FROM "DiscountType" dt
              WHERE dt."IdSite" = et."IdSite")) = 0 THEN et."OldAmount" - et."Amount"
            ELSE da."OldAmount" - da."NewAmount"
        END), 0::numeric) AS "Monto Final"
   FROM "ExitTrip" et
     LEFT JOIN "Def_Site" ds ON ds."IdSite" = et."IdSite"
     LEFT JOIN "DiscountApplied" da ON da."IdTrip" = et."IdTrip" AND da."IdLane" = et."IdLane" AND da."Compass"::text = et."Nquickpass"::text
  GROUP BY (et."Timestamptrip"::date), et."IdSite", ds."Description"
  ORDER BY (et."Timestamptrip"::date) DESC;


