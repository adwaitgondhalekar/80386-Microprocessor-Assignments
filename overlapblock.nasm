global _start:
_start:

section .data

sarr db 01H,02H,03H,04H,05H,06H,07H,08H,09H,10H
darr db 00H,00H,00H,00H,00H,00H,00H,00H,00H,00H
darr1 db 00H,00H,00H,00H,00H,00H,00H,00H,00H,00H
newline:db"",10
lennew:equ $-newline
space:db" "
lensp:equ $-space
msg1:db"This is non overlapping method without string instruction",10
lenmsg1:equ $-msg1
msg2:db"This is overlapping method with using string instruction",10
lenmsg2:equ $-msg2

cnt1 db 10
cnt2 db 10
cnt3 db 10

section .bss

disparr resb 32

section .text


%macro disp2 2

mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro


mov rsi,sarr         ;pointing the source array by rsi
mov rdi,darr         ;pointing the destination array by rdi

l3:
  mov al,[rsi]       ;moving the 1st element of source array to al(al's size=8bits),rsi points to source array
  
  
  mov [rdi],al       ;moving the same element from al to destination array 

  inc rsi            ;moving on to second element
                   
  inc rdi            ;moving to second slot in destination array
             
  dec byte[cnt1]     ;decrement counter 1(respresenting no of elements in src array)

  jnz l3             ;jump to label l3 to again copy remaining elements to destination array one by one

;to display destination array

mov rsi,darr             ;pointing the dest array by rsi

   push rsi              ;push value of rsi 
   disp2 msg1,lenmsg1    ;display message 
   pop rsi
   
l4:
   push rsi
   disp2 space,lensp
   pop rsi
   mov al,[rsi]
   push rsi
  
   call display
   pop rsi
   inc rsi
  
   dec byte[cnt2]
   jnz l4
   
   ; for displaying destination array using overlapping method


   mov rsi,sarr
   mov rdi,darr1

   mov rcx,10             ;10 digits in source array
  
   cld                    ;clear direction flag
   
   rep movsb

   mov rsi,darr1
   push rsi
   disp2 newline,lennew
   disp2 msg2,lenmsg2
   pop rsi


   l5:
   push rsi
   disp2 space,lensp
   pop rsi
   mov al,[rsi]
   push rsi
  
   call display
   pop rsi
   inc rsi
  
   dec byte[cnt3]
   jnz l5
   
   

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
