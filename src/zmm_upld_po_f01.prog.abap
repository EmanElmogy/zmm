*-----------------------------------v-----------------------------------*
***INCLUDE ZMM_UPLD_PO_F01.
*------------------------ ----------------------------------------------*
*&---------------------------- -----------------------------------------*
*&      Form  FILENAME_GET
*&---------------------- -----------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_P_HDR  text
*----------------------------------------------------------------------*
form filename_get  changing p_filename.

  data: filerc          type i,
        filename_tab    type filetable,
        filename        type file_table,
        fileaction      type i,
        window_title    type string,
        my_file_filter  type string.

  window_title = text-005.

  class cl_gui_frontend_services definition load.
*  concatenate cl_gui_frontend_services=>filetype_all
*              into my_file_filter.
  my_file_filter = 'All files(*.*)|*.*'(084).
  call method cl_gui_frontend_services=>file_open_dialog
    exporting
      window_title            = window_title
      file_filter             = my_file_filter
    changing
      file_table              = filename_tab
      rc                      = filerc
      user_action             = fileaction
    exceptions
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4.


  if fileaction eq cl_gui_frontend_services=>action_ok.
    check not filename_tab is initial.
    read table filename_tab into filename index 1.
    move filename-filename to p_filename.
  endif.

endform.                    " FILENAME_GET
*&---------------------------------------------------------------------*
*&      Form  UPLOAD_HDR
*&---------------------------------------------------------------------*
*       UPLOAD HEADER  DATA
*------------------------------ ----------------------------------------*
*      -->P_P_HDR  text
*------------------------- ---------------------------------------------*
form upload_hdr  using    p_hdr.

  call function 'GUI_UPLOAD'
    exporting
      filename                = p_hdr
      has_field_separator     = 'X'
    tables
      data_tab                = it_hdr
    exceptions
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
      others                  = 17.
**********************************************************************
**********************************************************************


endform.                    " UPLOAD_HDR
*&---------------------------------------------------------------------*
*&      Form  UPLOAD_ITM
*&------------------------------ ---------------------------------------*
*       text
*--------------------- -------------------------------------------------*
*      -->P_P_ITM  text
*----------------------------------------------------------------------*
form  upload_itm  using    p_itm.
  call function 'GUI_UPLOAD'
    exporting
      filename                = p_itm
      has_field_separator     = 'X'
    tables
      data_tab                = it_item
    exceptions
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
      others                  = 17.
**********************************************************************
**********************************************************************


endform.                    " UPLOAD_ITM
*&---------------------------------------------------------------------*
*&      Form  UPLOAD_SRV
*&---------------------- -----------------------------------------------*
*       text
*------------------------ ----------------------------------------------*
*      -->P_P_SRV  text
*-------------------------- --------------------------------------------*
form upload_srv  using    p_srv.
  call function 'GUI_UPLOAD'
    exporting
      filename                = p_srv
      has_field_separator     = 'X'
    tables
      data_tab                = it_srv
    exceptions
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
      others                  = 17.
**********************************************************************
**********************************************************************


endform.                    " UPLOAD_SRV




*&---------------------------------------------------------------------*
*&      Form  UPLOAD_PROCESS
*&---------------------------------------------------------------------*
*       text
*------------------------- ---------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*--------------------------- -------------------------------------------*
form upload_process.

  refresh: poitem,poschedule,polimits,poschedulex,pocontractlimits,
    poaccount,poservices,posrvaccessvalues,allversions,return,poitemx,
    poaccountx.
  clear: wa_item,wa_srv,poheader,poheaderx,poheaderx,wa_poitemx,wa_poschedule,wa_poschedulex,
    wa_polimits,wa_pocontractlimits,wa_poaccount,wa_poservices,wa_posrvaccessvalues,wa_allversions,wa_ret,lv_pckg,
    lv_sub_pckg,lv_line_no,lv_ext_line_no,lv_serial_no.

  if sy-uname eq 'B.HODHOD'.
    break-point.
  endif.

  check: it_hdr  is not initial
     and it_item is not initial
     and it_srv  is not initial.

  poheaderx-po_number             = 'X'.
  poheaderx-doc_type              = 'X'.
  poheaderx-vendor                = 'X'.
  poheaderx-purch_org             = 'X'.
  poheaderx-pur_group             = 'X'.
  poheaderx-comp_code             = 'X'.
  poheaderx-item_intvl            = 'X'.
