*&---------------------------------------------------------------------*
*&  Include           ZPROJ_AUTHORIZATION
*&---------------------------------------------------------------------*
DATA : LGOBE TYPE T001L-LGOBE .
 IF wa_essr-FRGRL is NOT INITIAL and sy-tcode = 'ML81N'.
   AUTHORITY-CHECK OBJECT 'ZM_SLOC'
         ID 'ZPROJECT' FIELD WA_ESSR-ZLGORT.
   IF SY-SUBRC <> 0.
*      GET STORAGE LOCATION DESCP
     SELECT SINGLE LGOBE
       FROM T001L
       INTO LGOBE
       WHERE WERKS = '1000'
        AND  LGORT = wa_essr-zlgort .
     MESSAGE e000(zmm) WITH lgobe .
   ENDIF.
 ENDIF.
