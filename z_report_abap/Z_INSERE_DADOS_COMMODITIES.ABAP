REPORT Z_INSERE_DADOS_COMMODITIES.

PARAMETERS: P_EMP   TYPE ZTA_CONV_MOEDA-ZEMPRESA,
            P_COM   TYPE ZTA_CONV_MOEDA-ZCOMMODITES,
            P_DIA   TYPE ZTA_CONV_MOEDA-DIA_DA_ATUALIZACAO,
            P_VALOR TYPE ZTA_CONV_MOEDA-ZVALOR.

"Definindo a estrutura do tipo da tabela
DATA: es_zte_conv_moeda TYPE zta_conv_moeda.
"Mover os dados que o user inseriu para nossa estrutura
MOVE: p_emp    to es_zte_conv_moeda-zempresa,
      P_COM    to es_zte_conv_moeda-ZCOMMODITES,
      P_DIA    to es_zte_conv_moeda-DIA_DA_ATUALIZACAO,
      P_VALOR  to es_zte_conv_moeda-ZVALOR,
      "Recuperar os dados para buscar os logs
      sy-uname to es_zte_conv_moeda-usuario,
      sy-datum to es_zte_conv_moeda-data,
      sy-uzeit to es_zte_conv_moeda-hora.

*SELECT COUNT(*)
*  FROM ZTA_CONV_MOEDA
*  WHERE ZEMPRESA           = P_EMP AND
*        ZCOMMODITES        = P_COM AND
*        DIA_DA_ATUALIZACAO = P_DIA.
*
*  IF SY-SUBRC IS INITIAL.
*    UPDATE ZTA_CONV_MOEDA FROM es_zte_conv_moeda.
*    IF SY-SUBRC IS INITIAL.
*      MESSAGE: 'Dados alterado com sucesso' TYPE 'S'.
*     ENDIF.
*  ELSE.
*    INSERT ZTA_CONV_MOEDA FROM es_zte_conv_moeda.
**Sy-subrc essa variável sempre nos retorna
**se a operação foi realizada com sucesso
*    IF SY-SUBRC = 0.
*      MESSAGE: 'Dados inseridos com sucesso' TYPE 'S'.
*     ENDIF.
*  ENDIF.

*Comando SAP que reconhece se será feito um insert ou update
  MODIFY ZTA_CONV_MOEDA FROM es_zte_conv_moeda.
  IF SY-SUBRC IS INITIAL.
    MESSAGE: 'Dados inserido ou alterado com sucesso' TYPE 'S'.
  ENDIF.