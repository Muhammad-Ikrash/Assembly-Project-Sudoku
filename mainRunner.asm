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
%include "KeyBoardISRMainScreen.asm"
drawStartingScreen:

	mov ax, 0x03
	int 10h
	mov bx, 0xb800
	mov es, bx
	call clrScreen
    call drawStarting
    call drawSudokuLogo
	; mov word[es:2948], 0x0F20
    ; mov word[es:2970], 0x0F20
    ; mov word[es:3272], 0x8FAF
    ; mov word[es:3282], 0x8FAE
	call hookCustomISRINT9ForMainScreen
    

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
		
		call DrawLeftSideButtons
		call DrawRightSideButton
		call DrawBottomNumbers
		call DrawScoreCard

		call HookcustomISRforINT9ForNavigationOnBoard
		call HookTimerISR	
ret	

start:

		call drawStartingScreen

	StartingScreenLoop:
		
		cmp byte [modeSelection], 2
		jz exitTheGame
		jmp StartingScreenLoop

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

		exitTheGame:

		mov ax, 0x4c00
	int 21h
