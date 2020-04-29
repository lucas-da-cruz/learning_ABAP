*&---------------------------------------------------------------------*
*&  Include           Z_CONTROLE_DE_VOOS_PAI
*&---------------------------------------------------------------------*
MODULE PAI INPUT.
  CASE sy-ucomm .

    WHEN 'VOLTAR' OR 'CANCELAR' OR 'SAIR' .
      LEAVE PROGRAM .

    WHEN 'EXEC' .
      PERFORM EXECUTA_SELECAO.

    WHEN 'BTN_ATRASO' .
      PERFORM INSERE_ATRASO_VOO.
      "Para atualizar a busca todas vezes que inserimos, vamos adicionar o perform de busca aqui
      PERFORM EXECUTA_SELECAO.

  ENDCASE .
ENDMODULE.