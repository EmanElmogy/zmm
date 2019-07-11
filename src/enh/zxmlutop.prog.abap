*&---------------------------------------------------------------------*
*& Include          ZXMLUTOP
*&---------------------------------------------------------------------*
TABLES ci_eslldb.

TYPES: BEGIN OF gty_locations,

         location TYPE esll-extsrvno,
         ebeln    TYPE ekpo-ebeln,
         ebelp    TYPE ekpo-ebelp,
         lblni    TYPE essr-lblni,
         srvpos   TYPE esll-srvpos,

       END OF gty_locations.

TYPES: BEGIN OF gty_serv,

         ebeln  TYPE ekpo-ebeln,
         ebelp  TYPE ekpo-ebelp,
         srvpos TYPE esll-srvpos,
         lblni  TYPE essr-lblni,

       END OF gty_serv.

DATA: gt_locations TYPE STANDARD TABLE OF gty_locations,
      gt_old_loc   TYPE STANDARD TABLE OF gty_locations,
      gt_serv      TYPE STANDARD TABLE OF gty_serv,
      gs_locations TYPE                   gty_locations,
      gs_esll      TYPE                   esll,
      gv_edit      TYPE                   c,
      gs_serv      TYPE                   gty_serv.
