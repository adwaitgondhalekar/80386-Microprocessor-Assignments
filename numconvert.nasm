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
mov byte[cnt],05

disp newline,lennew
disp menu,lmenu
disp newline,lennew


accept choice,03

mov al,byte[choice]
cmp al,31h
je choice1

cmp al,32h
je choice2

cmp al,33h
je choice3

choice1:

disp msg,lenmsg

accept num,02

call convert

mov [no1],al

accept num,03

call convert

mov [no2],al

mov ah,[no1]
mov al,[no2]

mov rsi,array
push rax
push rsi
disp msg2,len2
pop rsi
pop rax
a3: mov dx,0000h

mov bx,[rsi]
div bx

mov [rem],dx
push rsi

call display1
pop rsi

add rsi,2
mov ax,[rem]
dec byte[cnt]

jnz a3

jmp menu_label


choice2:
disp msg,lenmsg

mov rsi,array
a4:
    push rsi
    accept num,01
    call convert1
    pop rsi
    
    mov bx,[rsi]
    mul bx
    add[result],ax
    add rsi,2
    dec byte[cnt]
    jnz a4
    
    mov ax,[result]
    call display2
    
    accept num,01
    jmp menu_label
   
choice3:
mov rax,60
mov rdi,0

syscall

;convert1(bcd to hex)

convert1:

mov al,[num]
sub al,30h
ret

;display procedure(single digit)

display1: 

add al,30h

mov [temp],al

mov rax,1
mov rdi,1
mov rsi,temp
mov rdx,1
syscall
ret

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

display2 : ;procedure

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

 

menu:db "1.CONVERT HEX TO BCD",10
     db "2.CONVERT BCD TO HEX",10
     db "3.EXIT",10
     db "ENTER CHOICE",10

lmenu:equ $-menu


msg:db"ENTER A NUMBER",10
lenmsg:equ $-msg
msg2:db"YOUR BCD NUMBER IS:",10
len2:equ $-msg2
array dw 2710h,03E8h,0064h,000Ah,0001h
cnt db 05
result dw 000h
    
newline:db"",10
lennew:equ $-newline



section .bss
disparr resb 02
num resb 05
no1 resb 02
no2 resb 02
temp resb 02
rem resb 05
choice resb 02
