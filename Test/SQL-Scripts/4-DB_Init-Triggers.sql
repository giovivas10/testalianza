create trigger insdelexit after
delete
    on
    "ExitTrip" for each row execute procedure insertexittrips();
create trigger insertexit before
insert
    on
   "ExitTrip" for each row execute procedure insertexittrips();
create trigger insdelentry after
delete
    on
    "EntryTrips" for each row execute procedure insertentrytrips();
create trigger insertentry before
insert
    on
   "EntryTrips" for each row execute procedure insertentrytrips();
create trigger deltrfsubscriber after
delete
    on
    "TrfSubscriber" for each row execute procedure insertsubscribers(); 
create trigger insertsubscribers before
insert
    or
update
    on
    "TrfSubscriber" for each row execute procedure insertsubscribers();
create trigger update_country before
update
    on
    "Country" for each row execute procedure func_update_country();
create trigger delete_country before
delete
    on
    "Country" for each row execute procedure func_delete_country();
create trigger update_def_site before
update
    on
    "Def_Site" for each row execute procedure func_update_def_site();
create trigger delete_def_site before
delete
    on
    "Def_Site" for each row execute procedure func_delete_def_site();
create trigger update_discount before
update
    on
    "Discount" for each row execute procedure func_update_discount();
create trigger delete_discount before
delete
    on
    "Discount" for each row execute procedure func_delete_discount();
create trigger update_discount_pend before
update
    on
    "Discount_Pend" for each row execute procedure func_update_discount_pend();
create trigger delete_discount_pend before
delete
    on
    "Discount_Pend" for each row execute procedure func_delete_discount_pend();
create trigger update_discount_parameter before
update
    on
    "DiscountParameter" for each row execute procedure func_update_discount_parameter();
create trigger delete_discount_parameter before
delete
    on
    "DiscountParameter" for each row execute procedure func_delete_discount_parameter();
create trigger update_discount_type before
update
    on
    "DiscountType" for each row execute procedure func_update_discount_type();
create trigger delete_discount_type before
delete
    on
    "DiscountType" for each row execute procedure func_delete_discount_type();
create trigger update_discountapplied before
update
    on
    "DiscountApplied" for each row execute procedure func_update_discountapplied();
create trigger delete_discountapplied before
delete
    on
    "DiscountApplied" for each row execute procedure func_delete_discountapplied();
create trigger update_discountsumhistory before
update
    on
    "DiscountSumHistory" for each row execute procedure func_update_discountsumhistory();
create trigger delete_discountsumhistory before
delete
    on
    "DiscountSumHistory" for each row execute procedure func_delete_discountsumhistory();