*  poheaderx-pmnttrms              = 'X'.
  poheaderx-created_by            = 'X'.
  poheaderx-doc_date              = 'X'.
  poheaderx-retention_type        = 'X'.
  poheaderx-retention_percentage  = 'X'.
  poheaderx-downpay_type          = 'X'.
  poheaderx-downpay_percent       = 'X'.
  poheaderx-downpay_duedate       = 'X'.
  poheaderx-downpay_duedate       = 'X'.
  poheaderx-currency              = 'X'.
  poheaderx-VPER_START            = 'X'.
  poheaderx-VPER_END              = 'X'.


  " Version
  wa_allversions-created_by = 'SYSTEM'.
  append wa_allversions to allversions.


  select *
    from zmm_upld_po_rep
    into table lt_zmm_upld_po_rep
    for all entries in it_hdr
    where xpo_number eq it_hdr-po_number
      and file_name eq p_hdr.


  loop at it_hdr into wa_hdr.

    " Void PO already uploaded if the same file uploaded twice
    read table lt_zmm_upld_po_rep into ls_zmm_upld_po_rep2
    with key xpo_number = wa_hdr-po_number
             file_name  = p_hdr.
    if sy-subrc eq 0 and ls_zmm_upld_po_rep2-status eq 'Done'.
      continue.
    endif.

    lv_pckg         = 100.
    lv_sub_pckg     = 300.

* PO Header
**************
    call function 'CONVERSION_EXIT_ALPHA_INPUT'
      exporting
        input  = wa_hdr-vendor
      importing
        output = poheader-vendor.

    if wa_hdr-doc_date is not initial.
      lv_day   = wa_hdr-doc_date(2).
      lv_month = wa_hdr-doc_date+3(2).
      lv_year  = wa_hdr-doc_date+6(4).
      concatenate lv_year lv_month lv_day into poheader-doc_date.
      clear: lv_day, lv_month, lv_year.
    endif.

    if wa_hdr-downpay_duedate is not initial.
      lv_day   = wa_hdr-downpay_duedate(2).
      lv_month = wa_hdr-downpay_duedate+3(2).
      lv_year  = wa_hdr-downpay_duedate+6(4).
      concatenate lv_year lv_month lv_day into poheader-downpay_duedate.
      clear: lv_day, lv_month, lv_year.
    endif.
    CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
      EXPORTING
        date_external                  = wa_hdr-valid_start
     IMPORTING
       DATE_INTERNAL                  =  poheader-vper_start
.
    CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
      EXPORTING
        date_external                  = wa_hdr-valid_end
     IMPORTING
       DATE_INTERNAL                  =  poheader-vper_end
.

    poheader-doc_type              = wa_hdr-doc_type.
    poheader-purch_org             = wa_hdr-purch_org.
    poheader-pur_group             = wa_hdr-pur_group.
    poheader-comp_code             = wa_hdr-comp_code.
    poheader-retention_type        = wa_hdr-retention_type.
    poheader-retention_percentage  = wa_hdr-retention_percentage.
    poheader-downpay_type          = wa_hdr-downpay_type.
    poheader-downpay_percent       = wa_hdr-downpay_percent.
    poheader-item_intvl            = '00001'.
