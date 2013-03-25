;实验9 8259中断优先级
;实验内容 编写中断实验程序，使用8255PB口输出。IR0中断服务程序从PB口输出0FH，延时后返回主程序。IR1中断服务程序从PB口输出0F0H，延时并返回主程序。
;ICW1设置为使用优先级(使用ICW4)、不使用级联，上升沿触发。
;ICW2设置中断类型码，为所在中断向量表的起始地址（自定义中断部分）。
;ICW4设置为全嵌套方式，优先级以IR0最高，依次递减；自动结束中断返回主程序。


;E9
;Interrupt controller 8259
;IR0 ISR: using PB to output 0FH  to LEDs
;IR1 ISR: using PB to output 0F0H to LEDs

code segment
assume cs:code
start:
mov AL,80H
out 1BH,AL ;set 8255 mode:PB out

mov BX,80H ;from 80H on, can be defined by user
           ;INT vector table
;same as LEA ..
mov AX,offset ISR0
mov [BX],AX ;offset in code segment
mov AX,CS
mov [BX+2],AX;code segment addr

mov BX,80H   ;INT type code*4 is where it is in vector table
mov AX,offset ISR1
mov [BX],AX ;offset in code segment
mov AX,CS
mov [BX+2],AX;code segment addr

;each 8259 has two port, which can be selected by A0
mov AL,00010011b; D0-need ICW4, D1-no cascading, D3-up edge
out 20H,AL      ;ICW1
mov AL,00100000b;high 5 bits are INT type code, D0-D2 is auto filled by CPU
out 21H,AL      ;ICW2
mov AL,00000111b;D4-all nested,D2-master,D1-auto cli,D0-8086CPU
out 21H,AL      ;ICW4

STI       ;start interrupt
T1:  mov al,0FFH
   out 19H,AL
   jmp T1
 
;INT from IR0
ISR0:
push cx
mov cx,0FFFFH
r0:
 mov AL,0FH
 out 19H,AL    
 loop r0
pop cx
iret

;INT from IR1
ISR1:
push cx
mov cx,0FFFFH
r1:
 mov AL,0FH
 out 19H,AL    
 loop r1
pop cx
iret
code ends
end start
