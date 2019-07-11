FUNCTION ZCALC_SERV_CONT.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(ITAB) TYPE  ZCONTRACT_SERVICE OPTIONAL
*"  EXPORTING
*"     VALUE(SUBTO) TYPE  ZCURR_E
*"----------------------------------------------------------------------

data : wa_cont type zcontract_service.
*BREAK-POINT .
**loop at ITAB into wa_cont.
CLEAR SUBTO .
  SUBTO = itab-TBTWR * itab-MENGE.
**  modify  itab2 FROM wa_cont.
**  ENDLOOP.




ENDFUNCTION.
