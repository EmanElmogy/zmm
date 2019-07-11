class ZCL_IM_IMP_PR_POSTED definition
  public
  final
  create public .

public section.

  interfaces IF_EX_ME_REQ_POSTED .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_IMP_PR_POSTED IMPLEMENTATION.


  METHOD if_ex_me_req_posted~posted.

    DATA : gs_eban  TYPE eban,
           ueban    TYPE ueban,
           lv_nplnr	TYPE aufnr,
           lv_pronr	TYPE ps_intnr,
           lv_psphi TYPE ps_psphi,
           gs_proj  TYPE  proj,
           lv_pspnr TYPE ps_posnr.

    IF sy-tcode = 'ME55' OR sy-tcode = 'ME54N'.

      READ TABLE im_eban INTO  ueban INDEX 1.

      SELECT SINGLE * FROM eban INTO gs_eban
        WHERE banfn = ueban-banfn
        AND   bnfpo = ueban-bnfpo.

      SELECT SINGLE nplnr FROM ebkn INTO lv_nplnr WHERE banfn = gs_eban-banfn AND
       bnfpo = gs_eban-bnfpo .

      SELECT SINGLE pronr FROM afko INTO lv_pronr WHERE aufnr = lv_nplnr .

      SELECT SINGLE * INTO gs_proj FROM proj WHERE pspnr = lv_pronr .

      gs_eban-lgort = gs_proj-astnr+4(4) .

      IF  gs_eban-lgort IS INITIAL OR gs_eban-lgort EQ '0' .

        SELECT SINGLE ps_psp_pnr FROM ebkn INTO lv_pspnr WHERE banfn = gs_eban-banfn AND
          bnfpo = gs_eban-bnfpo .

        SELECT SINGLE psphi FROM prps INTO lv_psphi WHERE pspnr = lv_pspnr .
        lv_pspnr = lv_psphi .

        SELECT SINGLE * INTO gs_proj FROM proj WHERE pspnr = lv_pspnr .

        gs_eban-lgort = gs_proj-astnr+4(4) .

      ENDIF.

      SHIFT gs_eban-lgort LEFT DELETING LEADING '0' .
      IF gs_eban-lgort IS INITIAL OR gs_eban-lgort EQ '0' . "08.03.2018 mostafa
        gs_eban-lgort = ueban-lgort .
      ENDIF.
*    gs_eban-lgort = 105 .
     include ZIGET_BEDNR .


      MODIFY eban FROM gs_eban  .

    ENDIF.

  ENDMETHOD.
ENDCLASS.
