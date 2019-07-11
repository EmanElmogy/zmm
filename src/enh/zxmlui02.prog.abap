*----------------------------------------------------------------------*
***INCLUDE ZXMLUI02.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  SET_LOCATION_VALUE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE set_location_value INPUT.

  DATA: BEGIN OF ix_esll .
      INCLUDE STRUCTURE msupdap.
  DATA:    selkz   LIKE rm11p-selkz.
  DATA: END OF ix_esll.

  DATA: lv_tab_name1 TYPE string.

  DATA: lv_tab_name TYPE string,
        ls_essr     TYPE essr,
        lt_esll     TYPE STANDARD TABLE OF esll,
        lt_essr     TYPE STANDARD TABLE OF essr.

  DATA: lt_values TYPE vrm_values,
        ls_values LIKE LINE OF lt_values.

  FIELD-SYMBOLS : <fs_esll>  TYPE ANY TABLE,
                  <fs_esll1> LIKE ix_esll,
                  <fs_essr>  TYPE essr.

  REFRESH lt_values.

  IF sy-tcode = 'ML81N'.
    lv_tab_name = '(SAPLMLSR)ESSR'.
    ASSIGN (lv_tab_name) TO <fs_essr>.
    IF <fs_essr> IS ASSIGNED .
      ls_essr = <fs_essr>.
    ENDIF.
  ENDIF.

  SELECT packno
    FROM essr
    INTO CORRESPONDING FIELDS OF TABLE lt_essr
    WHERE loekz NE 'X'
    AND   ebeln = ls_essr-ebeln
    AND   ebelp = ls_essr-ebelp.

  IF lt_essr IS NOT INITIAL.
    SELECT s~zzlocation
          FROM esll AS e INNER JOIN esll AS s ON  e~sub_packno = s~packno
          INTO CORRESPONDING FIELDS OF TABLE lt_esll
          FOR ALL ENTRIES IN lt_essr
          WHERE e~packno = lt_essr-packno
          AND   s~srvpos = gs_esll-srvpos
          AND   s~del    <> 'X'.
  ENDIF.

  ls_values-key = ' '.
  APPEND ls_values TO lt_values.

  LOOP AT lt_esll INTO DATA(ls_esll).

    ls_values-key = ls_esll-zzlocation.
    APPEND ls_values TO lt_values.

  ENDLOOP.

  DELETE ADJACENT DUPLICATES FROM lt_values COMPARING key.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = 'CI_ESLLDB-ZZLOCATION'
      values          = lt_values
    EXCEPTIONS
      id_illegal_name = 1
      OTHERS          = 2.

  IF sy-subrc <> 0.

  ENDIF.


*  IF sy-tcode = 'ML81N' .
*    " READ ALL SERVICES OF THE CURRENT ENTRY SHEET
*    lv_tab_name1 = '(SAPLMLSP)IX_ESLL[]'.
*    ASSIGN (lv_tab_name1) TO <fs_esll>.
*    IF sy-subrc = 0 .
*      LOOP AT <fs_esll> ASSIGNING <fs_esll1>.
*        IF <fs_esll1>-extrow = gs_esll-extrow.
*          <fs_esll1>-extsrvno = ci_eslldb-zzlocation.
*        ENDIF.
*      ENDLOOP.
**      lt_esll[] = <fs_esll>.
*    ENDIF.
*  ENDIF.



ENDMODULE.
