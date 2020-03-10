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

disp msg,len
disp gm,len1
disp name,len2

mov rax,60
mov rdi,0
syscall

section .data

gm:db "GOOD MORNING",10
len1:equ $-gm
msg:db "Hello World",10
len:equ $-msg
name:db "ADWAIT GONDHALEKAR",10
len2:equ $-name


