*&---------------------------------------------------------------------*
*&  Include           Z_CONTROLE_DE_VOOS_DECLARACOES
*&---------------------------------------------------------------------*
TABLES ZSPFLI_ATRASOS .
DATA spfli TYPE SPFLI .

*Tipo de data faz referencia a uma classo (OBJETO)
DATA: CUSTOM_CONTAINER TYPE REF TO cl_gui_custom_container,
      ALV              TYPE REF TO CL_GUI_ALV_GRID,
      fieldcat          TYPE lvc_t_fcat.

*Criação da minha tabela interna do tipo da spfli
*DATA it_spfli TYPE STANDARD TABLE OF spfli .

DATA RELATORIO_ATRASOS TYPE STANDARD TABLE OF ZSPFLI_ATRASOS_ESTRUTURA.