*&---------------------------------------------------------------------*
*& Include          ZMM_SERV_PROGRESS_TRACKTOP
*&---------------------------------------------------------------------*

TYPES: BEGIN OF gty_data,

         extrow     TYPE esll-extrow,
         packno     TYPE esll-packno,
         item       TYPE ekpo-ebelp,
         item_desc  TYPE ekpo-txz01,
         menge      TYPE ekpo-menge,
         loc        TYPE esll-extsrvno,
         serv_no    TYPE esll-srvpos,
         serv_desc  TYPE esll-ktext1,
         q_total    TYPE esll-userf2_num,
         p_total    TYPE esll-userf2_num,
         userf2_txt TYPE esll-userf2_txt,

       END OF gty_data.

TYPES: BEGIN OF gty_item_desc,

         ebeln TYPE ekpo-ebeln,
         ebelp TYPE ekpo-ebelp,
         txz01 TYPE ekpo-txz01,

       END OF gty_item_desc.

TYPES: BEGIN OF gty_quan,

         packno     TYPE esll-packno,
         menge      TYPE esll-menge,
         userf2_txt TYPE esll-userf2_txt,
         srvpos     TYPE esll-srvpos,
         ebelp      TYPE ekpo-ebelp,

       END OF gty_quan.

DATA: gv_ebeln TYPE ekko-ebeln,
      gv_ebelp TYPE ekpo-ebelp,
      gv_srv   TYPE esll-srvpos.

DATA: gt_item_desc TYPE STANDARD TABLE OF gty_item_desc,
      gt_data      TYPE STANDARD TABLE OF gty_data,
      gt_essr      TYPE STANDARD TABLE OF essr,
      gt_esll      TYPE STANDARD TABLE OF esll,
      gt_quan      TYPE STANDARD TABLE OF gty_quan,
      gt_fcat      TYPE slis_t_fieldcat_alv,
      gs_data      TYPE gty_data,
      alv_layout   TYPE slis_layout_alv,
      is_variant   LIKE disvariant.



SELECTION-SCREEN BEGIN OF BLOCK blc_1 WITH FRAME TITLE TEXT-001.

SELECT-OPTIONS: so_po   FOR gv_ebeln OBLIGATORY NO INTERVALS NO-EXTENSION,
                so_item FOR gv_ebelp NO INTERVALS,
                so_srv  FOR gv_srv .

SELECTION-SCREEN END OF BLOCK blc_1.
