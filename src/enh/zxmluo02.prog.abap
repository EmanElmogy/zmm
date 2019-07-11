*----------------------------------------------------------------------*
***INCLUDE ZXMLUO02.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module MODIFY_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE MODIFY_SCREEN OUTPUT.

  LOOP AT SCREEN.
    IF screen-name = 'CI_ESLLDB-ZZLOCATION' AND gv_edit = ' '.
      screen-input = 0.
    ELSEIF screen-name = 'CI_ESLLDB-ZZLOCATION' AND gv_edit = 'X'.
      screen-input = 1.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.

ENDMODULE.
