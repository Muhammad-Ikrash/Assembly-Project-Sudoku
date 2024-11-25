[org 0x0100]

jmp startEnding


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