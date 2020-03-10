global _start
_start:
%include"filemacro.nasm"

global abufflen,buffer
extern procedure
section .text


%macro disp 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

pop rcx
pop rcx
pop rcx

mov [filename],rcx
fopen [filename]

cmp rax,-1h
je error

mov [filehandle],rax

fread [filehandle],buffer,bufflen
dec rax



mov [abufflen],rax

call procedure
jmp exit

error: disp emsg,emsglen

exit: mov rax,60
      mov rdi,0
      syscall
      
 
section .bss

buffer resb 50
bufflen resb 50
abufflen resb 50
filehandle resb 50
filename resb 50

section .data

emsg:db"ERROR!!CANNOT OPEN FILE",10
emsglen:equ $-emsg
