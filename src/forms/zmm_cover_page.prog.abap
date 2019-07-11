*&---------------------------------------------------------------------*
*& Report  ZMM_COVER_PAGE
*&
*& Cover Page For PO's  Created BY : Motaz Naguib
*&
*&
*&---------------------------------------------------------------------*

report zmm_cover_page.


tables: ekko , ekpo .


types: begin of ty_str,
lgort type lgort_d,
lifnr type lifnr ,
ebeln type ebeln ,
idnlf type idnlf ,
rlwrt type rlwrt ,
adrn2 type adrn2 ,
BEDNR type BEDNR ,
end of  ty_str .


data: it_tmp type standard table of ty_str  ,
      wa_tmp like line of it_tmp .
data: wa    type zgs_cover_str ,
      itab  type table of zgs_cover_str .

data: wa_head type zgs_cover_head_str .

data :  total type netpr  ,
        street type char200 ,
        house type char200 ,
        vendor type lifnr ,
        storage type lgort.


selection-screen begin of block b1 with frame.
select-options : s_po    for ekko-ebeln.
select-options : s_lifnr for ekko-lifnr no intervals.
select-options : s_lgort for ekpo-lgort no intervals.
selection-screen end of block  b1.


clear: vendor, storage.

select
  ekko~ebeln  " PO
  ekpo~idnlf  " VMaterial
  ekko~rlwrt  " Total Price PO
  ekpo~lgort " ST_CODE
  ekko~lifnr  " Name
  ekpo~adrn2 " ADDRESS
  ekpo~bednr    " building no
  from ekko inner join ekpo on ekko~ebeln eq ekpo~ebeln
  into corresponding fields of table  it_tmp
  where ekko~ebeln in s_po
    and ekpo~lgort in s_lgort
    and ekko~lifnr in s_lifnr
    and ekko~bsart in ('ZSCN',
'ZSER',
'ZSSO'
)
    and ekko~loekz ne 'X'
    and ekko~frgrl ne 'X'
    and ( ekko~frgke eq 'A' or ekko~frgke eq 'R' )
  .

if it_tmp[] is initial .
  message 'Enter Valid Data' type 'S' display like 'E'.
  leave list-processing.
endif.

delete adjacent duplicates from it_tmp comparing ebeln.
read table it_tmp into wa_tmp index 1.
vendor  = wa_tmp-lifnr .
storage = wa_tmp-lgort .
clear wa_tmp.

loop at it_tmp into wa_tmp.
  if vendor <> wa_tmp-lifnr.
    message 'Please Enter Purchasing Documents for same vendor ' type 'S' display like 'E'.
    leave list-processing.
  endif.

  if storage <> wa_tmp-lgort.
    message 'Please Enter Purchasing Documents for same Sorage location ' type 'S' display like 'E'.
    leave list-processing.
  endif.
  clear wa_tmp.
endloop.


loop at it_tmp into wa_tmp.
  wa-po_no       = wa_tmp-ebeln .
  wa-building_no = wa_tmp-bednr .
  wa-total_val   = wa_tmp-rlwrt .

  select single lgobe from t001l into  wa_head-prg_name where lgort = wa_tmp-lgort  .
  select single name1 from lfa1 into   wa_head-vendor  where lifnr = wa_tmp-lifnr   .

  select single street  from adrc
  into street
  where addrnumber = wa_tmp-adrn2.

  select single house_num1  from adrc
    into house
    where addrnumber = wa_tmp-adrn2.

  concatenate street house into wa_head-prg_ads separated by '/' .
  add wa_tmp-rlwrt to total .

  append wa to itab.
  clear: wa_tmp , wa .
endloop.




data: fm_name         type rs38l_fnam,      " CHAR 30 0 Name of Function Module
      fp_docparams      type sfpdocparams,    " Structure  SFPDOCPARAMS Short Description  Form Parameters for Form Processing
      fp_outputparams   type sfpoutputparams. " Structure  SFPOUTPUTPARAMS Short Description  Form Processing Output Parameter

fp_outputparams-nodialog = 'X'.
fp_outputparams-device = 'PRINTER'.
fp_outputparams-preview = 'X'.
fp_outputparams-dest = 'LP01'.
fp_outputparams-reqimm = 'X'.


*&---- Get the name of the generated function module
call function 'FP_FUNCTION_MODULE_NAME'           "& Form Processing Generation
  exporting
    i_name     = 'ZMM_COVER_PAGE_FM'
  importing
    e_funcname = fm_name.


call function 'FP_JOB_OPEN'                   "& Form Processing: Call Form
  changing
    ie_outputparams = fp_outputparams
  exceptions
    cancel          = 1
    usage_error     = 2
    system_error    = 3
    internal_error  = 4
    others          = 5.

call function fm_name
  exporting
*   /1BCDWB/DOCPARAMS        =
    total          = total
    wa_head        = wa_head
    itab           = itab
  exceptions
    usage_error    = 1
    system_error   = 2
    internal_error = 3.
.

if sy-subrc <> 0.
* Implement suitable error handling here
endif.


call function 'FP_JOB_CLOSE'
" IMPORTING
" E_RESULT             = result
  exceptions
    usage_error    = 1
    system_error   = 2
    internal_error = 3
    others         = 4.
