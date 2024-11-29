[org 0x0100]

jmp startEnding

TheGameHasEnded:
    pushA

    call UnhookCustomISR9ForNavigationOnBoard
    
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

; drawStarting:
;     pushA

;     mov si, ScoreString
;     call findlength1
;     mov di, 2910

;     mov ax, 0xb800
;     mov es, ax
;     mov ah, 00001111b

;     loopingPrintingScore:
;     mov al, [si]
;     inc si
;     mov word [es:di], ax
;     add di, 2
;     loop loopingPrintingScore
    
;     mov di, 2924
;     mov si, ScoreString2
;     call findlength1
    
;     loopingPrintingScore2:
;         mov al, [si]
;         inc si
;         mov word [es:di], ax
;         add di, 2
;     loop loopingPrintingScore2


;     mov di, 2980
;     mov si, topOfBoardStart
;     call findlength1

;     loopingPrintingMistakes:
;         mov al, [si]
;         inc si
;         mov word [es:di], ax
;         add di, 2
;     loop loopingPrintingMistakes

;     ;==================================================================;
;     mov ah, 10001111b
;     mov al, 175
;     mov di, 3272

;     mov word [es:di], ax
;     add di, 2
;     ;==================================================================;

;     mov si, StringQuit
;     call findlength1
;     mov di, 3280
;     sub di, cx
;     sub di, 2

;     mov ah, 00001111b
;     loopingPrintingQuit:
;     mov al, [si]
;     inc si
;     mov word [es:di], ax
;     add di, 2
;     loop loopingPrintingQuit

;      ;==================================================================;
;     mov ah, 10001111b
;     mov al, 174

;     mov word [es:di], ax
;     add di, 2
;     ;==================================================================;

;     popA
; ret

startEnding:
    ; call clrScreen
    ; call drawSudokuLogo
    
    ; call drawStarting
    ; mov ax, 0x4c00
    ; int 21h