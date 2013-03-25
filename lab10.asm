;实验十 LED显示实验

;实验内容：八位数码管从左向右逐位显示0-9的循环，之后显示稳定的98765432。
;使用8255并行PA口作为段寄存器，PB口作为位寄存器。

;E10
;LED display,using 8255

code segment
 assume cs:code
start:
 mov AL,80H
 out 1BH,AL ;set 8255 mode, PA PB out

 lea DI,tab ;load effective addr of the table of the number code

 s1:
 mov CL,07FH
 mov BX,0H
 ss1:
 mov AL,CL  ;output must use Accumulator
 out 19H,AL ;select bit
 mov AL,[BX+DI]
 out 18H,AL
 call delay

 ror CL,1   ;rotate right by 1 bit, without complementary bit
 cmp CL,07FH
 jnz ss1
 inc BX
 cmp BL,0AH ;0-9
 jnz ss1

 s2:
 mov CL,0FEH
 mov BX,0002H
 ss2:
 mov AL,CL
 out 19H,AL
 mov AL,[BX+DI]
 out 18H,AL
 call sdelay
 rol CL,1
 inc BX
 cmp BL,0AH
 jnz ss2
 jmp s2

delay:
 push CX
 mov  CX,0FFFFh
 loop $
 pop  CX
ret

sdelay:
 push CX
 mov CX,0FFH
 loop $
 pop CX
ret
;table of number code
tab     db  3FH;0
 db 06H;1
 db 5BH;2
 db 4FH;3
 db 66H;4
 db 6DH;5
 db 7DH;6
 db 07H;7
 db 7FH;8
 db 6FH;9
 db 77H;A
 db 7CH;B
 db 39H;C
 db 5EH;D
 db 79H;E
 db 71H;F
code ends
 end start
