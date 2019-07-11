*&---------------------------------------------------------------------*
*& Report ZMM_UPLOAD_MRP_AREAS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmm_upload_mrp_areas.
TYPE-POOLS: slis.
DATA: tfile     LIKE          rlgrap-filename                     .
DATA: xstatus   LIKE TABLE OF bapi_re_status_datc WITH HEADER LINE.
DATA: return    TYPE TABLE OF bapiret2            WITH HEADER LINE.
DATA: t_message TYPE          char200                             .
DATA: index     TYPE          string                              .
*ALV data declarations
DATA: fieldcatalog TYPE slis_t_fieldcat_alv WITH HEADER LINE,
      gd_tab_group TYPE slis_t_sp_group_alv,
      gd_layout    TYPE slis_layout_alv,
      gd_repid     LIKE sy-repid.

" ********************************************************************** **********************************************************************
DATA: BEGIN OF records OCCURS 0,
        material       TYPE  matnr,
        mrp_area1      TYPE  mdma-berid,
        mrp_area2      TYPE  mdma-berid,
        mrp_area3      LIKE  mdma-berid,
        mrp_area4      LIKE  mdma-berid,
        mrp_area5      LIKE  mdma-berid,
        mrp_area6      LIKE  mdma-berid,
        mrp_area7      LIKE  mdma-berid,
        mrp_area8      LIKE  mdma-berid,
        mrp_area9      LIKE  mdma-berid,
        mrp_area10     LIKE  mdma-berid,
        mrp_grp        TYPE  char4,
        mrp_type       TYPE  dismm,
        mrp_controller TYPE char3,
        lot_size       TYPE char2,

      END OF records.
DATA: BEGIN   OF     log OCCURS 0,
        matnr    TYPE  matnr,
        mrp_area LIKE mdma-berid,
        message  TYPE   char200,
      END OF log .
SELECTION-SCREEN BEGIN OF BLOCK b WITH FRAME TITLE TEXT-000.
PARAMETERS : p_wears LIKE  mdma-werks OBLIGATORY .
PARAMETERS : dataset(132) OBLIGATORY.
PARAMETERS : edit AS CHECKBOX .
SELECTION-SCREEN END OF BLOCK b.

" ********************************************************************** **********************************************************************

AT SELECTION-SCREEN ON VALUE-REQUEST FOR dataset.
  PERFORM filename_get.

END-OF-SELECTION.

  tfile = dataset.
  DATA : it_type   TYPE truxs_t_text_data.
*  BREAK msayed .
  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    = ''
      i_line_header        = 'X'
      i_tab_raw_data       = it_type
      i_filename           = tfile
    TABLES
      i_tab_converted_data = records[]
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
*  BREAK msayed .
  LOOP AT records.
    IF records-mrp_area1 IS NOT INITIAL.
      PERFORM add_mrp_area
        USING records-material records-mrp_area1 records-mrp_grp records-mrp_controller records-mrp_type records-lot_size
        CHANGING log.
    ENDIF.
    IF records-mrp_area2 IS NOT INITIAL.
      PERFORM add_mrp_area
  USING records-material records-mrp_area2 records-mrp_grp records-mrp_controller records-mrp_type records-lot_size
  CHANGING log.
    ENDIF.
    IF records-mrp_area3 IS NOT INITIAL.
      PERFORM add_mrp_area
  USING records-material records-mrp_area3 records-mrp_grp records-mrp_controller records-mrp_type records-lot_size
  CHANGING log.
    ENDIF.
    IF records-mrp_area4 IS NOT INITIAL.
      PERFORM add_mrp_area
  USING records-material records-mrp_area4 records-mrp_grp records-mrp_controller records-mrp_type records-lot_size
  CHANGING log.
    ENDIF.
    IF records-mrp_area5 IS NOT INITIAL.
      PERFORM add_mrp_area
  USING records-material records-mrp_area5 records-mrp_grp records-mrp_controller records-mrp_type records-lot_size
  CHANGING log.
    ENDIF.
    IF records-mrp_area6 IS NOT INITIAL.
      PERFORM add_mrp_area
  USING records-material records-mrp_area6 records-mrp_grp records-mrp_controller records-mrp_type records-lot_size
  CHANGING log.
    ENDIF.
    IF records-mrp_area7 IS NOT INITIAL.
      PERFORM add_mrp_area
  USING records-material records-mrp_area7 records-mrp_grp records-mrp_controller records-mrp_type records-lot_size
  CHANGING log.
    ENDIF.
    IF records-mrp_area8 IS NOT INITIAL.
      PERFORM add_mrp_area
  USING records-material records-mrp_area8 records-mrp_grp records-mrp_controller records-mrp_type records-lot_size
  CHANGING log.
    ENDIF.
    IF records-mrp_area9 IS NOT INITIAL.
      PERFORM add_mrp_area
  USING records-material records-mrp_area9 records-mrp_grp records-mrp_controller records-mrp_type records-lot_size
  CHANGING log.
    ENDIF.
    IF records-mrp_area10 IS NOT INITIAL.
      PERFORM add_mrp_area
  USING records-material records-mrp_area10 records-mrp_grp records-mrp_controller records-mrp_type records-lot_size
  CHANGING log.
    ENDIF.
  ENDLOOP.
  PERFORM build_fieldcatalog.
  PERFORM build_layout.
  PERFORM display_alv_report.



FORM display_alv_report .
  gd_repid = sy-repid.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = gd_repid
*     i_callback_top_of_page   = 'TOP-OF-PAGE'  "see FORM
*     i_callback_user_command = 'USER_COMMAND'
*     i_grid_title       = outtext
      is_layout          = gd_layout
      it_fieldcat        = fieldcatalog[]
