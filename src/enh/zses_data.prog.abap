*&---------------------------------------------------------------------*
*& Include          ZSES_DATA
*&---------------------------------------------------------------------*
DATA : it_srv      TYPE TABLE OF esll,
       lt_srv      LIKE it_srv,
       lt_srv1     LIKE it_srv,
       wa_srv      LIKE LINE OF it_srv,
       ix_esll     TYPE TABLE OF msupdap,
*       it_esll      TYPE TABLE OF msupdap ,
       wa_esll     LIKE LINE OF ix_esll,
       last_srv    LIKE wa_srv,
       it_sheet    TYPE TABLE OF essr,
       it_sheet1   LIKE it_sheet,
       wa_sheet    LIKE LINE OF it_sheet,
       wa_essr     TYPE essr,
       tab_name    TYPE string,
       userf1_num  TYPE userf1_num,
       userf2_num  TYPE userf2_num,
       it_srv_upld TYPE TABLE OF zmm_srv_upld,
       wa_srv_upld LIKE LINE OF it_srv_upld,
       menge       TYPE esll-menge,
       diff        TYPE esll-menge,
       qty_tot     LIKE srv_esll-frmval1,
       qty_hasr    LIKE srv_esll-frmval1, " الحصر
       lv_qty      TYPE p LENGTH 10 DECIMALS 4,
       lv_loc      TYPE char18,
       lv_space    TYPE c.



FIELD-SYMBOLS : <fs_esll> TYPE ANY TABLE,
                <fs_essr> TYPE essr.
