*&---------------------------------------------------------------------*
*& Report  ZMM_LIT_SERVICE_CONTRACT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT ZMM_LIT_SERVICE_CONTRACT.

TABLES: ekko , ekpo.


DATA: fm_name         TYPE rs38l_fnam,      " CHAR 30 0 Name of Function Module
      fp_docparams      TYPE sfpdocparams,    " Structure  SFPDOCPARAMS Short Description  Form Parameters for Form Processing
      fp_outputparams   TYPE sfpoutputparams. " Structure  SFPOUTPUTPARAMS Short Description  Form Processing Output Parameter

fp_outputparams-nodialog = 'X'.
fp_outputparams-device = 'PRINTER'.
fp_outputparams-preview = 'X'.
fp_outputparams-dest = 'LP01'.
fp_outputparams-reqimm = 'X'.



data: POnum type ekko-ebeln,
      buld_no type ekpo-idnlf,
      contractor type ekko-lifnr,
      st_loc_desc type t001l-lgobe,
      vendor_name type lfa1-name1,
      vendor_address type lfa1-STRAS,
      address type char200,
      count type i ,
      Contract type t161t-batxt,
      total type ZCURR_E,
      street type char40,
      house type char40.


data: it_ekko type TABLE OF ekko,
*      wa_ekpoh type ekko,
      wa_ekpoh type ekpo,
      it_ekpoh type TABLE OF ekpo,
      wa_ekko type ekko,
      wa_storloc type t001l,
      wa_vendor type lfa1,
      it_eslh type STANDARD TABLE OF eslh,
      wa_eslh type eslh,
      it_esll type STANDARD TABLE OF esll,
      wa_esll type esll,
      it_contract_serv type TABLE OF ZCONTRACT_SERVICE,
      it_contract_serv_2 TYPE TABLE OF ZCONTRACT_SERVICE,
      it_temp TYPE TABLE OF ZCONTRACT_SERVICE,
      wa_temp type zcontract_service,
      wa_contract_serv_2 type  ZCONTRACT_SERVICE,
      it_stxh type STANDARD TABLE OF stxh,
      wa_stxh type stxh,
      wa_contract_serv type  ZCONTRACT_SERVICE,
      it_po_type type TABLE OF t161t,
      wa_PO_type type t161t,
      check type matkl,
      SUBTO TYPE zcurr_e,
      contract_name type ekko-description,
      it_mat_desc type TABLE OF t023,
      wa_mat_desc type t023t,
      RLWRT type RLWRT.

data:
          TNAME   LIKE STXH-TDNAME,
          LTEXT   TYPE zltext_tt,
*          LTEXT_TP type  ZLTEXT_TT,
*          wa_TP LIKE LINE OF LTEXT_TP,
          OBJNR   LIKE STXH-TDNAME,
          PO_TXT  TYPE C LENGTH 2000.
data:
          TNAME2   LIKE STXH-TDNAME,
          LTEXT2   TYPE TABLE OF tline WITH HEADER LINE,
          LTEXT_TP type  ZLTEXT_TT,
          wa_TP LIKE LINE OF LTEXT_TP,
          OBJNR2   LIKE STXH-TDNAME,
          PO_TXT2  TYPE C LENGTH 2000.

PARAMETERS : p_ebeln TYPE ekko-ebeln .
select-OPTIONS : p_ebelp for ekpo-ebelp.


select * from ekko INNER JOIN ekpo  on ekko~ebeln = ekpo~ebeln
into CORRESPONDING FIELDS OF TABLE it_temp
  where ekko~ebeln eq p_ebeln and ekpo~ebelp in p_ebelp .


READ TABLE it_temp INTO wa_temp INDEX 1 .

  if
*  OR wa_temp-BSART = 'ZMEC' OR
*    wa_temp-BSART = 'ZSRV' OR wa_temp-BSART = 'MK' OR wa_temp-BSART = 'WK' OR wa_temp-BSART = 'ZPSV'.
 wa_temp-BSART = 'ZSSO' OR wa_temp-BSART =  'ZSER' OR wa_temp-BSART = 'ZSCN'  .




ponum = wa_temp-ebeln.
tname = wa_temp-ebeln.
contractor = wa_temp-lifnr.
contract = wa_temp-bsart.
buld_no = wa_temp-BEDNR.



*READ TABLE L_DOC-XEKKO INTO wa_ekkoh INDEX 1.

*loop at L_DOC-XEKPO into wa_ekpoh.
**  wa_ekpoh-netpr = L_DOC-XEKPO-netpr.
*  ENDLOOP.


SELECT SINGLE LGOBE FROM T001L INTO st_loc_desc
  WHERE LGORT = wa_temp-LGORT.

*  st_loc_desc = wa_storloc-LGOBE.

