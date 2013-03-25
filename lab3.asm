;实验三 数码管显示
;实验内容：该程序将2位十进制数转换成十六进制数，并输出显示到数码管的低位。
;实验仪器：FD-EICE51单片机实验仿真机（启东计算机厂）
;注意事项：汇编程序只能在其自带的软件上编译，不能有多余的空行，多于四个字符的标识符，全部大写，每行不能过长。数码管采用动态轮流显示，即每次只向数码管送一个字节，根据视觉暂留和余辉效应让人感觉不到闪烁。

ORG 0000H
LJMP STRT ;neglect the INT Vector Table
ORG 0040H
STRT: 
;Dec to Hex：47d->2Fh
MOV R6,#4H
MOV R7,#7H
MOV A,R6
MOV B,#0AH
MUL AB
ADD A,R7
MOV B,#10H
DIV AB
MOV R6,A
MOV R7,B

MOV A,#02H; 
MOV DPTR,#0FF21H
MOVX @DPTR,A

MOV DPTR,#TAB
MOV A,R6
MOVC A,@A+DPTR
MOV DPTR,#0FF22H
MOVX @DPTR,A

MOV R3,#255
LP1:
DJNZ R3,LP1

MOV A,#1H
MOV DPTR,#0FF21H
MOVX @DPTR,A

MOV DPTR,#TAB
MOV A,R7
MOVC A,@A+DPTR
MOV DPTR,#0FF22H
MOVX @DPTR,A

MOV R3,# 255
LP2:
DJNZ R3,LP2

LJMP STRT

TAB:
DB 0C0H;0
DB 0F9H;1
DB 0A4H;2
DB 0B0H;3
DB 99H;4
DB 92H;5
DB 82H;6
DB 0F8H;7
DB 80H;8
DB 90H;9
DB 88H;A
DB 83H;B
DB 0C6H;C
DB 0A1H;D
DB 86H;E
DB 8EH;F
END
