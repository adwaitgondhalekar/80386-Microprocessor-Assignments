global _start
_start:

%include "filemacro.nasm"

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

menu_label:

disp menu,lenmenu
accept choice,02

mov al,byte[choice]

cmp al,31h
je choice1

cmp al,32h
je choice2

cmp al,33h
je choice3

cmp al,34h
je choice4

choice1:

pop rcx  ;no of arguments
pop rcx  ;program name
pop rcx  ;file name 1

mov [filename1],rcx

fopen [filename1]
cmp rax,-1h

je error


mov [filehandle1],rax

fread [filehandle1],buffer,bufflen

dec rax

mov [actual_bufflen],rax



disp msg1,lenmsg1



disp buffer,[actual_bufflen]
disp newl,newllen

jmp menu_label

choice2:

pop rcx
mov [filename2],rcx
fopen [filename2]
cmp rax,-1h
je error

mov [filehandle2],rax
fwrite [filehandle2],buffer,[actual_bufflen]
fclose [filehandle1]
fclose [filehandle2]

disp msg3,lenmsg3

jmp menu_label

choice3:
fdelete [filename2]
disp msg4,lenmsg4
jmp choice4

error:

disp emsg,lenemsg

choice4:

mov rax,60
mov rdi,0
syscall






section .data

menu:db"1.DISPLAY CONTENTS",10
     db"2.COPY CONTENTS FROM ONE FILE TO ANOTHER",10
     db"3.DELETE FILES",10
     db"4.EXIT",10
     db"ENTER YOUR CHOICE:-"

lenmenu: equ $-menu

msg1: db"Contents of first file are:",10
lenmsg1: equ $-msg1

msg3:db"Contents copied successfully",10
lenmsg3: equ $-msg3

msg4:db"FILES DELETED",10
lenmsg4:equ $-msg4

emsg:db"ERROR IN OPENING FILE!",10
lenemsg:equ $-emsg

newl:db"",10
newllen:equ $-newl

section .bss

choice resb 01
filename1 resb 50
filename2 resb 50
filehandle1 resb 50
filehandle2 resb 50
buffer resb 50
bufflen resb 50
actual_bufflen resb 50