*     it_special_groups  = gd_tabgroup
*     IT_EVENTS          = GT_XEVENTS
      i_save             = 'X'
*     is_variant         = z_template
    TABLES
      t_outtab           = log
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
ENDFORM.

FORM build_layout .

  gd_layout-no_input          = 'X'.
  gd_layout-colwidth_optimize = 'X'.
*  gd_layout-totals_text       = 'Totals'(201).
*  gd_layout-totals_only        = 'X'.
*  gd_layout-f2code            = 'DISP'.  "Sets fcode for when double
*                                         "click(press f2)
  gd_layout-zebra             = 'X'.
*  gd_layout-group_change_edit = 'X'.
  gd_layout-header_text       = 'Message Log'.
ENDFORM.

FORM filename_get .
  DATA: filerc         TYPE i,
        filename_tab   TYPE filetable,
        filename       TYPE file_table,
        fileaction     TYPE i,
        window_title   TYPE string,
        my_file_filter TYPE string.

  window_title = TEXT-005.

  CLASS cl_gui_frontend_services DEFINITION LOAD.
*  concatenate cl_gui_frontend_services=>filetype_all
*              into my_file_filter.
  my_file_filter = 'All files(*.*)|*.*'(084).
  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      window_title            = window_title
      file_filter             = my_file_filter
    CHANGING
      file_table              = filename_tab
      rc                      = filerc
      user_action             = fileaction
    EXCEPTIONS
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4.


  IF fileaction EQ cl_gui_frontend_services=>action_ok.
    CHECK NOT filename_tab IS INITIAL.
    READ TABLE filename_tab INTO filename INDEX 1.
    MOVE filename-filename TO dataset.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ADD_MRP_AREA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> RECORDS_MRP_AREA1
*&      <-- LOG
*&---------------------------------------------------------------------*
FORM add_mrp_area  USING    p_records_mrp_material
                            p_records_mrp_area
                            p_records_mrp_grp
                            p_records_mrp_controller
                            p_records_mrp_type
                            p_records_lot_size

                   CHANGING p_log LIKE log.
  DATA : i_selfields    LIKE  sdibe_massfields,
         i_mdma         LIKE  mdma,
         i_dpop         LIKE  dpop,
         e_error_return LIKE  bapireturn1.

  CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
    EXPORTING
      input  = p_records_mrp_material
    IMPORTING
      output = p_records_mrp_material.
  i_selfields-xdismm = 'X' .
  i_selfields-xdisls = 'X' .
  i_selfields-xdispo = 'X' .
  i_selfields-xdisgr = 'X' .
  i_mdma-disgr = p_records_mrp_grp .
  i_mdma-matnr = p_records_mrp_material .
  i_mdma-dismm = p_records_mrp_type .
  i_mdma-werks = p_wears.
  i_mdma-disls = p_records_lot_size .
  i_mdma-dispo = p_records_mrp_controller .
*  BREAK msayed .
  IF edit EQ 'X'.
    CALL FUNCTION 'MD_MRP_LEVEL_CHANGE_DATA'
      EXPORTING
        i_matnr        = p_records_mrp_material
        i_werk         = p_wears
        i_mrp_area     = p_records_mrp_area
        i_berty        = '01'
        i_selfields    = i_selfields
        i_mdma         = i_mdma
        i_dpop         = i_dpop
        i_save_flag    = 'X'
      IMPORTING
        e_error_return = e_error_return.
  ELSE .
    CALL FUNCTION 'MD_MRP_LEVEL_CREATE_DATA'
      EXPORTING
        i_matnr        = p_records_mrp_material
        i_werk         = p_wears
        i_mrp_area     = p_records_mrp_area
        i_selfields    = i_selfields
        i_mdma         = i_mdma
        i_dpop         = i_dpop
        i_save_flag    = 'X'
      IMPORTING
        e_error_return = e_error_return.
  ENDIF.
  CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
    EXPORTING
      input  = p_records_mrp_material
    IMPORTING
      output = p_records_mrp_material.

  IF e_error_return-type EQ ' '.
    p_log-message = 'MRP Area Updated sucessfully ' .
  ELSE .
    p_log-message = 'Error On Update MRP Area ' .
  ENDIF.
  p_log-matnr = p_records_mrp_material .
  p_log-mrp_area = p_records_mrp_area.
  APPEND p_log TO log[] .
  CLEAR : p_log ,e_error_return.
ENDFORM.
FORM build_fieldcatalog .
  fieldcatalog-fieldname   = 'MATNR'.
  fieldcatalog-seltext_m   = 'Material'.
  fieldcatalog-col_pos     = 0.
  fieldcatalog-outputlen   = 40.
*  fieldcatalog-emphasize   = 'X'.
*  fieldcatalog-key         = 'X'.
*  fieldcatalog-do_sum      = 'X'.
*  fieldcatalog-no_zero     = 'X'.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.
  fieldcatalog-fieldname   = 'MRP_AREA'.
  fieldcatalog-seltext_m   = 'MRP Area'.
  fieldcatalog-col_pos     = 0.
  fieldcatalog-outputlen   = 40.
*  fieldcatalog-emphasize   = 'X'.
*  fieldcatalog-key         = 'X'.
*  fieldcatalog-do_sum      = 'X'.
*  fieldcatalog-no_zero     = 'X'.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'MESSAGE'.
  fieldcatalog-seltext_m   = 'Message Log'.
  fieldcatalog-col_pos     = 1.
  fieldcatalog-outputlen   = 200.
  fieldcatalog-emphasize   = 'X'.
*  fieldcatalog-key         = 'X'.
*  fieldcatalog-do_sum      = 'X'.
*  fieldcatalog-no_zero     = 'X'.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.
ENDFORM .