SELECT SINGLE name1  FROM lfa1 INTO vendor_name
  WHERE lifnr = wa_temp-lifnr.
*      vendor_name = wa_vendor-name1.
*      vendor_address = wa_vendor-stras.
SELECT SINGLE stras  FROM lfa1 INTO vendor_address
  WHERE LIFNR = wa_temp-LIFNR.

  select single batxt from t161t into contract
    where SPRAS = 'E' and bsart =  wa_temp-bsart .

select single street  from adrc
  into street
  where ADDRNUMBER = wa_temp-ADRN2.

select single HOUSE_NUM1  from adrc
  into house
  where ADDRNUMBER = wa_temp-ADRN2.

  CONCATENATE street house into address SEPARATED BY '/' .

  SELECT *
    from eslh
    into TABLE it_eslh
    FOR ALL ENTRIES IN it_temp
    where ebeln eq it_temp-ebeln AND ebelp eq it_temp-ebelp
      .

  SELECT *
    FROM esll
    INTO TABLE it_esll
    FOR ALL ENTRIES IN it_eslh
    WHERE packno eq it_eslh-packno
    and package ne 'X'.



if sy-UNAME = 'B.HODHOD'.
  BREAK-POINT.
  endif.

loop at it_esll into wa_esll.
*  loop at wa_temp-ebelp .
*    IF sy-subrc = 4.



wa_contract_serv-matkl = wa_esll-matkl.
wa_contract_serv-SRVPOS = wa_esll-SRVPOS.

tname2 = wa_contract_serv-SRVPOS.
*CONCATENATE '0000000000' tname2 INTO tname2.
*if po_txt is INITIAL .
*LOOP AT it_stxh INTO wa_stxh.


CALL FUNCTION 'READ_TEXT'
  EXPORTING
*   CLIENT                        = SY-MANDT
    ID                            =  'LTXT'
    LANGUAGE                      =  'E'
    NAME                          = tname2
    OBJECT                        =  'ASMD'
*   ARCHIVE_HANDLE                = 0
*   LOCAL_CAT                     = ' '
* IMPORTING
*   HEADER                        =
*   OLD_LINE_COUNTER              =
  TABLES
    LINES                         = ltext2
 EXCEPTIONS
   ID                            = 1
   LANGUAGE                      = 2
   NAME                          = 3
   NOT_FOUND                     = 4
   OBJECT                        = 5
   REFERENCE_CHECK               = 6
   WRONG_ACCESS_TO_ARCHIVE       = 7
   OTHERS                        = 8
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.
*ENDLOOP.
  loop at ltext2.
    if po_txt is INITIAL .
      po_txt = ltext2-tdline .
    else.
      CONCATENATE po_txt ltext2-tdline
      into po_txt SEPARATED BY space .
    endif.

 endloop.
  refresh ltext2 .
  clear: ltext2.
*  endif.><

wa_contract_serv-KTEXT1 = po_txt.
wa_contract_serv-tbtwr = wa_esll-tbtwr.
wa_contract_serv-MEINS = wa_esll-MEINS.
WA_CONTRACT_SERV-MENGE = WA_ESLL-MENGE.
wa_contract_serv-peinh = wa_esll-PEINH.

CALL FUNCTION 'ZCALC_SERV_CONT'
 EXPORTING
   ITAB          = wa_contract_serv
 IMPORTING
   SUBTO         =  SUBTO
          .

wa_contract_serv-netpr = SUBTO . " wa_esll-MENGE * wa_esll-extsrvno.
*DIVIDE wa_contract_serv-netpr BY 10.
WA_CONTRACT_SERV-SUBTO = WA_CONTRACT_SERV-SUBTO + WA_CONTRACT_SERV-NETPR  .
*    RLWRT = RLWRT + wa_contract_serv-subto.

  select wgbez from t023t INTO wa_mat_desc-wgbez where matkl = wa_contract_serv-matkl.
    wa_contract_serv-mat_desc = wa_mat_desc-wgbez.
*    MODIFY it_contract_serv from wa_contract_serv-mat_desc .
  ENDSELECT.

*if sy-UNAME = 'B.HODHOD'.
*  BREAK-POINT.
*  endif.


append wa_contract_serv to it_contract_serv.

clear: wa_contract_serv-KTEXT1, po_txt  .

if sy-UNAME = 'B.HODHOD'.
  BREAK-POINT.
  endif.



ENDLOOP.

clear: wa_contract_serv-subto .

*if sy-uname
*BREAK-POINT .

SORT it_contract_serv BY matkl.

MOVE-CORRESPONDING it_contract_serv to it_contract_serv_2.
delete ADJACENT DUPLICATES FROM it_contract_serv_2 COMPARING matkl.

clear wa_contract_serv-subto.


