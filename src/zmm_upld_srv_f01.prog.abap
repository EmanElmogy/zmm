*----------------------------------------------------------------------*
***INCLUDE ZMM_UPLD_SRV_F01.
*------------------------------ ----------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  FILENAME_GET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FILENAME_GET .

  DATA: filerc          TYPE i,
        filename_tab    TYPE filetable,
        filename        TYPE file_table,
        fileaction      TYPE i,
        window_title    TYPE string,
        my_file_filter  TYPE string.

  window_title = text-005.

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
    MOVE filename-filename TO P_FILE.
  ENDIF.


ENDFORM.                    " FILENAME_GET
*&---------------------------------------------------------------------*
*&      Form  READ_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM READ_FILE .
  file_name = p_file.

  " set file data on internal table.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = file_name
      has_field_separator     = 'X'
    TABLES
      data_tab                = it_record
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.
**********************************************************************
**********************************************************************

ENDFORM.                    " READ_FILE
*&---------------------------------------------------------------------*
*&      Form  UPLOAD_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM UPLOAD_FILE .
  data : it_upld_data TYPE TABLE OF zmm_srv_upld ,
         wa_upld_data LIKE LINE OF it_upld_data .

  LOOP AT it_record INTO wa_record.
    MOVE-CORRESPONDING wa_record to wa_upld_data .
    srv = wa_upld_data-SRVPOS.
    wa_upld_data-SRVPOS = srv .
    APPEND wa_upld_data to it_upld_data .
    CLEAR wa_upld_data .
  ENDLOOP.

  DELETE it_record WHERE ebeln IS INITIAL .
  MODIFY zmm_srv_upld FROM TABLE it_upld_data.

ENDFORM.                    " UPLOAD_FILE
