[org 0x0100]
jmp startEnding

TheGameHasEnded:
    pushA

    call UnhookCustomISR9ForNavigationOnBoard
    call UnhookTimerISR
    
    xor dx, dx
    mov ax, 0

    loopingClearingBoards:

        mov si, NumbersForRow1
        call enterValueAtBoard
        mov si, SolutionNumbersForRow1
        call enterValueAtBoard
        mov si, NumbersUserCantEditForRow1
        call enterValueAtBoard

        inc dl
        cmp dl, 9
    jnz loopingClearingBoards

        mov dl, 0
        inc dh
        cmp dh, 9
    jnz loopingClearingBoards

    mov word [ValuesLeftInIndexes], 80  
    mov byte [topOfBoardStart + 10], 0x30       ; mistakecount
    mov byte [TimerCount], 0x30
    mov byte [TimerCount + 2], 0x30
    mov byte [TimerCount + 3], 0x30
    mov byte [HintCount], 3
    
    mov cx, 9
    mov bx, 0
    
    resettingTheFrequencies:
        mov word [FrequencyArray + bx], 0
        add bx,2 
    loop resettingTheFrequencies
    
	
    mov cl, 3           ; width of line
    mov ch, 2

        mov ax, 160
        mov dx, 80

        push word 320
        push word 240
        push word 0
        push word ax
        push word dx
        call ClearABox

loopVerticalPrintingInEndingGame:
        push word 15        ; color
        push ax
        push dx
        push word 240
        call drawVertical

            add ax, 1
            dec cl
            cmp cl ,0
        jnz loopVerticalPrintingInEndingGame

            add ax, 314
            mov cl, 3
            dec ch
            cmp ch, 0

        jnz loopVerticalPrintingInEndingGame


    mov cl, 3       ; width of line 
    mov ch, 2

    mov ax, 160
    mov dx, 80

    loopHorizontalPrintingInEndingGame:

            push word 15        ; color
            push ax
            push dx
            push word 320
            call drawHorizontal

            add dx, 1
            dec cl
            cmp cl, 0
        jnz loopHorizontalPrintingInEndingGame

            add dx, 234
            mov cl, 3
            dec ch
            cmp ch, 0
        
        jnz loopHorizontalPrintingInEndingGame
        


    popA
ret
; have 40 col , 15 rows

printingOnEndingScreen:
    

ret

gameOver: db 'Game Over', 1
time: db 'Time : ', 1
StringExit: db 'Press Any Key To Continue', 1

startEnding: