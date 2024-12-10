data segment
    nums db "0123456789"  
    nl db 10   
    el db 13
    msg1 db "1.Add", 10, 13, "2.Subtract", 10, 13, "3.Multiply", 10, 13, "4.Divide", 10, 13, "5.Modulo", 10, 13, "6.Exponentiation", 10, 13, "7.LogA(B)", 10, 13, "8.rootA(B)", 10, 13, "$"
    msg2 db "Enter first number:", 10, 13, "$"
    msg3 db "Enter Second number:", 10, 13, "$"
    msg4 db "Invalid Input$"
    buf1 db 21 DUP(0)
    buf2 db 21 DUP(0)  
    buf3 db 21 DUP(0)
    var1 db 1 DUP(0)
    var2 db 1 DUP(0)
    var3 db 1 DUP(0)
ends

stack segment
    dw   128  dup(0)
ends

code segment
ASSUME DS:DATA, CS:CODE
start:
 mov ax, @DATA
 
 mov ds, ax
 mov byte ptr buf1, 21
 mov byte ptr buf2, 21
 mov byte ptr buf3, 21 
 mov byte ptr var1, 1
 mov byte ptr var2, 1
 mov byte ptr var3, 1 
 mov dx, offset msg1
 call printstr
 lea dx, buf1
 call readline
 jmp takeBufs
       
writeint:
    push dx
    mov dx, 11
    push dx
    mov dx, 0
    mov bx, 10
getDigits:
    div bx
    push dx
    mov dx, 0
    cmp ax, 0
    je popper
    jmp getDigits
popper:
   pop dx
   jmp printer
printer:
    cmp dx, 11
    je newline
    mov ah, 0Eh
    mov al, nums
    add al, dl
    int 10h
    pop dx
    jmp printer
newline:
    mov ah, 0Eh
    mov al, nl
    int 10h  
    mov al, el
    int 10h
    ret
       
writeintf:
    push dx
    mov dx, 11
    push dx
    mov dx, 0
    mov bx, 10
getDigitsf:
    div bx
    push dx
    mov dx, 0
    cmp ax, 0
    je popperf
    jmp getDigitsf
popperf:
   pop dx
   jmp printerf
printerf:
    cmp dx, 11
    je newlinef
    mov ah, 0Eh
    mov al, nums
    add al, dl
    int 10h
    pop dx
    jmp printerf
newlinef:
    mov ah, 0Eh
    mov al, nl
    int 10h  
    mov al, el
    int 10h
    call fin       
       
fin:   
    MOV AH, 4CH
    MOV AL, 01 
    INT 21H 
printstr:
    MOV AH, 09H 
    INT 21H
    ret        
readline:
    mov ah, 0Ah
    int 21h 
    call newline
    ret    
adder: 
mov al, byte ptr var1+2
dec al
add al, byte ptr var2+2
call writeintf  
subber:
mov al, byte ptr var1+2
dec al
sub al, byte ptr var2+2
call writeintf
muller:
mov al, byte ptr var1+2
dec al
mul byte ptr var2+2
call writeintf
divver:
mov al, byte ptr var1+2
dec al
div byte ptr var2+2
xor ah, ah
call writeintf

calc:
cmp byte ptr buf1+2, '1'
 je adder
 cmp byte ptr buf1+2, '2'
 je subber
 cmp byte ptr buf1+2, '3'
 je muller
 cmp byte ptr buf1+2, '4'
 je divver    
 cmp byte ptr buf1+2, '5'
 je modder
 cmp byte ptr buf1+2, '6'
 je exper
 cmp byte ptr buf1+2, '7'
 je logger
 cmp byte ptr buf1+2, '8'
 je rooter
 mov dx, offset msg4
 call printstr
 jmp fin    

modder:
mov al, byte ptr var1+2
dec al
xor dx, dx
mov bx, word ptr var2+2
div bx
mov ax, dx
call writeintf
exper:
xor ax, ax
mov al, 1
mov cl, byte ptr var2+2
mov bl, byte ptr var1+2
dec bl
cmp cl, 0
je exper3
exper2:
cmp cl, 0
je exper4
mul bl
dec cl
jmp exper2
exper3:
xor ax, ax
mov al, 1
xor cx, cx
jmp exper2 
exper4:
call writeintf

logger:
xor ax, ax
mov al, 1
mov cl, byte ptr var2+2
mov bl, byte ptr var1+2
dec bl
xor dx, dx
cmp cl, 0
je loggerz

logger2:
cmp al, cl
je logger3
jg logger3_1
mul bl
inc dl
jmp logger2

logger3_1:
dec dl
logger3:
mov al, dl
xor ah, ah
call writeintf

loggerz:
mov al, 1
call writeintf

rooter:
xor ax, ax
mov al, 2
mov cl, byte ptr var2+2
mov bl, byte ptr var1+2
dec bl
xor dx, dx
cmp bl, 0
je errory
cmp cl, 0
je rooterz

rooter2:
mov dl, al
dec bl

rootmul:
cmp bl, 0
je rootmul2
mul dl
dec bl
jmp rootmul

rootmul2:
cmp al, cl
jge rooter3
mov al, dl
inc al
mov bl, byte ptr var1+2
dec bl
jmp rooter2

errory: 
mov dx, offset msg4
 call printstr
 jmp fin  
rooter3:
cmp al, cl
je rootend_1
mov al, dl
dec al
je rootend

rootend_1:
mov al, dl
rootend:
call writeintf

rooterz:
xor ax, ax
call writeintf

takeBufs:
mov dx, offset msg2
call printstr 
lea dx, buf2
call readline
mov dx, offset msg3
call printstr 
lea dx, buf3
call readline
mov bx, 2
xor ax, ax
jmp processBuf2

calcb1:
jmp calc

processBuf2:
mov al, byte ptr buf2+1
mov byte ptr var3+2, al 

processBuf2_1:
cmp byte ptr buf2+bx, 13
je interProc
sub byte ptr buf2+bx, 48
mov cx, 1
jmp expon

proccessBuf2_2:
add byte ptr var1+2, al
dec byte ptr var3+2
inc bx
jmp processBuf2_1

     
expon:
xor ax, ax
mov al, byte ptr [buf2+bx] 


expon2:
cmp cx, word ptr var3+2
je proccessBuf2_2
push dx
mov dx, 10
mul dx
pop dx
inc cx
jmp expon2


processBuf3:
mov al, byte ptr buf3+1
mov byte ptr var3+2, al 

processBuf3_1:
cmp byte ptr buf3+bx, 13
je calcb1
sub byte ptr buf3+bx, 48
mov cx, 1
jmp expon3

proccessBuf3_2:
add byte ptr var2+2, al
dec byte ptr var3+2
inc bx
jmp processBuf3_1

     
expon3:
xor ax, ax
mov al, byte ptr [buf3+bx] 
call expon4


expon4:
cmp cx, word ptr var3+2
je proccessBuf3_2
push dx
mov dx, 10
mul dx
pop dx
inc cx
jmp expon4
      
interProc:
mov dx, 0
mov bx, 2
jmp processBuf3  
     




 

mov ax, 4c00h
int 21h 

 
ends

end start
