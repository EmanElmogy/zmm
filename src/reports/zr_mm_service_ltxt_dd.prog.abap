*&---------------------------------------------------------------------*
*& Include          ZR_MM_SERVICE_LTXT_DD
*&---------------------------------------------------------------------*

TABLES : asmd .

DATA: header LIKE thead,
      ilines LIKE tline OCCURS 0 WITH HEADER LINE,
      asnum  TYPE asmd-asnum,
      ltxt   TYPE string,
      len    TYPE i ,
      length TYPE i ,
      rest TYPE i ,
      off    TYPE i .


DATA: filename TYPE rlgrap-filename,
      it_tab TYPE STANDARD TABLE OF zalsmex_tabline ,
      wa_tab TYPE  zalsmex_tabline .

TYPES: BEGIN OF gty_file,
        srvpos TYPE asnum,     "Activity Number
        ltxt   TYPE string," text
  END OF gty_file.


  DATA: gt_file TYPE STANDARD TABLE OF gty_file,
        gs_file TYPE gty_file.
