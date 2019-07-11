*&---------------------------------------------------------------------*
*& Include          ZR_MM_SERVICE_LTXT_FM
*&---------------------------------------------------------------------*

FORM save_text USING VALUE(asnum)
                     VALUE(ltxt).

CLEAR : header ,ilines[] ,length,len,off,rest.

 CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input         = asnum
   IMPORTING
     output         = asnum
            .

  header-tdobject = 'ASMD'.
  header-tdname   = asnum.            " Make sure it has leading zeroes.
  header-tdid     = 'LTXT'.
  header-tdspras  = sy-langu.

  length  =  strlen( ltxt ).
  len     =  length / 132  + 1.

  break khalaf.

    WHILE off < length.

      MOVE '*' TO ilines-tdformat.

      IF ( length - off ) > 132.
        MOVE  ltxt+off(132) TO ilines-tdline.
        ELSE.
          rest = length - off .
          IF rest > 0.
            MOVE  ltxt+off(rest) TO ilines-tdline.
          ENDIF.

      ENDIF.

      SHIFT ilines-tdline LEFT DELETING LEADING ' '.
      off = off + 132 .

      APPEND ilines.
      CLEAR ilines .
    ENDWHILE.


  CALL FUNCTION 'SAVE_TEXT'
    EXPORTING
      header                = header
      insert                   = ' '
      savemode_direct       = 'X'
    TABLES
      lines                 = ilines
   EXCEPTIONS
     id                    = 1
     language              = 2
     name                  = 3
     object                = 4
     OTHERS                = 5.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.

    CALL FUNCTION 'COMMIT_TEXT'.

    IF sy-subrc = 0.
      WRITE: /'Service' , asnum , 'updated successfully'.
    ENDIF.
  ENDIF.

  ENDFORM .



  FORM update_service.

     MOVE p_fname TO filename.

  CALL FUNCTION 'ZALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                      = filename
      i_begin_col                   = 1
      i_begin_row                   = 2
      i_end_col                     = 5
      i_end_row                     = 10000
    TABLES
      intern                        = it_tab
   EXCEPTIONS
     inconsistent_parameters       = 1
     upload_ole                    = 2
     OTHERS                        = 3
            .
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
         WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


  LOOP AT it_tab INTO wa_tab .

      CASE wa_tab-col.
        WHEN '0001'.
          gs_file-srvpos = wa_tab-value.
        WHEN '0002'.
          gs_file-ltxt = wa_tab-value.
      ENDCASE.

      AT END OF row.

        PERFORM save_text USING gs_file-srvpos gs_file-ltxt.
        CLEAR : gs_file.

      ENDAT.

    ENDLOOP.

    ENDFORM.
