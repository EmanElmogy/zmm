*&---------------------------------------------------------------------*
*& Include          ZSES_QTY_PERC_UPDATE
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Include          ZSES_QTY_PERC_UPDATE
*&---------------------------------------------------------------------*
IF srv_esll-srvpos IS NOT INITIAL .

************************************************************************
*-----------------------quantity total update  ------------------------------
************************************************************************


************************************************************************

  "reflect the changes in extsrvno and screen enh
  IMPORT ci_eslldb-zzlocation TO lv_loc FROM MEMORY ID 'LOC'.
  IF lv_loc IS NOT INITIAL.

    srv_esll-extsrvno = lv_loc.
    FREE MEMORY ID 'LOC'.
    CLEAR lv_loc.

  ELSE.
    IMPORT lv_space TO lv_space FROM MEMORY ID 'INIT'.
    IF lv_space = 'X'.
      srv_esll-extsrvno = ''.
      FREE MEMORY ID 'INIT'.
    ENDIF.

    IF srv_esll-extsrvno IS NOT INITIAL AND srv_esll-zzlocation IS INITIAL.
      srv_esll-zzlocation = srv_esll-extsrvno.
    ELSEIF  srv_esll-extsrvno IS NOT INITIAL AND srv_esll-zzlocation IS NOT INITIAL AND srv_esll-extsrvno <> srv_esll-zzlocation.
      srv_esll-zzlocation = srv_esll-extsrvno.
    ELSEIF srv_esll-extsrvno IS INITIAL AND srv_esll-zzlocation IS NOT INITIAL.
      srv_esll-zzlocation = '' .
    ENDIF.
  ENDIF.


  " get service qty from po
  IF wa_essr-frgrl IS NOT INITIAL .
    CLEAR menge .
    SELECT SINGLE s~menge
      FROM ekpo INNER JOIN esll AS e ON ekpo~packno = e~packno
                INNER JOIN esll AS s ON e~sub_packno = s~packno
      INTO menge
      WHERE ebeln = wa_essr-ebeln
        AND ebelp = wa_essr-ebelp
        AND s~srvpos = srv_esll-srvpos.


    " GET THE LAST SERVICE TO CALCULATE THE USER FIELDS USING IT
    REFRESH it_srv .
    CLEAR last_srv .
    LOOP AT ix_esll INTO wa_esll WHERE srvpos = srv_esll-srvpos
                                   AND extrow    LT srv_esll-extrow
                                   AND packno    EQ srv_esll-packno
                                   AND extsrvno  EQ srv_esll-extsrvno.
      MOVE-CORRESPONDING wa_esll TO wa_srv .
      APPEND wa_srv  TO it_srv .
      CLEAR wa_srv .

    ENDLOOP.

    "" SELECT ALL QUANTITIES FOR THE CURRENT SERVICE
    LOOP AT ix_esll INTO wa_esll WHERE srvpos = srv_esll-srvpos
                                    AND extrow    LT srv_esll-extrow
                                    AND packno    EQ srv_esll-packno.

      MOVE-CORRESPONDING wa_esll TO wa_srv .
      APPEND wa_srv  TO lt_srv .
      CLEAR wa_srv .

    ENDLOOP.



    SELECT lblni ebeln ebelp packno
      FROM essr
      INTO CORRESPONDING FIELDS OF TABLE it_sheet1
      WHERE ebeln    = wa_essr-ebeln
        AND ebelp    = wa_essr-ebelp
        AND lblni NE wa_essr-lblni
        AND loekz NE 'X'.

    IF it_sheet1[] IS NOT INITIAL.
