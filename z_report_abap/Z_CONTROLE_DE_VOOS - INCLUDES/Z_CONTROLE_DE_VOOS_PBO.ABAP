*&---------------------------------------------------------------------*
*&  Include           Z_CONTROLE_DE_VOOS_PBO
*&---------------------------------------------------------------------*
MODULE PBO OUTPUT.

  DATA coluna LIKE LINE OF fieldcat .

  SET PF-STATUS '1000'.

  IF custom_container IS NOT BOUND .

  CREATE OBJECT CUSTOM_CONTAINER
    exporting
      CONTAINER_NAME = 'CC_ALV' .

  CREATE OBJECT ALV
    exporting
      I_PARENT = CUSTOM_CONTAINER .

*Chamando uma função
*Passamos uma estrutura p/ a função
*E ele nos retornará uma tabela para passarmos ao ALV
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
  EXPORTING
    i_structure_name = 'ZSPFLI_ATRASOS_ESTRUTURA'
    CHANGING
      "Devemos passar um atributo do tipo lvc_t_fcat
      CT_FIELDCAT = fieldcat .

*Para chamar um método do objeto
*Ele é responsável por inicialiazar o alv
  CALL METHOD alv->SET_TABLE_FOR_FIRST_DISPLAY
    changing
      IT_OUTTAB = RELATORIO_ATRASOS
      IT_FIELDCATALOG = fieldcat .

ENDIF .

CALL METHOD alv->refresh_table_display( ) .

  PERFORM CONTROLA_CAMPOS .
ENDMODULE.