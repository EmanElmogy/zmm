*&---------------------------------------------------------------------*
*& Report ZR_MM_SERVICE_LTXT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZR_MM_SERVICE_LTXT.

INCLUDE zr_mm_service_ltxt_dd.
INCLUDE zr_mm_service_ltxt_ss.
INCLUDE zr_mm_service_ltxt_fm.


AT SELECTION-SCREEN  ON VALUE-REQUEST FOR p_fname.

CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = 'P_FNAME'
    IMPORTING
      file_name     = p_fname.


START-OF-SELECTION.
  PERFORM update_service .