*          sort it_sheet by lblni DESCENDING .
*        READ TABLE it_sheet INTO wa_sheet INDEX 1 .
      " get list of services of the last entry sheet
      " aliases s : servise
      "         e : entry sheet
      SELECT s~packno s~extrow s~userf1_num s~userf2_num s~userf2_txt s~userf1_txt s~extsrvno
        FROM esll AS e INNER JOIN esll AS s ON  e~sub_packno = s~packno
        APPENDING CORRESPONDING FIELDS OF TABLE lt_srv
        FOR ALL ENTRIES IN it_sheet1
        WHERE e~packno = it_sheet1-packno
        AND s~srvpos   = srv_esll-srvpos.

      "warning message if new location is created.


      lt_srv1 = lt_srv.
      DELETE it_srv WHERE extsrvno <> srv_esll-extsrvno.
      SORT lt_srv DESCENDING BY extsrvno packno extrow.
      DELETE ADJACENT DUPLICATES FROM lt_srv COMPARING extsrvno.

    ENDIF.

    "Calculate the total qty.
    LOOP AT lt_srv INTO DATA(ls_srv).
      lv_qty = lv_qty + ls_srv-userf1_num.
    ENDLOOP.

    IF it_srv[] IS NOT INITIAL.

      " CASE_1 : THE SEVICE IS IN THE CURRENT ENTRY SHEET
      SORT it_srv DESCENDING BY extrow .
      READ TABLE it_srv INTO wa_srv INDEX 1 .
      last_srv = wa_srv .

    ELSE.
      " CASE_2 : THE SEVICE IS NOT  IN THE CURRENT ENTRY SHEET
      " SO WE'LL SELECT ALL THE SERVICE FOR THIS PO AND CHECK
      " THE LAST ONE
      CLEAR last_srv .
*      REFRESH it_esll .

      " get list of entry sheets for this po execluding the current 1
      SELECT lblni ebeln ebelp packno
        FROM essr
        INTO CORRESPONDING FIELDS OF TABLE it_sheet
        WHERE ebeln    = wa_essr-ebeln
          AND ebelp    = wa_essr-ebelp
          AND lblni NE wa_essr-lblni
          AND loekz NE 'X'.

      IF it_sheet[] IS NOT INITIAL.
*          sort it_sheet by lblni DESCENDING .
*        READ TABLE it_sheet INTO wa_sheet INDEX 1 .
        " get list of services of the last entry sheet
        " aliases s : servise
        "         e : entry sheet
        SELECT s~packno s~extrow s~userf1_num s~userf2_num s~userf2_txt s~userf1_txt s~extsrvno
          FROM esll AS e INNER JOIN esll AS s ON  e~sub_packno = s~packno
          INTO CORRESPONDING FIELDS OF TABLE it_srv
          FOR ALL ENTRIES IN it_sheet
          WHERE e~packno = it_sheet-packno
          AND s~extsrvno = srv_esll-extsrvno
          AND s~srvpos   = srv_esll-srvpos.


        IF it_srv[] IS NOT INITIAL.
          SORT it_srv DESCENDING BY packno extrow .
          READ TABLE it_srv INTO wa_srv INDEX 1 .
          last_srv = wa_srv .

          " case 3 the service is uploaded and not assigned yet to entry sheet
          " we'll read it from ztable to get its history

        ENDIF.

      ENDIF.


    ENDIF.
    IF srv_esll-extsrvno IS NOT INITIAL AND lt_srv1[] IS INITIAL.
      READ TABLE gt_locations WITH KEY ebeln = wa_essr-ebeln
      ebelp = wa_essr-ebelp location = srv_esll-extsrvno lblni = wa_essr-lblni TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.

        gs_locations-ebeln    = wa_essr-ebeln.
        gs_locations-ebelp    = wa_essr-ebelp.
        gs_locations-location = srv_esll-extsrvno.
        gs_locations-srvpos   = srv_esll-srvpos.
        gs_locations-lblni    = wa_essr-lblni.
        APPEND gs_locations TO gt_locations.
        CLEAR gs_locations.
        MESSAGE 'New Location will be created' TYPE 'W'.
      ENDIF.
    ENDIF.

    IF srv_esll-extsrvno IS NOT INITIAL.

      READ TABLE gt_locations WITH KEY ebeln = wa_essr-ebeln
      ebelp = wa_essr-ebelp location = srv_esll-extsrvno lblni = wa_essr-lblni srvpos = srv_esll-srvpos TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        READ TABLE lt_srv1 WITH KEY extsrvno = srv_esll-extsrvno TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.

          gs_locations-ebeln    = wa_essr-ebeln.
          gs_locations-ebelp    = wa_essr-ebelp.
          gs_locations-location = srv_esll-extsrvno.
          gs_locations-srvpos   = srv_esll-srvpos.
          gs_locations-lblni    = wa_essr-lblni.
          APPEND gs_locations TO gt_locations.
          CLEAR gs_locations.
          MESSAGE 'New Location will be created' TYPE 'W'.
        ENDIF.
      ENDIF.
    ENDIF.

    IF srv_esll-srvpos IS NOT INITIAL.
      READ TABLE gt_serv
        WITH KEY ebeln = wa_essr-ebeln ebelp = wa_essr-ebelp srvpos = srv_esll-srvpos lblni = wa_essr-lblni TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.

        LOOP AT lt_srv1 INTO DATA(ls_srv1) WHERE extsrvno IS NOT INITIAL.

        ENDLOOP.

        IF sy-subrc  = 0.
          gs_serv-ebeln = wa_essr-ebeln.
          gs_serv-ebelp = wa_essr-ebelp.
          gs_serv-srvpos = srv_esll-srvpos.
          gs_locations-srvpos   = srv_esll-srvpos.
          gs_serv-lblni  = wa_essr-lblni.
          APPEND gs_serv TO gt_serv.
          CLEAR gs_serv.
          MESSAGE 'Service Locations Exist' TYPE 'W'.
        ENDIF.
      ENDIF.
    ENDIF.
    IF last_srv IS INITIAL .
      SELECT SINGLE *
                FROM zmm_srv_upld
                INTO wa_srv_upld
                WHERE ebeln     = wa_essr-ebeln
                AND   ebelp     = wa_essr-ebelp
                AND   srvpos    = srv_esll-srvpos.

      IF sy-subrc = 0 .
        MOVE-CORRESPONDING wa_srv_upld TO last_srv .
      ENDIF.

    ENDIF.

    " CALCULATE THE USER FIELDS USING THE LAST SERVICE .
    CLEAR : userf1_num  ,
            userf2_num .
    IF last_srv IS NOT INITIAL. " THIS SERVICE IS CREATED BEFORE
      CASE srv_esll-formelnr .

        WHEN 'P+'.

          srv_esll-frmval1 = last_srv-userf1_num .
          userf1_num = last_srv-userf1_num .
          userf2_num = last_srv-userf2_num + srv_esll-frmval2 .
          READ TABLE lt_srv INTO ls_srv WITH KEY extsrvno = srv_esll-extsrvno.
          IF sy-subrc = 0.
            lv_qty = lv_qty - ls_srv-userf1_num.
          ENDIF.

          lv_qty     = lv_qty + userf1_num.
