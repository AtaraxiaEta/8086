;实验8 8253定时计数器实验
;8253计数器0分别工作在方式0、方式1、方式2下，由计数器2提供时钟。调用软件模拟示波器子程序输出波形。
;Note：计数器2工作在方式3（方波发生器）下。
;图(pic #?)显示的是计数器0在方式2下的输出。

;E8
;Timer/Counter 8253

code segment
assume cs:code
start:
;Mode 0:Interrupt on Terminal Count, start counting from the initial COUNT value down to zero.
;
; Rate:input clock frequency
; OUT pin is set low after the Control Word is written
; remain low until couter reaches 0 and then OUT will be set high
; OUT will be set low when the counter is reloaded or the Control Word is written

;Mode 1:Hardware-Triggered One Shot
;
; used as monostable multivibrator. GATE input is used as trigger input.
; give an output pulse that is an integer number of clock pulses(one-shot)
; OUT will be initially high.
; OUT will go low on the CLK pulse following a trigger to begin the one-shot pulse
; remain low until the Counter reaches zero.
; OUT will then go high and remain high until the CLK pulse after the next trigger.
; can be retriggered during the pulse output

;Mode 2:Rate Generator
;
; acts as a divide-by-n counter, generates an impulse output every n clock cycles
; counting process will start the next clock cycle after COUNT is sent.
; OUT will then remain high until the counter reaches 1, and will go low for one clock pulse.
; OUT will then go high again, and the whole process repeats itself.
; when count is loaded between output pulses, the present period will not be affected.
; A new period will occur during the next count sequence.

mov AL,10110110b;command word, counter 2, mode 3
out 03H,AL ;lower byte first

mov AL,0FFH
out 02H,AL
mov AL,0FH
out 02H,AL

;mov AL,00010000b ;counter 0,mode 0
;mov AL,00010010b ;mode 1
mov AL,00010100b ;mode 2
out 03H,AL

mov AL,0FFH
out 00H,AL ;lower byte

CAL:
call AD
jmp CAL

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
ADDR DW 67D0H,7000H
code ends
end start