*    poheader-pmnttrms              = '0001'.
    poheader-created_by            = 'SYSTEM'.
    poheader-currency              = 'EGP'.


    loop at it_item into wa_item where po_number eq wa_hdr-po_number.

      add 1 to lv_pckg.
      add 1 to lv_sub_pckg.
      lv_serial_no    = 1.
      lv_ext_line_no  = 500.
      lv_line_no      = 1.

      " PO Items
      wa_poitem-po_item             = wa_item-po_item.
      wa_poitem-pckg_no             = lv_pckg.
      wa_poitem-item_cat            = wa_item-item_cat.
      wa_poitem-acctasscat          = wa_item-acctasscat.
      wa_poitem-short_text          = wa_item-short_text.
      wa_poitem-plant               = wa_item-plant.
      wa_poitem-matl_group          = wa_item-matl_group.
      wa_poitem-stge_loc            = wa_item-stge_loc.
      wa_poitem-TRACKINGNO          = wa_item-vend_mat.
      wa_poitem-quantity            = '1'.
      append wa_poitem to poitem.

      wa_poitemx-po_item            = wa_item-po_item.
      wa_poitemx-pckg_no            = 'X'.
      wa_poitemx-item_cat           = 'X'.
      wa_poitemx-acctasscat         = 'X'.
      wa_poitemx-short_text         = 'X'.
      wa_poitemx-plant              = 'X'.
      wa_poitemx-matl_group         = 'X'.
      wa_poitemx-stge_loc           = 'X'.
      wa_poitemx-TRACKINGNO         = 'X'.
      wa_poitemx-quantity           = 'X'.
      append wa_poitemx to poitemx.

      if wa_item-delivery_date is not initial.
        lv_day   = wa_item-delivery_date(2).
        lv_month = wa_item-delivery_date+3(2).
        lv_year  = wa_item-delivery_date+6(4).
        concatenate lv_year lv_month lv_day into wa_poschedule-delivery_date.
        clear: lv_day, lv_month, lv_year.
      endif.

      " Schadual Line
      wa_poschedule-po_item       = wa_item-po_item.
      wa_poschedule-sched_line    = '0001'.
      wa_poschedule-quantity      = 1.
      append wa_poschedule to poschedule.

      wa_poschedulex-po_item          = wa_item-po_item.
      wa_poschedulex-sched_line       = 1.
      wa_poschedulex-po_itemx         = 'X'.
      wa_poschedulex-sched_linex      = 'X'.
      wa_poschedulex-delivery_date    = 'X'.
      wa_poschedulex-quantity         = 'X'.
      append wa_poschedulex to poschedulex.


      " Limits
      wa_polimits-pckg_no   = lv_pckg.
      wa_polimits-no_limit  = wa_item-no_limit.
      if wa_item-no_limit eq 'X'.
        wa_polimits-no_frlimit = 'X'.
        wa_polimits-ssc_nolim  = 'X'.
      else.
        wa_polimits-limit     = wa_item-limit.
        wa_polimits-exp_value = wa_item-limit.
        wa_polimits-con_exist = 'X'.
      endif.
      append wa_polimits to polimits.

      " Contract Limits
