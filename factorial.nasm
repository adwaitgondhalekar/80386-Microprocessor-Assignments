global _start
_start:

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

disp newl,lennew
disp msg,lenmsg
accept num,03
call convert

cmp al,01
ja lab1
disp msg2,lmsg2
jmp lab2

lab1:
      mov rcx,rax
      dec rcx
      
lab3:
      push rax
      dec rax
      
   cmp rax,01
   ja lab3
   
lab4:
      pop rbx
      mul rbx
      dec rcx
      jnz lab4
      
      push rax
      disp msg3,lmsg3
      pop rax
      call display
lab2: 
      mov rax,60
      mov rdi,0
      syscall
      
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
      
section .bss

num resb 02
disparr resb 02

section .data

newl:db"",10
lennew:equ $-newl

msg:db"ENTER A NUMBER",10
lenmsg:equ $-msg

msg2:db"THE FACTORIAL IS 1",10
lmsg2:equ $-msg2

msg3:db"FACTORIAL IS-",10
lmsg3:equ $-msg3
