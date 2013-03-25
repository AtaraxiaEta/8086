;实验七 D/A 转换图形显示
;实验内容：使用CPU向DAC0832送一组数据，DAC0832输出数据送0809的IN0通道，调用软件模拟示波器子程序AD，该子程序控制0809，使0809输出的数据在实验微机的CRT显示器上显示相应的波形。

;E7
;D/A converter to display the waves

code segment
  assume cs:code
start:
  call TRI
  call LEV
  call SAW
  call SQR
  jmp start
;wave of triangle
TRI:
  mov AL,0H
  TR1:
  out 28H,AL  ;set DAC0832, ADC0832 autostart
  call DELAY   ;delay for D/A converting
  call AD

  inc AL
  cmp AL,04BH ;peak
  jnz TR1

  TR2:
  out 28H,AL
  call DELAY
  call AD

  dec AL
  jnz TR2
  call DELAY ;interval
RET
;wave of level
LEV:
  mov AL,05H
  LV1:
  mov CX,04BH ;width
  LV2:
  out 28H,AL
  call DELAY
  call AD
  loop LV2

  add AL,1BH  ;height of each level
  cmp AL,56H  ;total height,3 levels
  jnz LV1
  call DELAY ;interval
RET
;wave of raw
SAW:
  mov AL,00H
  SW:
  out 28H,AL
  call DELAY
  call AD

  inc AL
  cmp AL,04BH  ;peak
  jnz SW
  call DELAY ;interval
RET
;wave of square
SQR:
  mov CX,4BH
  mov AL,05H
  SQ1:
  out 28H,AL
  call DELAY
  call AD
  loop SQ1

  mov CX,4BH
  mov AL,4BH
  SQ2:
  out 28H,AL
  call DELAY
  call AD
  loop SQ2
  call DELAY ;interval
RET
DELAY:
  push CX
  mov CX,0FFH
  LP1:
  loop LP1
  pop CX
RET
;wave simulator
AD:
  push DS
  push DI
  push CS
  pop DS
  LEA DI,ADDR
  call dword ptr[DI]
  pop DI
  pop DS
RET
ADDR dw 67D0H,7000H
code ends
end start
