;实验五 串行接口LED点阵显示屏
;实验原理 15×14LED点阵，汉字编码设计为下上右左7×32，须将LED显示屏逻辑上视为7×32点阵。8032串行接口工作在模式0，功能为8位移位寄存器，串行移位输出LED显示屏列选通信号。行选通由P1并行口输出，最高位为移位输出控制位，高有效，P1.0-P1.7依次控制第1到7行。
;显示过程为依次输出下上右左的四个字节的编码，再选通行(0FEH)让其显示并短暂延时。切换至下一行，即逻辑上的第二行(0FCH)时须暂时关闭显示，输出完第二行列选通后，左移行选通值使其显示，循环上述步骤，直至输出完全部七行。
;注意：不同于全部点亮，输出完每个汉字后不再保持点亮状态，需循环显示直至1秒。延时用定时器中断实现。
;E5
;Serial LED array display
;Test program

ORG 0000H
LJMP STRT
ORG 001BH
LJMP TISR
ORG 0040H
STRT:
MOV TMOD,#10H
MOV SCON,#00H ;mode 0, serve as a shift register
;display for 1 seconds, just delay for 1 seconds will do, LED is still on
SETB TF1 ;TCON.7, force interrupt to initialize timer 1 in TISR
MOV IE,#88H ;EA,ET1 enable global and timer 1 interrupt

S1:
;test for all LEDs on
MOV P1,#80H
MOV SBUF,#0FFH
JNB TI,$
CLR TI
MOV SBUF,#0FFH
JNB TI,$
CLR TI
MOV SBUF,#0FFH
JNB TI,$
CLR TI
MOV SBUF,#0FFH
JNB TI,$
CLR TI
LCALL TDEL ;display for 1 sec
;need toggle off
LCALL OFF

;display name
S2:
MOV DPTR,#ZH ;get the last name
MOV R2,#0AH ;1 seconds
LCALL DISP
LCALL OFF         ;turn off
LCALL TDEL

MOV DPTR,#BO ;get the first name
MOV R2,#0AH ;1 seconds
LCALL DISP
LCALL OFF         ;turn off
LCALL TDEL
JMP S2

HERE: JMP $

DISP:
MOV R0,#0FEH ;the lowest bit control the line 1
MOV R1,#0H   ;the offset from the table

DP1:
MOV P1,#0FFH  ;toggle off
;LCALL OFF
;row:low-high, bottom-top order, serial output

MOV A,R1  ;first byte
MOVC A,@A+DPTR
MOV SBUF,A
JNB TI,$  ;wait for end of output
CLR TI

INC R1
MOV A,R1  ;second byte
MOVC A,@A+DPTR
MOV SBUF,A
JNB TI,$
CLR TI

INC R1
MOV A,R1  ;third byte
MOVC A,@A+DPTR
MOV SBUF,A
JNB TI,$
CLR TI

INC R1
MOV A,R1  ;fourth byte
MOVC A,@A+DPTR
MOV SBUF,A
JNB TI,$
CLR TI
INC R1

MOV P1,R0 ;select the row
LCALL SDEL

;select another row
MOV A,R0
RL A
MOV R0,A
CJNE R0,#0FEH,DP1 ;till all 7 lines are displayed

CJNE R2,#00H,DISP      
RET

SDEL:
PUSH 0H
MOV R0,#0FFH
DJNZ R0,$
POP 0H
RET

OFF:
;temporarily turn off displaying when toggle lines
MOV P1,#0FFH
SDL1: JNB TF1,$;short delay 1, for 1/10 sec
RET

TDEL:
;delay for 1 second
SETB TR1;run timer 1, I think it is of no use
MOV R2,#0AH
WAIT:CJNE R2,#00H,$
RET

TISR:
;CPU will auto-clear TFx when interrupt occurs
;unlike Timer 0, need reload TL1/TH1 when INT happens
CLR TR1 ;stop timing
MOV TH1,#3CH;C350-FFFFH:50 000*2 us,timer cycle is 2 us
MOV TL1,#0AFH;INT PER 1/10 SEC
SETB TR1;run timer 1
DEC R2; 10 times for TISR as 1 seconds in total
RETI
;张
ZH:
DB 60H,7EH,00H,00H
DB 50H,02H,42H,7EH
DB 48H,42H,44H,02H
DB 54H,22H,48H,02H
DB 62H,1AH,50H,7EH
DB 41H,0EH,0FEH,40H
DB 00H,00H,0FEH,40H
;勃
BO:
DB 14H,08H,00H,10H
DB 14H,7EH,10H,10H
DB 14H,10H,10H,7CH
DB 14H,50H,10H,10H
DB 2CH,30H,7CH,0FFH
DB 44H,10H,14H,82H
DB 00H,00H,14H,7CH
END
