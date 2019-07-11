*&---------------------------------------------------------------------*
*& Include          ZMM_SERV_PROGRESS_TRACKF01
*&---------------------------------------------------------------------*

FORM select_ses_data.


  SELECT packno ebeln ebelp
    FROM essr
    INTO CORRESPONDING FIELDS OF TABLE gt_essr
    WHERE ebeln IN so_po
    AND   ebelp IN so_item
    AND   loekz NE 'X'.

  IF gt_essr IS NOT INITIAL.

    SELECT s~extrow s~packno s~srvpos s~extrow s~userf1_num s~userf2_num s~ktext1 s~extsrvno s~ktext1 s~userf2_txt
        FROM esll AS e INNER JOIN esll AS s ON  e~sub_packno = s~packno
        INTO CORRESPONDING FIELDS OF TABLE gt_esll
        FOR ALL ENTRIES IN gt_essr
        WHERE e~packno  EQ gt_essr-packno
        AND   s~srvpos  IN so_srv
        AND   s~del     NE 'X'.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_SERV_QUANTITY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_serv_quantity .

  SELECT ekpo~ebelp s~packno s~srvpos s~menge s~userf2_txt
        FROM ekpo INNER JOIN esll AS e ON ekpo~packno = e~packno
                  INNER JOIN esll AS s ON e~sub_packno = s~packno
        INTO CORRESPONDING FIELDS OF TABLE gt_quan
        FOR ALL ENTRIES IN gt_essr
        WHERE ebeln = gt_essr-ebeln
          AND ebelp = gt_essr-ebelp
          AND s~srvpos IN so_srv.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_ITEM_DESC
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM select_item_desc .

  DATA: lv_packno TYPE esll-packno.
  IF gt_essr IS NOT INITIAL.
    SELECT ebeln ebelp txz01 menge
      FROM ekpo
      INTO CORRESPONDING FIELDS OF TABLE gt_item_desc
      FOR ALL ENTRIES IN gt_essr
      WHERE ebeln = gt_essr-ebeln
      AND   ebelp = gt_essr-ebelp.
  ENDIF.

  LOOP AT gt_esll INTO DATA(ls_esll).

    lv_packno = ls_esll-packno - 1.
    READ TABLE gt_essr INTO DATA(ls_essr) WITH KEY packno = lv_packno.
    IF sy-subrc = 0.
      gs_data-item = ls_essr-ebelp.
    ENDIF.

    READ TABLE gt_item_desc INTO DATA(ls_item_desc) WITH KEY ebeln = so_po-low ebelp = gs_data-item.
    IF sy-subrc = 0.
      gs_data-item_desc = ls_item_desc-txz01.
    ENDIF.

    gs_data-extrow    = ls_esll-extrow.
    gs_data-packno    = ls_esll-packno.
    gs_data-loc       = ls_esll-extsrvno.
    gs_data-serv_no   = ls_esll-srvpos.
    gs_data-serv_desc = ls_esll-ktext1.
    gs_data-q_total   = ls_esll-userf1_num.
    gs_data-p_total   = ls_esll-userf2_num.

    READ TABLE gt_quan INTO DATA(ls_quan) WITH KEY ebelp = gs_data-item srvpos = ls_esll-srvpos.
    IF sy-subrc = 0.
      gs_data-userf2_txt = ls_quan-userf2_txt.
      gs_data-menge      = ls_quan-menge.
    ENDIF.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = gs_data-serv_no
      IMPORTING
        output = gs_data-serv_no.

    APPEND gs_data TO gt_data.

  ENDLOOP.

  SORT gt_data DESCENDING BY item loc serv_no packno  extrow.

  DELETE ADJACENT DUPLICATES FROM gt_data COMPARING item serv_no loc.

  SORT gt_data BY item loc.
  " Ouput error message if the data is initial.
  IF gt_data IS INITIAL.

    MESSAGE 'No Data Available' TYPE 'S' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form BUILD_FIELD_CATALOG
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_field_catalog .

  DATA: ls_fcat TYPE slis_fieldcat_alv.

  REFRESH: gt_fcat.

  CLEAR ls_fcat.
  ls_fcat-tabname   = 'GT_DATA'.
  ls_fcat-fieldname = 'ITEM'.
  ls_fcat-key       = 'X'.
  ls_fcat-seltext_m = 'Item No.'.
  ls_fcat-emphasize = 'C411'.
  ls_fcat-just      = 'L'.
  APPEND ls_fcat TO gt_fcat.

  CLEAR ls_fcat.
  ls_fcat-tabname   = 'GT_DATA'.
  ls_fcat-fieldname = 'ITEM_DESC'.
  ls_fcat-seltext_m = 'Item Desc'.
  ls_fcat-just      = 'L'.
  APPEND ls_fcat TO gt_fcat.


  CLEAR ls_fcat.
  ls_fcat-tabname   = 'GT_DATA'.
  ls_fcat-fieldname = 'MENGE'.
  ls_fcat-seltext_m = 'Item Quan.'.
  ls_fcat-just      = 'L'.
  APPEND ls_fcat TO gt_fcat.

  CLEAR ls_fcat.
  ls_fcat-tabname   = 'GT_DATA'.
  ls_fcat-fieldname = 'LOC'.
  ls_fcat-seltext_m = 'Location'.
  ls_fcat-seltext_l = 'Location'.
  ls_fcat-just      = 'L'.
  APPEND ls_fcat TO gt_fcat.

  CLEAR ls_fcat.
  ls_fcat-tabname   = 'GT_DATA'.
  ls_fcat-fieldname = 'SERV_NO'.
  ls_fcat-seltext_m = 'Serv. No.'.
  ls_fcat-seltext_l = 'Service No.'.
  ls_fcat-ddictxt   = 'L'.
  ls_fcat-just      = 'L'.
  APPEND ls_fcat TO gt_fcat.

  CLEAR ls_fcat.
  ls_fcat-tabname   = 'GT_DATA'.
  ls_fcat-fieldname = 'SERV_DESC'.
  ls_fcat-seltext_m = 'Serv. Desc.'.
  ls_fcat-seltext_l = 'Service Desc.'.
  ls_fcat-ddictxt   = 'L'.
  ls_fcat-just      = 'L'.
  APPEND ls_fcat TO gt_fcat.

  CLEAR ls_fcat.
  ls_fcat-tabname   = 'GT_DATA'.
  ls_fcat-fieldname = 'Q_TOTAL'.
  ls_fcat-seltext_m = 'Q Total'.
  ls_fcat-seltext_l = 'Q Total'.
  ls_fcat-ddictxt   = 'L'.
  ls_fcat-just      = 'L'.
  APPEND ls_fcat TO gt_fcat.

  CLEAR ls_fcat.
  ls_fcat-tabname   = 'GT_DATA'.
  ls_fcat-fieldname = 'P_TOTAL'.
  ls_fcat-seltext_m = 'P Total'.
  ls_fcat-seltext_l = 'P Total'.
  ls_fcat-ddictxt   = 'L'.
  ls_fcat-just      = 'L'.
  APPEND ls_fcat TO gt_fcat.

  CLEAR ls_fcat.
  ls_fcat-tabname   = 'GT_DATA'.
  ls_fcat-fieldname = 'USERF2_TXT'.
  ls_fcat-seltext_m = 'Measurement'.
  ls_fcat-seltext_l = 'Measurement'.
  ls_fcat-ddictxt   = 'L'.
  ls_fcat-just      = 'L'.
  APPEND ls_fcat TO gt_fcat.


  CLEAR ls_fcat.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_GRID
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_alv_grid .

  alv_layout-colwidth_optimize = 'X'.
  is_variant-report            = sy-repid.

* Display ALV Grid
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = gt_fcat
      i_grid_title       = 'Service Porgress Track Report'
      is_layout          = alv_layout
      is_variant         = is_variant
      i_save             = 'X'
    TABLES
      t_outtab           = gt_data
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

ENDFORM.
