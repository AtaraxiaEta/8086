;实验四 步进电机原理及应用
;实验内容：编制MCS-51程序使步进电机以5转/分的速度正转两圈，停顿3秒后，以40转/分的速度持续反转。
;注：使用定时器中断来控制延时。单片机为8032，定时器时钟为2µs。设定TH和TL初值来控制定时器计时长度（工作在16位模式），高八位TH、低八位TL，经初值*2µs时间后产生硬件中断，并自动将TF(定时器中断溢出)置1，调用中断服务程序，之后返回主程序。

;E4
;STEPPER MOTOR
;USING TIMER-1 INTERRUPT
ORG 0000H
LJMP STRT
ORG 001BH;TIMER 1 INT 001BH-0022H
LJMP TISR;TIMER INT SERVICE ROUTINE
ORG 0030H
STRT:
  MOV TMOD,#00010000b ;mode: 16bit,timer 1
  SETB TF1 ;TCON.7, force interrupt to initialize timer 1 in TISR
  MOV IE,#88H ;EA,ET1 enable global and timer 1 interrupt
  
  ;spin clockwise, 2 circles
  ;96 steps  
  MOV R1,#60H
 S1:  
  MOV A,#11H
  SS1:
  MOV R0,#08H
  MOV P1,A
  SS2:CJNE R0,#00H,$ ;wait 8 * 1/32 seconds
  RL A ;rotate left  
  DEC R1
  CJNE R1,#00H,SS1 ;loop 96 times 

 ;wait 3 seconds
  MOV R0,#60H
  WAIT: CJNE R0,#00H,WAIT
   
  ;spin counter-clockwise, continuously
  MOV A,#88H
 S2:  
  MOV P1,A
  SS3: JNB TF1,$ ;wait till INT
  RR A ;rotate right
  JMP S2
  
TISR:
;CPU will auto-clear TFx when interrupt occurs
;unlike Timer 0, need reload TL1/TH1 when INT happens
  CLR TR1 ;stop timing
  MOV TH1,#0C2H;7A12H-FFFFH:15625*2 us,timer cycle is 2 us
  MOV TL1,#0F6H;INT PER 1/32 SEC
  SETB TR1;run timer 1
  DEC R0;8 times for each step in spin clockwise 
  ;Note:DEC R0 is of no use for spin counter-clockwise
RETI
END
