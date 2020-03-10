global _start
_start:

section .text
 
%macro disp2 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

mov rsi,arr
a1: 

push rsi

mov rax,[rsi]

call display
pop rsi
add rsi,8
dec byte[cnt]
jnz a1

mov rsi,arr

a3:

bt qword[rsi],63

jc negcnt
inc byte[pcnt]
jmp next

negcnt:inc byte[ncnt]

next:
     add rsi,8
     dec byte[cnt1]
     jnz a3

disp2 space,lensp
disp2 msg,len
mov ah,00
mov al,byte[pcnt]

call display

disp2 space,lensp
disp2 msg2,len2
mov ah,00
mov al,byte[ncnt]

call display

mov rax,60
mov rdi,0
syscall

display : ;procedure

mov rsi,disparr+15 	; storing address of memory location of last position of disparr in rsi
mov rcx,16  		;moving value '16' in rcx as there are 16 digits in our given number

l2:

mov rdx,0 		; rdx is set 0 as we are using only lower byte for storing the number as our number is 16 digit rax is -64 bit i.e. 16 digits

mov rbx,10h 		; rbx contains the divisor hence we have set it to 10

div rbx

cmp dl,09h 		; for checking the obtained remainder whether it is betwn 0-9 or greater

jbe l1 			; jump below if true to label l1

add dl,07h               ; this statement will be executed if remainder > 9 and not executed if <9

l1: add dl,30h          ; this will be also executed even if previously 7 was added 

 mov [rsi],dl           ; move the remainder to memory location pointed by rsi i.e. last position of disparr

dec rsi                 ; decrement rsi as we have to move towards the first position

dec rcx                 ;decrement rcx as we have got 1 digit 

jnz l2                 ; jump if rcx not zero to label l2



mov rax,1
mov rdi,1
mov rsi,disparr
mov rdx,16
syscall
ret

section .data

arr dq 1234567812345678h,1123456712345678h,8765432187654321h,7020098097123222h,9987654309876543h
cnt db 05 
cnt1 db 05
space:db"",10
lensp:equ $-space
msg:db "POSITIVE NUMBERS",10
len:equ $-msg
msg2:db "NEGATIVE NUMBERS",10
len2:equ $-msg2

section .bss

disparr resb 32
pcnt resb 1
ncnt resb 1
