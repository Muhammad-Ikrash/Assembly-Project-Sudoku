[org 0x0100]
jmp startMainScreen

modeSelection: db 0

hookCustomISRINT9ForMainScreen:
push ax
push es

cli 

    xor ax, ax
    mov es, ax
    mov word [es:9 * 4], CustomISRINT9ForMainScreen
    mov word [es:9 * 4 + 2], cs

sti
pop es
pop ax
ret

Bracketsvalue: db 0xae, 0xaf
currentSelection: db 0

CustomISRINT9ForMainScreen:
    pushA
        mov bx, 0xb800
        mov es, bx

        in al, 0x60
        cmp al, 0x48                ; up
        jnz checkDownForMainScreen

            mov word[es:2948], 0x8FAF 
            mov word[es:2970], 0x8FAE
            mov word[es:3272], 0x0F20
            mov word[es:3282], 0x0F20
            mov byte [currentSelection], 1

        checkDownForMainScreen:
            cmp al, 0x50            ; down
            jnz checkEnterKey

                mov word[es:2948], 0x0F20
                mov word[es:2970], 0x0F20
                mov word[es:3272], 0x8FAF
                mov word[es:3282], 0x8FAE
                mov byte [currentSelection], 1

            checkEnterKey:
                ; cmp 
        mov al, 0x20
        out 0x20, al
    popA
iret

startMainScreen: