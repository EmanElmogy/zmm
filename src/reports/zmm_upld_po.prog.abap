*&---------------------------------------------------------------------*
*& Report  ZMM_UPLD_PO
*&
*&------------------------------ ---------------------------------------*
*&
*&
*&------------------------- ---- ----------------------------------------*
******************************** ****************************************
* OBJECT ID               :
* PROGRAM TITLE           :  PO UPLOAD
* MODULE                  :  MM
* PROGRAM TYPE            :  UPLOAD PROGRAM
* INPUT                   :  3 EXCEL SHEETS  FOR HEADER , ITEM , SERVICE
* OUTPUT                  :  LOG
* CREATED BY              :  EMAN /CIC
* CREATION DATE           :  6-JULY-15
*-----------------------------------------------------------------------
* DESCRIPTION             :  PROGRAM THAT TAKES PO HEADER DATA ,
*      ITEM OVERVIEW DATA AND SERVICES THEN UPLOAD THEM TO THE SYSTEM
*************************************************************************
* Modification history:
*-----------------------------------------------------------------------
* DATE      |Owner  |Request  | Description
*---------------------- -------------------------------------------------
*************************************** *********************************


report zmm_upld_po.

include zmm_upld_po_top . "  TOP INCLUDE
include zmm_upld_po_sel . "  SELECTION SCREEN
include zmm_upld_po_f01.  "  SUBROUTINES


at selection-screen on value-request for p_hdr .
  perform filename_get changing p_hdr .

at selection-screen on value-request for p_itm .
  perform filename_get changing p_itm .

at selection-screen on value-request for p_srv .
  perform filename_get changing p_srv .

end-of-selection.

  perform upload_hdr using  p_hdr .
  perform upload_itm using p_itm .
  perform upload_srv using p_srv .
  perform upload_process.
