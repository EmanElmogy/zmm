*----------------------------------------------------------------------*
***INCLUDE ZXMLUI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXPORT_LOCATION_TO_MEMID  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE export_location_to_memid INPUT.
  DATA: lv_space TYPE c.

  IF ci_eslldb-zzlocation = ''.
    lv_space = 'X'.
    EXPORT lv_space TO MEMORY ID 'INIT'.
  ELSE.
    lv_space = ''.
  ENDIF.

  EXPORT ci_eslldb-zzlocation TO MEMORY ID 'LOC'.


ENDMODULE.
