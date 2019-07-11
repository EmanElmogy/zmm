*&---------------------------------------------------------------------*
*& Include          ZMM_SERV_PROGRESS_TRACKE01
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN ON so_item.
  IF so_po-low IS NOT INITIAL AND so_item IS NOT INITIAL.

    SELECT SINGLE *
      FROM ekpo
      INTO @DATA(ls_ekpo)
      WHERE ebeln = @so_po-low
      AND   ebelp = @so_item-low.

    IF sy-dbcnt <= 0 .
      MESSAGE 'The selected item does not exist' TYPE 'E'.
    ENDIF.

  ENDIF.

START-OF-SELECTION.

  PERFORM select_ses_data.

  PERFORM get_serv_quantity.

  PERFORM select_item_desc.

  PERFORM build_field_catalog.

  PERFORM display_alv_grid.
