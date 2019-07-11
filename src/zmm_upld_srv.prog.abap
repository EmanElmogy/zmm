*&--------------------------- -- ----------------------------------------*
*& Report  ZMM_UPLD_SRV
*&
*&---------------------------- -----------------------------------------*
*&
*&
*&------------------------------ ---------------------------------------*

REPORT ZMM_UPLD_SRV.

INCLUDE ZMM_UPLD_SRV_TOP . " TOP INCLUDE

INCLUDE ZMM_UPLD_SRV_SEL . " SELECTION SCREEN

INCLUDE ZMM_UPLD_SRV_F01.  "SUBROUTINES


" get file Destination

AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.

  " popup for geting the text file

  PERFORM filename_get.

**********************************************************************
**********************************************************************

END-OF-SELECTION.
PERFORM read_file .
PERFORM upload_file.
