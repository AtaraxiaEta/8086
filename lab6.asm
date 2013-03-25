;实验六 D/A、A/D转换
;程序向DAC0832循环送00H..0FFH,DAC0832输出模拟量送ADC0809的IN0通道，0809输出的数字量经由系统总线读入CPU，再经8255的PB口驱动L0-L7指示灯显示。
code segment
assume cs:code
start:
mov AL,90H
out 1BH,AL ;start 8255 :A in B out 
mov BL,00H ;start sending of 00H..0FFH

L1:
mov AL,BL
out 28h,AL ;start 0832
out 30h,AL ;start 0809, any value can do

L2:
in AL,18H ;read 8255, the signal from EOC
and AL,01H ;b) if converting is over
jnz L2

in AL,30h ;read from 0809
out 19H,AL ;8255 PB out
inc BL

mov CX,0FFFFh
DELAY:
loop DELAY ;necessary for displaying a continuous data on LEDs

jmp L1
code ends
end start
