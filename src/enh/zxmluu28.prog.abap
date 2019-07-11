*&---------------------------------------------------------------------*
*&  Include           ZXMLUU28
*&---------------------------------------------------------------------*

* When creating a new SES on specific PO-Item, Check if all previous SES on the same PO-Item are approved.
        DATA: event_type TYPE sy-ucomm.
        DATA it_essr TYPE essr .

        IF sy-ucomm EQ 'NEU' OR sy-ucomm EQ 'COPY'.
          event_type = sy-ucomm.
          EXPORT event_type TO MEMORY ID 'ZEVENT_TYPE'.
        ENDIF.

        IMPORT it_essr-zlgort FROM MEMORY ID 'ZDATA_ID' .
        "    import it_essr-zIDNLF from memory id 'ZDATA_ID_2' .

        IF it_essr-zlgort  IS NOT INITIAL .
          e_essrdb-zlgort = it_essr-zlgort .
          "      e_essrdb-zIDNLF = it_essr-zIDNLF .
        ENDIF.

        FREE MEMORY ID 'ZDATA_ID' .
        "     free memory id 'ZDATA_ID_2' .
