global _start
_start:

section .text

mov rsi,arr  ;moving the address of 'arr' variable to 'source index register'
mov rax,[rsi] ;moving the data from memory location whose address is given in 'rsi' to rax

call display

mov rax,60
mov rdi,0

syscall

display : ;procedure

mov rsi,disparr+15 ; storing address of memory location of last position of disparr in rsi
mov rcx,16  ;moving value '16' in rcx as there are 16 digits in our given number

l2:

mov rdx,0 ; rdx is set 0 as we are using only lower byte for storing the number as our number is 16 digit rax is -64 bit i.e. 16 digits

mov rbx,10h ; rbx contains the divisor hence we have set it to 10

div rbx

cmp dl,09h ; for checking the obtained remainder whether it is betwn 0-9 or greater

jbe l1 ; jump below if true to label l1

add dl,07h ; this statement will be executed if remainder > 9 and not executed if <9

l1: add dl,30h ; this will be also executed even if previously 7 was added 

 mov [rsi],dl; move the remainder to memory location pointed by rsi i.e. last position of disparr

dec rsi ; decrement rsi as we have to move towards the first position

dec rcx ;decrement rcx as we have got 1 digit 

jnz l2 ; jump if rcx not zero to label l2

mov rax,1
mov rdi,1
mov rsi,disparr
mov rdx,16
syscall
ret

section .data
arr dq 1234567812345678h

section .bss
disparr resb 16
