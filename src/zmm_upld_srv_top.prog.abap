*&----------------------------- ----------------------------------------*
*&  Include           ZMM_UPLD_SRV_TOP
*&---------------------------------------------------------------------*
TYPES : BEGIN OF record ,
  ebeln       TYPE ebeln ,
  ebelp       TYPE ebelp ,
  srvpos      TYPE ASNUM ,
  USERF1_NUM  TYPE USERF1_NUM ,
  USERF2_NUM  TYPE USERF2_NUM ,
  END OF record .

DATA : IT_RECORD    TYPE TABLE OF record ,
       WA_RECORD    LIKE LINE OF  IT_RECORD ,
       FILE_NAME    TYPE          string,
       srv          TYPE          n LENGTH 18 .
