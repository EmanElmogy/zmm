*&---------------------------------------------------------------------*
*& Include          ZSERVICE_PRICE
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Include          ZSERVICE_PRICE
*&---------------------------------------------------------------------*
IF wa_essr-frgzu IS INITIAL AND sy-tcode = 'ML81N'.
  IF srv_esll-persext IS NOT INITIAL  .
    SHIFT srv_esll-persext LEFT DELETING LEADING space .
    MOVE srv_esll-persext TO  srv_esll-tbtwr .
  ENDIF.
ENDIF.
