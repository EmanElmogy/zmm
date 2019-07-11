*&---------------------------------------------------------------------*
*&  Include           ZXMLUU19
*&---------------------------------------------------------------------*

*When creating a new SES on specific PO-Item, Check if all previous SES on the same PO-Item are approved.


if sy-uname eq 'B.HODHOD'.
  break-point.
endif.

* sy-ucomm = 'ENTE'.
*RM11R-EBELN
*RM11R-LBLNI


data: event_type type sy-ucomm.
data: it_essr type essr.

import event_type from memory id 'ZEVENT_TYPE'.
import it_essr from memory id 'ZDATA_ID'.


if sy-tcode eq 'ML81N'.
  if event_type eq 'NEU' or event_type eq 'COPY'.

    data: lt_essr type table of essr,
          ls_essr type essr.

    data: ses_not_approved  type c length 500.
    data: counter type n length 3.

    select *
      from essr
      into table lt_essr
      where ebeln eq c_essr-ebeln
        and ebelp eq c_essr-ebelp
        and loekz ne 'X'.

    delete lt_essr where frgrl ne 'X' and kzabn eq 'X'.
    if lt_essr[] is not initial.
      ses_not_approved = 'Selected PO has service entry sheet/s not approved'.
      message ses_not_approved type 'W' display like 'E'.
      leave to current transaction.
    endif.

    refresh: lt_essr.
    clear: ls_essr,ses_not_approved.
  endif.
endif.




** Filter SES by approved SES only
*    counter = 0.
*    loop at lt_essr into ls_essr.
*      if ls_essr-frgrl eq abap_true.
*        add 1 to counter.
*        if counter eq 1.
*          ses_not_approved = ls_essr-lblni.
*        else.
*          concatenate ses_not_approved ',' ls_essr-lblni into ses_not_approved.
*        endif.
*      endif.
*      clear: ls_essr.
*    endloop.
*
*    if ses_not_approved is not initial.
*      concatenate 'Service Entry Sheets #: ' ses_not_approved 'not approved.'
*        into ses_not_approved separated by space.
*      message ses_not_approved type 'W' display like 'E'.
*      leave to current transaction.
*    endif.
