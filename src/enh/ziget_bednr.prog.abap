*&---------------------------------------------------------------------*
*& Include ZIGET_BEDNR
*&---------------------------------------------------------------------*

DATA: ls_afvc TYPE afvc,
      ls_ebkn TYPE ebkn,
      ls_prps TYPE prps.

DATA: projn_char TYPE char100.

DATA: lv_count TYPE int2,
      lv_projn TYPE afvc-projn.

IF sy-uname = 'H.KORTAM' .
  BREAK-POINT .
ENDIF.

SELECT SINGLE * FROM ebkn INTO ls_ebkn WHERE banfn = gs_eban-banfn AND bnfpo = gs_eban-bnfpo .

SELECT SINGLE * FROM afvc INTO ls_afvc WHERE aufpl = ls_ebkn-aufpl AND aplzl = ls_ebkn-aplzl .

CALL FUNCTION 'CONVERSION_EXIT_ABPSP_OUTPUT'
  EXPORTING
    input  = ls_afvc-projn
  IMPORTING
    output = projn_char.

SELECT SINGLE * FROM prps INTO ls_prps WHERE pspnr = ls_afvc-projn .

IF ls_prps-usr11 = 'X' .
  gs_eban-bednr = ls_prps-post1 .
ELSE.
  WHILE projn_char CA '.'.
    lv_count = strlen( projn_char ) .
    lv_count = lv_count - 3 .
    projn_char = projn_char(lv_count) .

    CALL FUNCTION 'CONVERSION_EXIT_ABPSP_INPUT'
      EXPORTING
        input     = projn_char
      IMPORTING
        output    = lv_projn
      EXCEPTIONS
        not_found = 1
        OTHERS    = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.


    SELECT SINGLE * FROM prps INTO ls_prps WHERE pspnr = lv_projn .
    IF ls_prps-usr11 = 'X' .
      gs_eban-bednr = ls_prps-post1  .
      EXIT.
    ENDIF.
  ENDWHILE.
ENDIF.
