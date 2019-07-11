*&-------------------------- -------------------------------------------*
*&  Include           ZMM_UPLD_PO_TOP
*&------------------------ ---------------------------------------------*

************************* ************************* **********************
*------------------------ HEADER FIELDS---------------------------------
types : begin of hdr ,
  po_number             type ebeln ,
  doc_type              type esart ,
  vendor                type elifn ,
  purch_org             type ekorg ,
  pur_group             type bkgrp ,
  comp_code             type bukrs ,
  retention_type        type rettp ,
  retention_percentage  type retpz ,
  downpay_type          type me_dptyp ,
  downpay_percent       type me_dppcnt ,
  downpay_duedate       type c length 10,
  doc_date              type c length 10,
  valid_start           type c length 10,
  valid_end             type c length 10,
  end of hdr .
************************************************************************

************************************************************************
*---------------------------ITEM FIELDS---------------------------------
types : begin of item ,
  po_number             type ebeln ,
  po_item               type ebelp ,
  item_cat              type pstyp ,
  acctasscat            type knttp ,
  short_text            type txz01 ,
  plant                 type ewerk ,
  matl_group            type matkl ,
  stge_loc              type lgort_d ,
  vend_mat              type idnlf ,
  delivery_date         type  c length 10,
  limit                 type bsumlimit ,
  no_limit              type nolimit ,
  network               type nplnr ,
  activity              type vornr ,
  end of item .
************************************************************************

************************************************************************
*---------------------------SERVICE FIELDS------------------------------
types : begin of srv ,
  po_number             type ebeln ,
  po_item               type ebelp ,
  po_serv_item          type srv_line_no,
  service               type asnum ,
  network               type nplnr ,
  activity              type vornr ,
  quantity              type mengev ,
  gr_price              type bapigrprice ,
  userf2_txt            type userf2_txt ,
  userf1_txt            type userf1_txt ,
  end of srv .
************************************************************************




"DATA DECLARATION
data : it_hdr           type table of hdr ,
       wa_hdr           like line of it_hdr ,
       it_item          type table of item ,
       wa_item          like line of it_item ,
       it_srv           type table of srv ,
       wa_srv           like line of it_srv ,

       poheader         like  bapimepoheader ,
       poheaderx        like  bapimepoheaderx ,

       poitem           type table of bapimepoitem ,
       wa_poitem        like  line of poitem ,
       poitemx          type table of  bapimepoitemx ,
       wa_poitemx       like line of poitemx ,

       poschedule       type table of  bapimeposchedule ,
       wa_poschedule    like line of poschedule ,
       poschedulex      type table of  bapimeposchedulx ,
       wa_poschedulex   like line of poschedulex ,

       polimits	        type table of	bapiesuhc,
       wa_polimits      like line of polimits,

       pocontractlimits type table of bapiesucc,
       wa_pocontractlimits like line of pocontractlimits,

       posrvaccessvalues type table of bapiesklc,
       wa_posrvaccessvalues like line of posrvaccessvalues,

       poaccount        type table of bapimepoaccount,
       wa_poaccount     like line of  poaccount,

       poaccountx       type table of bapimepoaccountx,
       wa_poaccountx    like line of poaccountx,

       poservices       type table of bapiesllc ,
       wa_poservices    like line of poservices,

       allversions        type table of bapimedcm_allversions,
       wa_allversions     like line of allversions,

       return           type table of bapiret2,
       wa_ret           like line of return.


data: sched_line  type etenr.
data: serial_no   type dzekkn.
data: expheader   like  bapimepoheader.



data: lv_pckg           type packno ,
      lv_sub_pckg       type sub_packno ,
      lv_line_no        type srv_line_no,
      lv_ext_line_no    type extrow ,
      lv_serial_no      type dzekkn.


tables: zmm_upld_po_rep.
data: lt_zmm_upld_po_rep  type table of zmm_upld_po_rep,
      ls_zmm_upld_po_rep  type zmm_upld_po_rep,
      ls_zmm_upld_po_rep2 type zmm_upld_po_rep.

data: lv_day   type c length 2,
      lv_month type c length 2,
      lv_year  type c length 4.
