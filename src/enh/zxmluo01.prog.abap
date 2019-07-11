*----------------------------------------------------------------------*
***INCLUDE ZXMLUO01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0399 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0399 OUTPUT.
*  SET PF-STATUS 'xxxxxxxx'.
*  SET TITLEBAR 'xxx'.
  TABLES : ESSR .
  DATA : IT_ESSR TYPE ESSR .

  IMPORT IT_ESSR FROM MEMORY ID 'ZDEP_ID' .
  ESSR-ZLGORT = IT_ESSR-ZLGORT .
  ESSR-ZLGOBE = IT_ESSR-ZLGOBE .
  ESSR-ZBEDNR = IT_ESSR-ZBEDNR .
  "ESSR-ZIDNLF = it_ESSR-ZIDNLF .
  FREE MEMORY ID 'ZDEP_ID' .

ENDMODULE.
