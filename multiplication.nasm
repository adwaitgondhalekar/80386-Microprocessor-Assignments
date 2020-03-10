global _start
_start:

section .text

%macro disp 2

mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall

%endmacro

%macro accept 2

mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2

syscall
%endmacro

menu_label:

disp newl,lnewl
disp menu,lmenu
accept choice,02

mov al,byte[choice]

cmp al,31h
je choice1

cmp al,32h
je choice3

cmp al,33h
je choice3


choice1:

disp msg1,lmsg1
accept num,03

call convert

mov [no1],al

disp msg2,lmsg2
accept num,03

call convert

mov [no2],al



mov cx,0000h
mov [result],cx
;mov cx,[no2]
mov ax,[no1]
l:
add [result],ax
dec byte[no2]
jnz l
mov ax,[result]
call display

jmp menu_label



choice3:

mov rax,60
mov rdi,0
syscall



;convert procedure

convert:

mov rsi,num
mov al,[rsi]

cmp al,39h

jle a1

sub al,07h

a1:sub al,30h

rol al,04

mov bl,al

inc rsi

mov al,[rsi]
cmp al,39h

jle a2

sub al,07h

a2:sub al,30h

add al,bl

ret

display : ;procedure

mov rsi,disparr+3	 ; storing address of memory location of last position of disparr in rsi
mov rcx,4  		 ;moving value '16' in rcx as there are 16 digits in our given number

l2:

mov rdx,0 		 ; rdx is set 0 as we are using only lower byte for storing the number as our number is 16 digit rax is -64 bit i.e. 16 digits

mov rbx,10h 		 ; rbx contains the divisor hence we have set it to 10

div rbx

cmp dl,09h 		 ; for checking the obtained remainder whether it is betwn 0-9 or greater
 
jbe l1 			 ; jump below if true to label l1

add dl,07h               ; this statement will be executed if remainder > 9 and not executed if <9

l1: add dl,30h           ; this will be also executed even if previously 7 was added 

 mov [rsi],dl            ; move the remainder to memory location pointed by rsi i.e. last position of disparr

dec rsi                  ; decrement rsi as we have to move towards the first position

dec rcx                  ;decrement rcx as we have got 1 digit 

jnz l2                   ; jump if rcx not zero to label l2



mov rax,1
mov rdi,1
mov rsi,disparr
mov rdx,4
syscall
ret
















section .data

msg1:db"PLEASE ENTER FIRST 8BIT HEX NUMBER",10
lmsg1:equ $-msg1

msg2:db"PLEASE ENTER SECOND 8BIT HEX NUMBER",10
lmsg2:equ $-msg2

menu:db"1.MULTIPLY NUMBERS USING SUCCESSIVE ADDITION",10
     db"2.MULTIPLY NUMBERS USING ADD & SHIFT METHOD",10
     db"3.EXIT",10
     db"ENTER YOUR CHOICE",10
     
lmenu:equ $-menu

result dw 0000h

newl:db"",10
lnewl:equ $-newl

section .bss

choice resb 01
num resb 02
no1 resb 08
no2 resb 08
disparr resb 32
res resb 32

