*&---------------------------------------------------------------------*
*& Include          ZSES_READ_FROM_MEM
*&---------------------------------------------------------------------*
IF srv_esll-srvpos IS NOT INITIAL.
  IF sy-tcode = 'ML81N' .
    " READ ALL SERVICES OF THE CURRENT ENTRY SHEET
    tab_name = '(SAPLMLSP)IX_ESLL[]'.
    ASSIGN (tab_name) TO <fs_esll>.
    IF sy-subrc = 0 .
      ix_esll[] = <fs_esll>.
    ENDIF.
    " read the cuurent entry sheet data
    tab_name = '(SAPLMLSR)ESSR'.
    ASSIGN (tab_name) TO <fs_essr>.
    IF sy-subrc = 0 .
      wa_essr = <fs_essr>.
    ENDIF.
  ENDIF.