loop at it_contract_serv_2 into wa_contract_serv_2.
CLEAR: SUBTO .
  loop at it_contract_serv INTO wa_contract_serv WHERE matkl = wa_contract_serv_2-matkl.
    ADD wa_contract_serv-NETPR TO SUBTO .
  ENDLOOP .


  CLEAR: wa_contract_serv-SUBTO  .
  wa_contract_serv_2-NETPR = SUBTO .

 "   if wa_contract_serv_2-matkl = wa_contract_serv-matkl.
***      CALL FUNCTION 'ZCALC_SERV_CONT'
*** EXPORTING
***   ITAB          = wa_contract_serv
*** IMPORTING
***   SUBTO         =  SUBTO
          .
    "  wa_contract_serv-netpr = SUBTO . " wa_esll-MENGE * wa_esll-extsrvno.
    "ENDIF.

    MODIFY it_contract_serv_2 FROM wa_contract_serv_2.
*    total = total + wa_contract_serv-subto.
*    if sy-uname = 'B.HODHOD'.
*      BREAK-POINT.
*      ENDIF.
**    clear wa_contract_serv-subto.
**    ENDLOOP.
    endloop.

    loop at it_contract_serv_2 into wa_contract_serv_2.

  loop at it_contract_serv INTO wa_contract_serv WHERE matkl = wa_contract_serv_2-matkl.
      CLEAR wa_contract_serv-SUBTO .
     wa_contract_serv-SUBTO = wa_contract_serv_2-NETPR  .
   " add wa_contract_serv-NETPR to rlwrt.
     MODIFY it_contract_serv FROM wa_contract_serv.
  ENDLOOP .
  ENDLOOP .

    loop at it_contract_serv INTO wa_contract_serv ."1'WHERE matkl = wa_contract_serv_2-matkl.


    add wa_contract_serv-NETPR to rlwrt.

  ENDLOOP .

   " endloop.

*    LOOP AT it_contract_serv_2 into wa_contract_serv_2.

*    ENDLOOP.


*RLWRT = wa_temp-RLWRT.

if sy-UNAME = 'B.HODHOD'.

  endif.

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
*     CLIENT                        = SY-MANDT
      ID                            = 'F01'
      LANGUAGE                      = SY-LANGU
      NAME                          = tname
      OBJECT                        = 'EKKO'
*     ARCHIVE_HANDLE                = 0
*     LOCAL_CAT                     = ' '
*   IMPORTING
*     HEADER                        =
*     OLD_LINE_COUNTER              =
    TABLES
      LINES                         = ltext
   EXCEPTIONS
     ID                            = 1
     LANGUAGE                      = 2
     NAME                          = 3
     NOT_FOUND                     = 4
     OBJECT                        = 5
     REFERENCE_CHECK               = 6
     WRONG_ACCESS_TO_ARCHIVE       = 7
     OTHERS                        = 8
            .


CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'           "& Form Processing Generation
  EXPORTING
    i_name     = 'ZSERVICE_CONTRACT_FORM'
  IMPORTING
    e_funcname = fm_name.
IF sy-subrc <> 0.
*  <error handling>
ENDIF.


CALL FUNCTION 'FP_JOB_OPEN'                   "& Form Processing: Call Form
  CHANGING
    ie_outputparams = fp_outputparams
  EXCEPTIONS
    cancel          = 1
    usage_error     = 2
    system_error    = 3
    internal_error  = 4
    OTHERS          = 5
    .
IF sy-subrc <> 0.
*            <error handling>
ELSE.
ENDIF.

*&---- Get the name of the generated function module


CALL FUNCTION fm_name
  EXPORTING
*   /1BCDWB/DOCPARAMS        =
    LTEXT                    = ltext
    CONTRACT                 = Contract
    ADDRESS                  = Address
    VENDOR_ADDRESS           = Vendor_Address
    VENDOR_NAME              = Vendor_name
    ST_LOC_DESC              = St_LOC_DESC
    CONTRACTOR               = Contractor
    BULD_NO                  = Buld_NO
    PONUM                     = PONUM
    ITAB                     = it_contract_serv
    ITAB2                    = it_contract_serv_2
    TOTAL                    = total
    RLWRT                    = rlwrt
* IMPORTING
*   /1BCDWB/FORMOUTPUT       =
* EXCEPTIONS
*   USAGE_ERROR              = 1
*   SYSTEM_ERROR             = 2
*   INTERNAL_ERROR           = 3
*   OTHERS                   = 4
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.

CALL FUNCTION 'FP_JOB_CLOSE'
" IMPORTING
" E_RESULT             = result
  EXCEPTIONS
    usage_error    = 1
    system_error   = 2
    internal_error = 3
    OTHERS         = 4.

IF sy-subrc <> 0.

endif.
  ".
*            <error handling>
endif.