*          SHIFT userf2_num LEFT DELETING LEADING space .
          "percentage validation
          IF userf2_num GT 100 .
            MESSAGE 'Percentage should not excced 100' TYPE 'E' .
          ENDIF.


        WHEN 'P-'.
          srv_esll-frmval1 = last_srv-userf1_num .
          userf1_num = last_srv-userf1_num .
          userf2_num = last_srv-userf2_num - srv_esll-frmval2 .
*          SHIFT userf2_num LEFT DELETING LEADING space .
          " Percentage Validation
          IF userf2_num LT 0.
            MESSAGE 'Percentage should not be less than 0' TYPE 'E' .
          ENDIF.
*          IF srv_esll-userf2_txt IS NOT INITIAL.
*            IF userf1_num GT srv_esll-userf2_txt .
*              MESSAGE 'Quantity should not exceed اعمال الحصر' TYPE 'E' .
*            ENDIF.
*          ELSE.
*            IF userf1_num GT menge .
*              MESSAGE 'Quantity should not exceed PO quantity' TYPE 'E' .
*            ENDIF.
*          ENDIF.

        WHEN 'Q+'.
          srv_esll-frmval2 = last_srv-userf2_num .
          userf2_num = last_srv-userf2_num .
          userf1_num = last_srv-userf1_num + srv_esll-frmval1 .
          READ TABLE lt_srv INTO ls_srv WITH KEY extsrvno = srv_esll-extsrvno.
          IF sy-subrc = 0.
            lv_qty = lv_qty - ls_srv-userf1_num.
          ENDIF.
          lv_qty     = lv_qty +  userf1_num.
