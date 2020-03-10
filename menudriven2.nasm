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

mov byte[cnt1],10
mov byte[cnt2],15
mov byte[cnt3],15

disp newline,lennew
disp menu,lmenu
accept choice,2

mov al,byte[choice]
cmp al,31h
je choice1

cmp al,32h
je choice2

cmp al,33h
je choice3

choice1:
 
mov rsi,sarr
mov rdi,sarr

add rsi,09
add rdi,15

a1:
  mov al,[rsi]
  mov [rdi],al
  
  dec rsi
  dec rdi
  
  dec byte[cnt1]
  jnz a1
  
  mov rsi,sarr
  
  a2:
   mov rax,[rsi]
   
   push rsi
   call display
   pop rsi
   
   inc rsi
   dec byte[cnt2]
   jnz a2
   
   jmp menu_label
   
   
   
   
choice2:

    mov rsi,sarr
    mov rdi,sarr
    std
    add rsi,09
    add rdi,15 
    
    mov rcx,10
    rep movsb
    
    mov rsi,sarr
    
    a3:
    
    mov rax,[rsi]
    push rsi
    
    call display
    pop rsi
    inc rsi
    dec byte[cnt2]
    
    jnz a3
    
    jmp menu_label


choice3:

     mov rax,60
     mov rdi,0
     
     syscall
     
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

sarr db 01H,02H,03H,04H,05H,06H,07H,08H,09H,0AH,0BH,0CH,0DH,0EH,0FH

newline:db"",10
lennew:equ $-newline

space:db" "
lensp:equ $-space

msg1:db"This is overlapping method without string instruction",10
lenmsg1:equ $-msg1
msg2:db"This is overlapping method with using string instruction",10
lenmsg2:equ $-msg2

menu:db"1.OVERLAP WITHOUT STRING",10
     db"2.OVERLAP WITH STRING",10
     db"3.EXIT",10
     db"ENTER CHOICE:- "
     
lmenu:equ $-menu

cnt1 db 10
cnt2 db 15
cnt3 db 15

section .bss

choice resb 2

disparr resb 32
   
   
