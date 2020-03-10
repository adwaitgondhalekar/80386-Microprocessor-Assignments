global _main
_main:



global procedure
extern abufflen,buffer

section .text

%macro accept 2
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro disp 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

procedure:

disp amsg,lenamsg
accept char,2
mov bl,[char]

mov rsi,buffer

  label2:
  mov al,[rsi]
  
  cmp al,0Ah
  je linec
  
  cmp al,20h
  je spacec
  
  cmp al,bl
  je charc
  
  jmp label1
  
  linec:
  inc byte[linecount]
  jmp label1
  
  spacec:
  inc byte[spacecount]
  jmp label1
  
  charc:
  inc byte[charcount]
  
  label1:
  
  inc rsi
  dec byte[abufflen]
  jnz label2
  
  disp msg1,lenmsg1
  mov rax,[linecount]
  call display
  
  disp newl,newllen
  disp msg2,lenmsg2  
  mov rax,[spacecount]
  call display
  
  disp newl,newllen
  disp msg3,lenmsg3
  mov rax,[charcount]
  call display
  
  ret
  
  display : ;procedure

mov rsi,disparr+1	 ; storing address of memory location of last position of disparr in rsi
mov rcx,2  		 ;moving value '16' in rcx as there are 16 digits in our given number

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
mov rdx,2
syscall
ret
     
section .data

msg1:db"NO OF LINES ARE",10
lenmsg1:equ $-msg1

newl:db"",10
newllen:equ $-newl

msg2:db"NO OF WHITESPACES",10
lenmsg2:equ $-msg2

msg3:db"NO OF SPECIFIC CHARACTER",10
lenmsg3:equ $-msg3

amsg:db"ENTER THE CHARACTER WHOSE COUNT YOU WANT",10
lenamsg:equ $-amsg

section .bss

char resb 02
disparr resb 04
linecount resb 02
spacecount resb 02
charcount resb 02
  
