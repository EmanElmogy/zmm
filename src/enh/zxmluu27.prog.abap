*&---------------------------------------------------------------------*
*&  Include           ZXMLUU27
*&---------------------------------------------------------------------*

************************************************************************
* OBJECT ID               :
* PROGRAM TITLE           :  Update department ID
* MODULE                  :  MM
* PROGRAM TYPE            :  Enhancement-BADI
* INPUT                   :  ML81N
* OUTPUT                  :  Update Department ID based on PAR/ID
* CREATED BY              :  tayseer hassan abdallah
* CREATION DATE           :  23/8/2014
*-----------------------------------------------------------------------
* DESCRIPTION             :   department ID
************************************************************************
* Modification history:
*-----------------------------------------------------------------------
* DATE      |Owner  |Request  | Description
*-----------------------------------------------------------------------
************************************************************************

DATA : IT_ESSR   TYPE ESSR,
       IT_EKKO   TYPE  EKKO,
       IT_EKPO   TYPE EKPO,
       CI_ESSRDB TYPE CI_ESSRDB.

DATA: FIELD(30) VALUE '(SAPLMLSR)ESSR',
      LGORT     TYPE EKPO-LGORT,
      LGOBE     TYPE T001L-LGOBE.

FIELD-SYMBOLS: <FS_ESSR>  TYPE ESSR,
               <FS_RM11R> TYPE RM11R.

ASSIGN (FIELD) TO <FS_ESSR>.

FIELD = '(SAPLMLSR)RM11R' .
ASSIGN (FIELD) TO <FS_RM11R>.

* Read Storage Location & and Requirement Tracking Number
SELECT SINGLE LGORT BEDNR "IDNLF
  FROM EKPO
  INTO (<FS_ESSR>-ZLGORT , <FS_ESSR>-ZBEDNR) ",<fs_essr>-ZIDNLF)
  WHERE EBELN = <FS_ESSR>-EBELN
  AND EBELP = <FS_ESSR>-EBELP .

* Read Storage Location Desc.
SELECT SINGLE LGOBE
  FROM T001L
  INTO <FS_ESSR>-ZLGOBE
  WHERE LGORT = <FS_ESSR>-ZLGORT .

" STORAGE LOCATION AUTHORITY CHECK
IF SY-TCODE = 'ML81N' AND SY-UCOMM = 'ENTE'."<fs_essr>-frgzu is INITIAL.

  SELECT SINGLE EKPO~LGORT  T001L~LGOBE
    FROM EKPO
    INNER JOIN T001L ON EKPO~LGORT =  T001L~LGORT
    INTO  ( LGORT,LGOBE )
    WHERE EBELN = <FS_RM11R>-BSTNR
    AND EBELP = <FS_RM11R>-BSTPO .

  AUTHORITY-CHECK OBJECT 'ZM_SLOC'
       ID 'ZPROJECT' FIELD LGORT.

  IF SY-SUBRC <> 0.
*      GET STORAGE LOCATION DESCP
    MESSAGE E000(ZMM) WITH LGOBE .
  ENDIF.

ENDIF.

IT_ESSR = <FS_ESSR> .
EXPORT IT_ESSR TO MEMORY ID 'ZDEP_ID' .
EXPORT IT_ESSR-ZLGORT TO MEMORY ID 'ZDATA_ID' .
"export it_essr-ZIDNLF to memory id 'ZDATA_ID_2' .

CALL FUNCTION 'EXIT_SAPLMLSR_010'
  EXPORTING
    I_EKKO = IT_EKKO
    I_EKPO = IT_EKPO
  CHANGING
    C_ESSR = IT_ESSR.
