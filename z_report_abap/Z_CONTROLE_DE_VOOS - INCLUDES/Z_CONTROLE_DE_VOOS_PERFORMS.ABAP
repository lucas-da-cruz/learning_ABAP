*&---------------------------------------------------------------------*
*&  Include           Z_CONTROLE_DE_VOOS_PERFORMS
*&---------------------------------------------------------------------*
FORM EXECUTA_SELECAO.
  IF ZSPFLI_ATRASOS-DIA_DO_VOO IS INITIAL.
        SELECT CARRID, CONNID, COUNTRYFR,
               CITYFROM, AIRPFROM, COUNTRYTO,
               CITYTO, AIRPTO, FLTIME,
               DEPTIME, ARRTIME
        FROM SPFLI
          INTO TABLE @RELATORIO_ATRASOS
            WHERE CARRID   IN @s_carrid
              AND CONNID   IN @s_connid
              AND CITYFROM IN @s_cityfr
              AND CITYTO   IN @s_cityto .
      ELSE.
        SELECT SPFLI~CARRID, SPFLI~CONNID, SPFLI~COUNTRYFR,
               SPFLI~CITYFROM, SPFLI~AIRPFROM, SPFLI~COUNTRYTO,
               SPFLI~CITYTO, SPFLI~AIRPTO, SPFLI~FLTIME,
               SPFLI~DEPTIME, SPFLI~ARRTIME, ZSPFLI_ATRASOS~DIA_DO_VOO, ZSPFLI_ATRASOS~ATRASO
          FROM SPFLI AS SPFLI INNER JOIN ZSPFLI_ATRASOS AS ZSPFLI_ATRASOS
            ON SPFLI~CARRID = ZSPFLI_ATRASOS~CARRID
            AND SPFLI~CONNID = ZSPFLI_ATRASOS~CONNID
            INTO TABLE @RELATORIO_ATRASOS
              WHERE SPFLI~CARRID   IN @s_carrid
                AND SPFLI~CONNID   IN @s_connid
                AND SPFLI~CITYFROM IN @s_cityfr
                AND SPFLI~CITYTO   IN @s_cityto
                AND ZSPFLI_ATRASOS~DIA_DO_VOO = @zspfli_atrasos-dia_do_voo.

          IF SY-SUBRC = 0.
            DATA WA_RELATORIO_ATRASOS LIKE LINE OF RELATORIO_ATRASOS.

            LOOP AT RELATORIO_ATRASOS INTO WA_RELATORIO_ATRASOS .
              IF WA_RELATORIO_ATRASOS-ATRASO IS NOT INITIAL .

                WA_RELATORIO_ATRASOS-ARRTIME = WA_RELATORIO_ATRASOS-ARRTIME + WA_RELATORIO_ATRASOS-ATRASO.
                MODIFY RELATORIO_ATRASOS FROM WA_RELATORIO_ATRASOS.

              ENDIF.
            ENDLOOP.

          ENDIF.
        ENDIF.
ENDFORM.

FORM INSERE_ATRASO_VOO.

  DATA: WA_SPFLI LIKE LINE OF RELATORIO_ATRASOS,
           WA_SPFLI_ATRASOS TYPE ZSPFLI_ATRASOS.

     LOOP AT RELATORIO_ATRASOS INTO wa_spfli.
       WA_SPFLI_ATRASOS-carrid = wa_spfli-carrid.
       WA_SPFLI_ATRASOS-connid = wa_spfli-connid.
       WA_SPFLI_ATRASOS-dia_do_voo = ZSPFLI_ATRASOS-dia_do_voo.
       WA_SPFLI_ATRASOS-atraso = ZSPFLI_ATRASOS-atraso.

       INSERT ZSPFLI_ATRASOS FROM WA_SPFLI_ATRASOS .
       IF SY-SUBRC = 0.
         MESSAGE s000(ZMSG_CONTROLE_DE_VOO).
       ELSE.
         MESSAGE s001(ZMSG_CONTROLE_DE_VOO) DISPLAY LIKE 'E'.
       ENDIF.
     ENDLOOP.

ENDFORM.

FORM CONTROLA_CAMPOS.
   IF RELATORIO_ATRASOS IS NOT INITIAL .
    LOOP AT SCREEN.

      IF SCREEN-GROUP1 = 'GP1'.
        SCREEN-INPUT = 1.
        MODIFY SCREEN.
      ENDIF.

    ENDLOOP.
  ELSE.
    LOOP AT SCREEN.

      IF SCREEN-GROUP1 = 'GP1'.
        SCREEN-INPUT = 0.
        MODIFY SCREEN.
      ENDIF.

    ENDLOOP.
  ENDIF.
ENDFORM.