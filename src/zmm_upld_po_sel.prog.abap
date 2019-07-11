*&------------------- --------------------- -----------------------------*
*&  Include           ZMM_UPLD_PO_SEL
*&---------------------- -- ---------------------------------------------*
selection-screen : begin of block blck with frame title text-001.
parameters : p_hdr type string obligatory,
             p_itm type string obligatory,
             p_srv type string obligatory. "c length 132 lower case .
selection-screen : end of block blck .
