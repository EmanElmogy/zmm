*&---------------------------------------------------------------------*
*& Include          ZSES_NW_SRV
*&---------------------------------------------------------------------*
DATA : it_services TYPE TABLE OF zses_get_nw_services_gs,
       wa_service  LIKE LINE OF it_services,
       total_perc  TYPE userf2_num,
       rem_perc    TYPE userf2_num,
       matkl       TYPE asmd-matkl.
" get service group
SELECT SINGLE matkl
  FROM asmd
  INTO matkl
  WHERE asnum = srv_esll-srvpos.

IF wa_essr-frgrl IS NOT INITIAL . " the entry sheet is not approved
  CALL FUNCTION 'ZSES_GET_NW_SERVICES'
    EXPORTING
      p_srvpos   = srv_esll-srvpos
      p_ebeln    = wa_essr-ebeln
      p_ebelp    = wa_essr-ebelp
      p_location = srv_esll-zzlocation
    TABLES
      gt_output = it_services.
  CLEAR total_perc .

  LOOP AT it_services INTO wa_service .
    ADD wa_service-userf2_num TO total_perc .
  ENDLOOP.
  rem_perc = 100 - total_perc .
  ADD srv_esll-userf2_num TO total_perc .
  IF total_perc GT 100.
    MESSAGE e002(zmm) WITH rem_perc.
  ENDIF.



ENDIF.
