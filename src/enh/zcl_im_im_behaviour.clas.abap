class ZCL_IM_IM_BEHAVIOUR definition
  public
  final
  create public .

public section.

  interfaces IF_EX_IM_BEHAVIOUR .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_IM_BEHAVIOUR IMPLEMENTATION.


  METHOD if_ex_im_behaviour~get_behaviour.
*$*$----------------------------------------------------------------$*$*
*$ Correction Inst.         0020751259 0000045549                     $*
*$--------------------------------------------------------------------$*
*$ Valid for       :                                                  $*
*$ Software Component   S4CORE                                        $*
*$  Release 100          All Support Package Levels                   $*
*$  Release 101          All Support Package Levels                   $*
*$  Release 102          All Support Package Levels                   $*
*$  Release 103          All Support Package Levels                   $*
*$--------------------------------------------------------------------$*
*$ Changes/Objects Not Contained in Standard SAP System               $*
*$*$----------------------------------------------------------------$*$*
*&--------------------------------------------------------------------*
*& Object          METH IF_EX_IM_BEHAVIOUR~GET_BEHAVIO
*&                      UR
*& Object Header   CLAS IF_EX_IM_BEHAVIOUR~GET_BEHAVIOUR
*&--------------------------------------------------------------------*
*>>>> START OF INSERTION <<<<
IF situation = 'GET_GR_TXNS_WITH_AVC'.
    CONCATENATE
      'MIGO-MB01-MB31-ML81N-ML85-ME21N-ME22N-ME23N-QA11-VI01-VI02-'
      'VL31-VL31N-VL32-VL32N-'
      'WE12-WE14-WE15-WE16-WE17-WE18-WE19'
*    '-BAPI_RFC'
*    '-BAPI_DIR'
      INTO behaviour.
  ENDIF.
*>>>> END OF INSERTION <<<<<<
  ...
*&--------------------------------------------------------------------*
ENDMETHOD.
ENDCLASS.
