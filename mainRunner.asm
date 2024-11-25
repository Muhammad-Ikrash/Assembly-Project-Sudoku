[org 0x0100]

jmp start

%include "E:\Sudoku\Bitmaps.asm"
%include "E:\Sudoku\KeyBoardISR.asm"
%include "E:\Sudoku\DrawMainScreen.asm"
%include "E:\Sudoku\StartingScreen.asm"
%include "E:\Sudoku\EndingScreen.asm"
%include "E:\Sudoku\NavigationControls.asm"

drawStartingScreen:

	call clrScreen
    call drawSudokuLogo
    
    call drawStarting
	xor ax, ax
	int 16h

ret

DrawTheMiddleScreen:
		mov ax, 0x12
		int 10h
		mov ah, 0x0b
		mov bh, 00h
		mov bl, 0		;3, 7
		int 10h

		call GenerateRandomBoard
		call FillRandomBasedOnDifficulty

		push word 50  ;	x
		push word 145 ;	y
		push word 36  ;	size
		call DrawGrid
		
		push word 0
		push word 145
		push word 50
		call drawBoardTop

		call drawNotes

		call drawNumbersInGrid

		call DrawLeftSideButtons
		call DrawRightSideButton
		call DrawBottomNumbers
		call DrawScoreCard

		call saveOriginalKeyboardISR
		call HookcustomISRforINT9ForNavigationOnBoard

ret

	start:

		call drawStartingScreen

		call DrawTheMiddleScreen	


    l:
        jmp l

		mov ax, 0x4c00
	int 21h