*      wa_pocontractlimits-pckg_no  = lv_pckg.
*      wa_pocontractlimits-line_no  = '0000000000'.
*      if wa_item-no_limit eq 'X'.
*        wa_pocontractlimits-no_limit = wa_item-no_limit.
*      else.
*        wa_pocontractlimits-limit    = wa_item-limit.
*      endif.
*      append wa_pocontractlimits to pocontractlimits.

      " Service Lines
      wa_poservices-pckg_no     = lv_pckg.
      wa_poservices-line_no     = lv_line_no.
      wa_poservices-outl_ind    = 'X'.
      wa_poservices-subpckg_no  = lv_sub_pckg.
      append wa_poservices to poservices.
      clear: wa_poservices.

      " Account Assignment
      wa_poaccount-po_item    = wa_item-po_item.
      wa_poaccount-serial_no  = lv_serial_no.
      wa_poaccount-quantity   = '1'.
      wa_poaccount-network    = wa_item-network.
      wa_poaccount-activity   = wa_item-activity.
      append wa_poaccount to poaccount.
      clear: wa_poaccount.

      wa_poaccountx-po_item    = wa_item-po_item.
      wa_poaccountx-serial_no  = lv_serial_no.
      wa_poaccountx-quantity   = 'X'.
      wa_poaccountx-po_itemx   = 'X'.
      wa_poaccountx-serial_nox = 'X'.
      wa_poaccountx-network    = 'X'.
      wa_poaccountx-activity   = 'X'.
      append wa_poaccountx to poaccountx.
      clear: wa_poaccountx.

      " Service Account assignment
      wa_posrvaccessvalues-pckg_no    = lv_pckg.
      wa_posrvaccessvalues-line_no    = 0.
      wa_posrvaccessvalues-serial_no  = lv_serial_no.
      wa_posrvaccessvalues-percentage = '100'.
      wa_posrvaccessvalues-quantity   = '1'.
      append wa_posrvaccessvalues to posrvaccessvalues.
      clear: wa_posrvaccessvalues.

      loop at it_srv into wa_srv
        where po_number eq wa_item-po_number
          and po_item   eq wa_item-po_item.

        add 1 to lv_line_no.
        add 1 to lv_ext_line_no.
        add 1 to lv_serial_no.

        " Service Lines
        wa_poservices-pckg_no     = lv_sub_pckg.
        wa_poservices-line_no     = lv_line_no.
        wa_poservices-ext_line    = wa_srv-po_serv_item. " Edited by h.kortam
        wa_poservices-service     = wa_srv-service.
        wa_poservices-quantity    = wa_srv-quantity.
        wa_poservices-gr_price    = wa_srv-gr_price.
        wa_poservices-userf2_txt  = wa_srv-userf2_txt.
        wa_poservices-userf1_txt  = wa_srv-userf1_txt.
        append wa_poservices to poservices.

        " Account Assignment
        wa_poaccount-po_item    = wa_item-po_item.
        wa_poaccount-serial_no  = lv_serial_no.
        wa_poaccount-network    = wa_srv-network.
        wa_poaccount-activity   = wa_srv-activity.
        wa_poaccount-quantity   = '1'.
        append wa_poaccount to poaccount.

        wa_poaccountx-po_item    = wa_item-po_item.
        wa_poaccountx-serial_no  = lv_serial_no.
        wa_poaccountx-network    = 'X'.
        wa_poaccountx-activity   = 'X'.
        wa_poaccountx-quantity   = 'X'.
        wa_poaccountx-po_itemx   = 'X'.
        wa_poaccountx-serial_nox = 'X'.
        append wa_poaccountx to poaccountx.

        " Service Account assignment
        wa_posrvaccessvalues-pckg_no    = lv_sub_pckg.
        wa_posrvaccessvalues-line_no    = lv_line_no.
        wa_posrvaccessvalues-serial_no  = lv_serial_no.
        wa_posrvaccessvalues-percentage = '100'.
        wa_posrvaccessvalues-quantity   = wa_srv-quantity.
        append wa_posrvaccessvalues to posrvaccessvalues.

        clear: wa_srv,wa_poservices,wa_poaccount,wa_posrvaccessvalues,wa_poaccountx.
      endloop.

      clear: wa_item,wa_poitem,wa_poitemx,wa_poschedule,wa_poschedulex,wa_polimits.
      clear: lv_line_no,lv_serial_no,lv_ext_line_no.
    endloop.


    loop at poservices into wa_poservices where service is not initial.
      call function 'CONVERSION_EXIT_ALPHA_INPUT'
        exporting
          input  = wa_poservices-service
        importing
          output = wa_poservices-service.
      modify  poservices from wa_poservices transporting service.
      clear wa_poservices.
    endloop.

    loop at poaccount into wa_poaccount where network is not initial.
      call function 'CONVERSION_EXIT_ALPHA_INPUT'
        exporting
          input  = wa_poaccount-network
        importing
          output = wa_poaccount-network.

      call function 'CONVERSION_EXIT_ALPHA_INPUT'
        exporting
          input  = wa_poaccount-activity
        importing
          output = wa_poaccount-activity.

      modify  poaccount from wa_poaccount transporting network activity.
      clear wa_poaccount.
    endloop.


    call function 'BAPI_PO_CREATE1'
      exporting
        poheader          = poheader
        poheaderx         = poheaderx
      importing
        expheader         = expheader
      tables
        return            = return
        poitem            = poitem
        poitemx           = poitemx
        poschedule        = poschedule
        poschedulex       = poschedulex
        polimits          = polimits
        poaccount         = poaccount
        poaccountx        = poaccountx
        poservices        = poservices
        posrvaccessvalues = posrvaccessvalues
        allversions       = allversions.

    read table return into wa_ret with key type = 'E'.
    if sy-subrc ne 0.
      call function 'BAPI_TRANSACTION_COMMIT'
        exporting
          wait = 'X'.

      ls_zmm_upld_po_rep-status     = 'Done'.
      ls_zmm_upld_po_rep-po_number  = expheader-po_number.
    else.
      ls_zmm_upld_po_rep-status     = 'Failed'.
    endif.

    ls_zmm_upld_po_rep-xpo_number   = wa_hdr-po_number.
    ls_zmm_upld_po_rep-file_name    = p_hdr.
    ls_zmm_upld_po_rep-created_date = sy-datum.
    ls_zmm_upld_po_rep-created_by   = sy-uname.
    modify zmm_upld_po_rep from ls_zmm_upld_po_rep.
    commit work and wait.

    clear: wa_hdr,poheader,ls_zmm_upld_po_rep,expheader,ls_zmm_upld_po_rep2,wa_pocontractlimits.
    clear: lv_pckg,lv_sub_pckg,lv_line_no,lv_ext_line_no,lv_serial_no.
    refresh: poitem,poschedule,polimits,pocontractlimits,poaccount,poservices,posrvaccessvalues,return.
    refresh: poitemx,poschedulex,poaccountx.
  endloop.

endform.                    " UPLOAD_PROCESS
