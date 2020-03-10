
;file open macro

%macro fopen 1

mov rax,2
mov rdi,%1     ;filename
mov rsi,2      ;file opening mode 
mov rdx,0777o  ;file permission(octal number)
syscall
%endmacro

;file read macro

%macro fread 3
mov rax,0      
mov rdi,%1     ;filehandle
mov rsi,%2     ;buffer
mov rdx,%3     ;length of buffer
syscall

%endmacro

;file write macro

%macro fwrite 3
mov rax,1     
mov rdi,%1     ;filehandle
mov rsi,%2     ;buffer
mov rdx,%3     ;length of buffer
syscall

%endmacro

;file close macro

%macro fclose 1
mov rax,3
mov rdi,%1     ;filehandle
syscall
%endmacro

;file delete macro
%macro fdelete 1
mov rax,87
mov rdi,%1     ;filename
syscall
%endmacro


