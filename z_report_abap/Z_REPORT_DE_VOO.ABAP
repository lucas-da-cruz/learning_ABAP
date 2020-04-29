*&---------------------------------------------------------------------*
*& Report  Z_REPORT_DE_VOO
*&---------------------------------------------------------------------*
REPORT Z_REPORT_DE_VOO.

TYPES: BEGIN OF estrutura_relatorio,
  cia_aerea TYPE S_CARR_ID,
  numero_voo TYPE S_CONN_ID,
  data TYPE S_DATE,
  preco TYPE S_PRICE .
TYPES: END OF estrutura_relatorio.

DATA: tabela_voo TYPE STANDARD TABLE OF estrutura_relatorio,
      estrutura_voo like LINE OF tabela_voo .

CONSTANTS: posicao_preco_cabecalho TYPE i VALUE 36,
           posicao_n_voo_corpo TYPE i VALUE 12,
           posicao_data_corpo TYPE i VALUE 25,
           coluna type c VALUE '|' .

SELECT-OPTIONS: s_cia FOR estrutura_voo-CIA_AEREA NO INTERVALS NO-EXTENSION, "O No intervals define para que não tenha o TO entre os campos de pesquisa
                s_n_voo FOR estrutura_voo-NUMERO_VOO,
                s_data FOR estrutura_voo-DATA,
                s_preco FOR estrutura_voo-PRECO .
START-OF-SELECTION .
ULINE AT (60) ."Adiciona linha no meu relatório, pegando do space 0 ao 55

NEW-LINE.
FORMAT COLOR 4 .
WRITE: coluna, TEXT-001, coluna,
       TEXT-002, coluna,
       TEXT-003, coluna,
       TEXT-004, coluna .
FORMAT COLOR OFF .
NEW-LINE.
ULINE AT (60) .

SELECT CARRID CONNID FLDATE PRICE
  FROM SFLIGHT
  INTO TABLE tabela_voo "Aqui estou jogando minha pesquisa dentro dessa tabela interna
      where CARRID in s_cia "Meu parâmetro criado vem na condição WHERE para ser filtrado.
        and CONNID in s_n_voo
        and FLDATE in s_data
        and PRICE in s_preco
   ORDER BY FLDATE DESCENDING.

IF sy-SUBRC = 0 .
  LOOP AT tabela_voo INTO estrutura_voo .
    PERFORM escreve_nova_linha_no_corpo USING estrutura_voo-cia_aerea
                                              estrutura_voo-numero_voo
                                              estrutura_voo-data
                                              estrutura_voo-preco .
  ENDLOOP .

  PERFORM msg_sucess .

ELSE .
  MESSAGE 'Erro! Não foi encontrado nenhum registro' type 'E' .
ENDIF .

NEW-LINE .
ULINE AT (60).

SKIP .
FORMAT COLOR 3.
WRITE 'Relatório gerado em: '.
WRITE sy-DATUM.
FORMAT COLOR OFF .

FORM escreve_nova_linha_no_corpo USING cia_aerea numero_voo data preco.
  NEW-LINE .
  write: coluna, (10) cia_aerea CENTERED, coluna,
                 (15) numero_voo CENTERED, coluna,
                 (12) data DD/MM/YY, coluna, "O comando WRITE disponibiliza algumas formatações de uso
                 (10) preco LEFT-JUSTIFIED, coluna .
ENDFORM .

FORM msg_sucess .
  DATA: numero_registros TYPE string,
        msg              TYPE string .
  numero_registros = sy-dbcnt .
  CONCATENATE 'Sucesso! Encontrado(s):' numero_registros 'Registros' INTO msg SEPARATED BY space .

*Em MESSAGE existe type do tipo E de Erro, W de warning e S de sucesso
  MESSAGE msg TYPE 'S' .
ENDFORM .