[org 0x0100]

jmp startStarting

drawStarting:
    pushA

    mov si, StringStart
    call findlength1
    mov di, 2950
    
    mov ax, 0xb800
    mov es, ax
    mov ah, 00001111b

    loopingPrintingStart:
    mov al, [si]
    inc si
    mov word [es:di], ax
    add di, 2
    loop loopingPrintingStart
    ;==================================;
    ; mov ah, 10001111b
    ; mov al, 174
    ; mov word [es:di], ax
    ; mov di, 2948
    ; mov al, 175
    ; mov word [es:di], ax
    ;==================================;

    mov si, StringQuit
    call findlength1
    mov di, 3280
    sub di, cx
    sub di, 2

    mov ah, 00001111b
    loopingPrintingQuit:
    mov al, [si]
    inc si
    mov word [es:di], ax
    add di, 2
    loop loopingPrintingQuit
 

    popA
ret

startStarting:
    ; mov ax, 0
    ; int 16h
    
    ; mov ax, 0x4c00
    ; int 21h