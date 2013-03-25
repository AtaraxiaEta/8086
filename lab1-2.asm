;lab 1.3 存储器
CODE SEGMENT
ASSUME CS:CODE
START:
MOV AX,0000h
MOV DS,AX
MOV BX,8000h
MOV CL,41H ;a:61H, 0:30H

L1:
MOV [BX],CL
CMP CL,5BH ;CL reaches Z
JZ L2
INC CL
CMP BX,80ffh ;reaches the end of storage
JZ exit
INC BX
JMP L1

L2:
MOV CL,41H ;reintial with A
JMP L1

exit:
;RET ;HLT
mov al,04h
out 08h,al ;command register, close 8237
out 0dh,al ;clear all

mov al,00
out 20h,al
mov al,80h ;base address 8000h
out 20h,al ;to channel 0

mov al,0ffh
out 21h,al
mov al,82h ;base address 8200h
out 21h,al

mov al,0ffh
out 23h,al

mov al,98h
out 2bh,al ;channel 0 mode

mov al,95h
out 2bh,al ;channel 1 mode

mov al,0ch
out 28h,al ;command register

mov al,04h
out 29h,al ;seng REQ

l4:
in al,28h
and al,01h
jnz l4

hlt
CODE ENDS
END START

;lab 1.4 8237 DMA控制器
code segment
assume cs:code
start:
mov ax,0000h
mov ds,ax ;set ds

;set 8000h to 80ffh in memory using E3
mov bx,8000h
mov cl,41h ;a:61H, 0:30H A:31h

l1:
mov [bx],cl
cmp cl,5bh ;cl reaches Z
jz l2
inc cl
cmp bx,80ffh ;reaches the end of memory
jz l3
inc bx
jmp l1

l2:
mov cl,41h ;re-initial with a
jmp l1

l3:
mov al,04h
out 28h,al ;command register, close 8237
out 2dh,al ;reset all

mov al,00h
out 20h,al ;base address
mov al,80h ;set 8000h
out 20h,al ;to channel 0

mov al,00h
out 22h,al ;base address register
mov al,82h ;set 8200h
out 22h,al ;to channel 1

mov al,0ffh
out 21h,al ;bytes count register
mov al,00h ;set 00ff
out 21h,al ;to channel 0

mov al,0ffh
out 23h,al ;bytes count register
mov al,00h ;set 00ff
out 23h,al ;to channel 1

mov al,98h ;d1d0(00)-channel d7d6(10)-mode d5(0)-address
out 2bh,al ;channel 0 mode, block increment

mov al,95h ;d1d0(01)
out 2bh,al ;channel 1 mode, block increment

mov al,81h ;d7d6(10),DACK high,DREQ low d0(1)allow memory to memory
out 28h,al ;command register

mov al,0ch ;d1d0(00), mask 0,1, forbidden DREQ from this channel
out 2fh,al ;master mask register

mov al,04h ;d2(1):set, d1d0(00) channel 0
out 29h,al ;request register, auto HRQ

exit:
HLT

code ends
end start
