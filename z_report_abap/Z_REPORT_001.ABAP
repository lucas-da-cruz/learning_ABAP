REPORT Z_REPORT_001.

DATA l_color TYPE c LENGTH 1.
DATA l_step TYPE i.

WRITE 'Olá mundo'.

DO 20 TIMES.
  IF SY-index < 10.
     l_step = l_step + 1.
  ELSE.
     l_step = l_step - 1.
  ENDIF.

  IF l_color = ''.
    FORMAT COLOR 3.
    l_color = 'X'.
  ELSE.
    CLEAR l_color.
    FORMAT COLOR 4.
  ENDIF.

 SKIP 1.

  WRITE AT l_step: 'Olá'.
ENDDO.