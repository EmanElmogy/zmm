FUNCTION zses_get_nw_services.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(P_SRVPOS) TYPE  ASNUM
*"     VALUE(P_EBELN) TYPE  EBELN
*"     VALUE(P_EBELP) TYPE  EBELP
*"     VALUE(P_LOCATION) TYPE  CHAR18
*"  TABLES
*"      GT_OUTPUT STRUCTURE  ZSES_GET_NW_SERVICES_GS
*"----------------------------------------------------------------------

  RANGES: r_location FOR p_location.
*Get all PO's created on the same service and same network

  DATA: message TYPE c LENGTH 220.

  DATA: lt_networks TYPE TABLE OF ekkn,
        ls_networks TYPE ekkn.
  DATA: lt_all_po TYPE TABLE OF ekkn,
        ls_all_po TYPE ekkn.
  DATA: lt_essr TYPE TABLE OF essr,
        ls_essr TYPE essr.
  DATA: lt_esll_temp TYPE TABLE OF esll,
        ls_esll_temp TYPE esll.
  DATA: lt_esll TYPE TABLE OF esll,
        ls_esll TYPE esll.
  DATA: gs_output LIKE LINE OF gt_output.

*  data: begin of lt_services occurs 0,
*    ebeln       type ekpo-ebeln,
*    ebelp       type ekpo-ebelp,
*    lblni       type essr-lblni,
*    sub_packno  type essr-packno,
*    esll type esll,
*  end of lt_services.
*  data: ls_services like line of lt_services.

  REFRESH: lt_networks,lt_all_po,lt_essr,lt_esll_temp,lt_esll,gt_output.
  CLEAR:   ls_networks,ls_all_po,ls_essr,ls_esll_temp,ls_esll,gs_output.

* Get networks/activities on service
  SELECT SINGLE
    nplnr
    aplzl
    FROM ekkn
    INTO CORRESPONDING FIELDS OF ls_networks
    WHERE ebeln EQ p_ebeln
      AND ebelp EQ p_ebelp
      AND nplnr NE ''.

* Get all PO on selected networks/activities
  SELECT
    ebeln
    ebelp
    nplnr
    aplzl
    aufpl
    FROM ekkn
    INTO CORRESPONDING FIELDS OF TABLE lt_all_po
    WHERE nplnr EQ ls_networks-nplnr
      AND aplzl EQ ls_networks-aplzl
      AND nplnr NE ''.

  IF sy-subrc EQ 0.
    DELETE ADJACENT DUPLICATES FROM lt_all_po COMPARING ALL FIELDS.
    DELETE lt_all_po WHERE ( ebeln EQ p_ebeln AND ebelp EQ p_ebelp ).
  ENDIF.


* Get all service entry sheets on selectd PO
  IF lt_all_po[] IS NOT INITIAL.
    SELECT
      *
      FROM essr
      INTO TABLE lt_essr
      FOR ALL ENTRIES IN lt_all_po
      WHERE ebeln EQ lt_all_po-ebeln
        AND ebelp EQ lt_all_po-ebelp
        AND loekz NE 'X'.
  ENDIF.

  IF lt_essr[] IS NOT INITIAL.
    SELECT
      packno
      sub_packno
      FROM esll
      INTO CORRESPONDING FIELDS OF TABLE lt_esll_temp
      FOR ALL ENTRIES IN lt_essr
      WHERE packno EQ lt_essr-packno.
  ENDIF.


  IF lt_esll_temp[] IS NOT INITIAL.
    SELECT
      *
      FROM esll
      INTO TABLE lt_esll
      FOR ALL ENTRIES IN lt_esll_temp
      WHERE packno     EQ lt_esll_temp-sub_packno
        AND srvpos     EQ p_srvpos
        AND zzlocation IN r_location.
  ENDIF.

  IF lt_esll[] IS NOT INITIAL.

    LOOP AT lt_esll INTO ls_esll.
      MOVE-CORRESPONDING ls_esll TO gs_output.

      READ TABLE lt_esll_temp INTO ls_esll_temp
        WITH KEY sub_packno = ls_esll-packno.

      READ TABLE lt_essr INTO ls_essr
        WITH KEY packno = ls_esll_temp-packno.

      gs_output-lblni      = ls_essr-lblni.
      gs_output-ebeln      = ls_essr-ebeln.
      gs_output-ebelp      = ls_essr-ebelp.
      gs_output-sub_packno = ls_essr-packno.

      APPEND gs_output TO gt_output.
      CLEAR: ls_esll,gs_output.
    ENDLOOP.

    SORT gt_output DESCENDING BY ebeln ebelp srvpos zzlocation packno introw.
    DELETE ADJACENT DUPLICATES FROM gt_output
      COMPARING ebeln ebelp srvpos zzlocation.
  ENDIF.
ENDFUNCTION.