*          IF srv_esll-userf2_txt IS NOT INITIAL.
*            IF userf1_num GT srv_esll-userf2_txt .
*              MESSAGE 'Quantity should not exceed اعمال الحصر' TYPE 'E' .
*            ENDIF.
*          ELSE.
*            IF userf1_num GT menge .
*              MESSAGE 'Quantity should not exceed PO quantity' TYPE 'E' .
*            ENDIF.
*          ENDIF.

        WHEN 'Q-'.
          srv_esll-frmval2 = last_srv-userf2_num .
          userf2_num = last_srv-userf2_num .
          userf1_num = last_srv-userf1_num - srv_esll-frmval1 .
          READ TABLE lt_srv INTO ls_srv WITH KEY extsrvno = srv_esll-extsrvno.
          IF sy-subrc = 0.
            lv_qty = lv_qty - ls_srv-userf1_num.
          ENDIF.
          lv_qty     = lv_qty  - userf1_num .
        WHEN OTHERS .
          userf1_num = last_srv-userf1_num .
          userf2_num = last_srv-userf2_num .
      ENDCASE.
      SHIFT userf1_num LEFT DELETING LEADING space .
*      SHIFT userf2_num LEFT DELETING LEADING space .

    ELSE. " THE FIRST TIME FOR THIS SERVICE TO BE CREATED

      userf1_num = srv_esll-frmval1 .
      userf2_num = srv_esll-frmval2 .
      IF srv_esll-formelnr EQ 'P+' OR srv_esll-formelnr EQ 'Q+'.
        lv_qty = lv_qty + userf1_num.
      ELSEIF srv_esll-formelnr = 'Q-'.
        lv_qty = lv_qty + userf1_num.
      ENDIF.

      SHIFT userf1_num LEFT DELETING LEADING space .
*      SHIFT userf2_num LEFT DELETING LEADING space .


    ENDIF.

    IF srv_esll-formelnr IS NOT INITIAL.

*      diff =
      qty_tot = userf1_num .
      qty_hasr = srv_esll-userf2_txt .
      IF srv_esll-userf2_txt IS NOT INITIAL.

        IF ( lv_qty GT qty_hasr OR qty_tot GT qty_hasr  OR  srv_esll-frmval2 GT 100 ) .
          MESSAGE 'Quantity should not exceed اعمال الحصر' TYPE 'E' .
        ENDIF.
      ELSE.
        IF ( qty_tot GT menge OR   srv_esll-frmval2 GT 100 OR lv_qty GT menge ) .
*          MESSAGE 'Quantity should not exceed PO quantity' TYPE 'E' . "Commented by Maryam 12.03.2018
        ENDIF.
      ENDIF.
*      if userf1_num NE SRV_ESLL-USERF2_TXT AND SRV_ESLL-USERF2_TXT IS NOT INITIAL .
*             MESSAGE 'Update quantity  to be equivalent to الحصر الهندسى' TYPE 'E'.
*           ENDIF .

    ENDIF.

    srv_esll-userf1_num = userf1_num .
    srv_esll-userf2_num = userf2_num .
    SHIFT srv_esll-userf1_num LEFT DELETING LEADING space .

    IF  srv_esll-userf2_txt IS  INITIAL.
      srv_esll-userf2_txt = last_srv-userf2_txt. " to read user field 3 اعمال الحصر
    ENDIF.

    IF  srv_esll-userf1_txt IS  INITIAL.
      srv_esll-userf1_txt = last_srv-userf1_txt. " to read user field 3 اعمال الحصر
    ENDIF.


  ENDIF.


*  ""adopt the new location from the ext. service.
*  IF srv_esll-extsrvno IS INITIAL AND srv_esll-zzlocation IS NOT INITIAL.
*    srv_esll-extsrvno = srv_esll-zzlocation.
*  ELSEIF srv_esll-extsrvno IS NOT INITIAL AND srv_esll-zzlocation IS NOT INITIAL.
*    srv_esll-extsrvno = srv_esll-zzlocation.
*  ELSEIF srv_esll-extsrvno IS INITIAL AND srv_esll-zzlocation IS INITIAL.
*    srv_esll-zzlocation = ' '.
*    srv_esll-extsrvno   = ' '.
*  ELSEIF srv_esll-extsrvno IS NOT INITIAL AND srv_esll-zzlocation IS INITIAL.
*    srv_esll-zzlocation = srv_esll-extsrvno.
*  ENDIF.

ENDIF.
