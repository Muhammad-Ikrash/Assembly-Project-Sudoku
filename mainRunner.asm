[org 0x0100]

call saveOriginalKeyboardISR
call saveOriginalTimerISR
jmp start

%include "notes.asm"
%include "Bitmaps.asm"
%include "KeyBoardISR.asm"
%include "DrawMainScreen.asm"
%include "ScoreCalc.asm"
%include "StartingScreen.asm"
%include "EndingScreen.asm"
%include "NavigationControls.asm"
%include "TimerISR.asm"
%include "leftSideButtons.asm"

drawStartingScreen:

	mov ax, 0x03
	int 10h

	call clrScreen
    call drawSudokuLogo
    
    call drawStarting
	xor ax, ax
	int 16h

ret

DrawTheMiddleScreen:
		mov ax, 0x12
		int 10h

		mov ax, [ValueFromDifficulty]
		mov ax, [ValuesLeftInIndexes]
		mov dl, [currentCol]
		mov dh, [currentRow]
		call GenerateRandomBoard
		call FillRandomBasedOnDifficulty

		push word 50  ;	y
		push word 145 ;	x
		push word 36  ;	size
		call DrawGrid
		
		push word 0
		push word 145	
		push word 50
		call drawBoardTop

		call drawNumbersInGrid
		; call drawNotes
		;=====================

			; mov dl, 0
			; mov dh, 0
			; mov cx, 1
			; call setNotes
			
			; call eraseNotesAtIndex
		;===================

		
		call DrawLeftSideButtons
		call DrawRightSideButton
		call DrawBottomNumbers
		call DrawScoreCard

		call HookcustomISRforINT9ForNavigationOnBoard
		call HookTimerISR	
ret

start:

		call drawStartingScreen

	mainGameScreen:

		call DrawTheMiddleScreen	
			
		GameIsOngoing:
			
			cmp byte [topOfBoardStart + 10], 0x33
			jz endScreen

			NextCheckInGame:
				
				cmp word [ValuesLeftInIndexes], 0
				jnz GameIsOngoing


	endScreen:

		call TheGameHasEnded
		
		xor ax, ax
		int 16h
		
		jmp start	


		mov ax, 0x4c00
	int 21h
