;实验二 串行接口8251
;程序从8255PA口读并行数据，送到8251变成8251串行输出，8251自发自收（TXD引脚和RXD相连），将串行数据继续转换为并行从8255PB口输出。
code segment
assume cs:code
start:
mov AL,90H
out 1BH,AL ;start 8255
L1:
mov AL,0CFH ;asynchronous mode(X64)
out 39H,AL ;set 8251 mode

mov AL,27H;
out 39H,AL ;set 8251 command 

L2:
in AL,39H ;read 8251 status
and al,01H ;ready for transferring data
jz L2

in AL,18H ;read from 8255 PA
out 38H,AL ;send to 8251

L3:
in AL,39h ;read 8251 status
and AL,02H ;ready for transferring data
jz L3

in AL,38h ;read from serial interface 8251
out 19H,AL ;send to PB
jmp L2;
code ends
end start
