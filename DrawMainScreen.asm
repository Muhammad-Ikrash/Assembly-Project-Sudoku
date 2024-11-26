[org 0x0100]

	jmp startDrawMiddle
	
	;======================================================================================================================================;
	drawVertical: ; bp + 4 -- counter, bp + 6 --- y, bp + 8 --- x, bp + 10 --- color
		push bp
		mov  bp, sp
		sub  sp, 2         ;space for counter
		pushA
		mov  ah, 0x0c
		mov  si, [bp + 4]  ; counter
		mov  di, 0
		mov  cx, [bp + 8]
		mov  dx, [bp + 6]
		mov  bh, 0
		mov  al, [bp + 10] ; color

		loopDrawVertical:
			int 10h
			inc dx  ;increment y axis
			dec si  ;decrement counter
		jnz loopDrawVertical

		popA
		mov sp, bp
		pop bp
	ret 8

	drawHorizontal: ; counter [bp + 4] --- y [bp + 6] --- x [bp + 4]
		push bp
		mov  bp, sp
		sub  sp, 2         ;space for counter
		pushA
		mov  ah, 0x0c
		mov  si, [bp + 4]  ; counter
		mov  cx, [bp + 8]  ;x
		mov  dx, [bp + 6]  ;y
		mov  bh, 0         ;page number
		mov  al, [bp + 10] ;color

		loopDrawHorizontal:
			int 10h
			inc cx  ;increment x axis
			dec si  ;decrement counter
		jnz loopDrawHorizontal
		popA
		mov sp, bp
		pop bp
	ret 8


	;======================================================================================================================================;
; NextRowInDrawingNumbers:			; it is a helper function
; 	mov di, 0
; 	add bx, 2
; setSIInDrawingNumbers:
; 	mov si, [NumbersArray + bx]
; 	add si, di
; 	mov si, [si]
; 	add di, 2
; ret

; drawNumbersInGrid:
; 	push bp
; 	mov bp, sp
; 	sub sp, 4
; 	pushA		
; 	mov word [bp - 2], 152	;x-cordinate of grid + 7
; 	mov word [bp - 4], 57 	;y-cordinate of grid + 7

; 	mov cx, 0	; row iterations 
; 	mov dx, 0	; column iterations
; 	mov bx, 0 	; row no / offset for NumbersArray

; 	mov si, [NumbersArray]
; 	; mov si, [SolutionNumbersArray]
; 	mov di, 0	;number to read in the [NumbersArray];

; 	call setSIInDrawingNumbers

; 	loopingDrawingGridNumbers:
; 		cmp si, 0
; 	jz skipPrintInDrawingNumber

; 		push word 36
; 		push word 36
; 		push word 5			; color
; 		push word [bp - 2]	; x - coordinate
; 		push word [bp - 4]	; y - coordinate
; 		call ClearABox

; 		push word NumbersBitmaps
; 		push word [bp - 2]
; 		push word [bp - 4]
; 		push word 32
; 		push word 32
; 		push word si
; 		push word 15
; 		call drawBitMap
; 	skipPrintInDrawingNumber:
; 		call setSIInDrawingNumbers
; 		add word [bp - 2], 37
; 		inc dx
; 			cmp dx, 3
; 		jnz DxIsNotThreeInDrawingNotes
; 			add word [bp - 2], 3
; 		DxIsNotThreeInDrawingNotes:
; 			cmp dx, 6
; 		jnz DxisNotSixInDrawingNotes
; 			add word [bp - 2], 3
; 		DxisNotSixInDrawingNotes:
; 			cmp dx, 9
; 		jnz IfDxIsNotNineInDrawingNumbers
; 			mov dx, 0
; 			mov word [bp - 2], 152
; 			add word [bp - 4], 37
; 			call NextRowInDrawingNumbers
; 			inc cx
; 			cmp cx, 3
; 		jnz CxIsNotThreeInDrawingNotes
; 			add word [bp - 4], 3
; 		CxIsNotThreeInDrawingNotes:
; 			cmp cx, 6
; 		jnz CxIsNotSixInDrawingNotes
; 			add word [bp - 4], 3
; 		CxIsNotSixInDrawingNotes:
; 			cmp cx, 9
; 			jz ExitDrawingNumbers
; 		IfDxIsNotNineInDrawingNumbers:
; 			jmp loopingDrawingGridNumbers
; 	ExitDrawingNumbers:

; 	popA
; 	mov sp, bp
; 	pop bp
; ret 

DrawNumberAtPosition:		;give Row in dh, col in dl, number to print in ax, bg color in bx, number color in cx
	push dx
	push ax
	push bx
	push cx
	push ax
		call pixelCalculatorFromIndex

			add ax, 1
			add dx, 1
			push word 36		;size x
			push word 36		;size y
			push word bx		; color
			push word ax 		; x coordinate
			push word dx		; y coordinate
			call ClearABox

			add dx, 2
			add ax, 2

			pop bx
			push NumbersBitmaps
			push ax
			push dx
			push word 32
			push word 32
			push word bx
			push word cx
			call drawBitMap

	pop cx
	pop bx
	pop ax
	pop dx
ret

drawNumbersInGrid:
	pushA
		xor dx, dx
		mov si, NumbersForRow1
		mov cx, 15		; number color to print
		mov bx, 7		; bg color 
		getValuesInDrawingNumbers:
			call returnValueFromBoard

			cmp ax, 0
			jz skipPrintingInDrawingNumbers

				call DrawNumberAtPosition
				
		skipPrintingInDrawingNumbers:
				inc dl
				cmp dl, 9
			jnz getValuesInDrawingNumbers
				mov dl, 0
				inc dh
				cmp dh, 9
			jnz getValuesInDrawingNumbers

	popA
ret

;=====================================================================================================================================================================;
NextRowInDrawingNotes:			; it is a helper function
	mov di, 0
	add bx, 2
setSIInDrawNotes:
	mov word [bp - 6], 16
	mov si,            [notesArray + bx]
	add si,            di
	mov si,            [si]
	add di,            2
ret


drawNotes: 
	push bp
	mov  bp,            sp
	sub  sp,            6
	mov  word [bp - 2], 153 ;x co-ordinate to print , grid starting + 8
	mov  word [bp - 4], 58  ;y co-ordinate to print , Grid Starting + 8
	mov  word [bp - 6], 16  ;size of register
	pushA
	mov  bx,            0   ; row no 
	mov  ax,            3   ; to enter next row after 3 numbers in a box
	mov  cx,            1   ; to print
	mov  dx,            0   ; counter for a single row
	mov  di,            0   ; offset for the array

	call setSIInDrawNotes
	drawAtIndexInDrawingNotes:
		shl si, 1
		jnc skipPrintInDrawingNotes
			push word bitMaps
			push word [bp - 2]
			push word [bp - 4]
			push word 8        ; size of bitmap x
			push word 8        ; size of bitmap y
			push cx
			push word 11      ;11 ; color of bitmap
			call drawBitMap
		skipPrintInDrawingNotes:
			add word [bp - 2], 11
			inc cx
			dec word [bp - 6]
			dec ax
			cmp ax,            0
			jnz IfAxIsNotZero
			sub word [bp - 2], 33 ; 
			add word [bp - 4], 11
			mov ax,            3
		IfAxIsNotZero:
			cmp  word [bp - 6], 0
			jnz  skipResettingSi
			call setSIInDrawNotes
			skipResettingSi:
			cmp  cx,            10
			jnz  IfCxIsNotTen
			add  word [bp - 2], 37
			sub  word [bp - 4], 33
			mov  cx,            1
			inc  dx
			cmp  dx,            3
			jnz  exitAddingExtraInDx1
				add word [bp - 2], 3
			exitAddingExtraInDx1:
				cmp dx, 6
			jnz exitAddingExtraInDx2
				add word [bp - 2], 3
			
			exitAddingExtraInDx2:
			cmp  dx,            9
			jnz  drawAtIndexInDrawingNotes
			mov  dx,            0
			call NextRowInDrawingNotes
			mov  word [bp - 2], 153        ; also change this , grid starting + 8
			add  word [bp - 4], 37
			cmp  bx,            6
			jnz  exitAddingExtraInBx1
				add word [bp - 4], 3
			exitAddingExtraInBx1:
				cmp bx, 12
			jnz exitAddingExtraInBx2
				add word [bp - 4], 3
			exitAddingExtraInBx2:
			cmp bx, 18
			jz  ExitDrawingNotes

		IfCxIsNotTen:
			jmp drawAtIndexInDrawingNotes
			
	ExitDrawingNotes:
	popA
	mov sp, bp
	pop bp
ret 
	
	;======================================================================================================================================;
;===============================================================================================================================================================================================;

DrawScoreCard: 
	pushA
	
	mov dh, 1
	dec dh
	mov dl, 34
	mov bx, 0
	mov ah, 02h
	int 10h          ; settings cursor at given index
	mov ah, 0x0e     ; setting for teletype output
	mov bl, 15

	mov si, ScoreString
	call PrintString
	
	mov bl, 11
	call Printscore
	
	popA
ret

;===============================================================================================================================================================================================;
drawBoardTop: ; bp + 4 --- y, bp + 6 --- x, bp + 8 difficulty
	push bp
	mov  bp, sp
	pushA

	mov ax, [bp + 4]
	mov bl, 16
	div bl
	mov dh, al
	dec dh
	mov ax, [bp + 6]
	mov bl, 8
	div bl
	mov dl, al
	inc dl
	mov bx, 0
	mov ah, 02h
	int 10h          ; settings cursor at given index
	mov ah, 0x0e     ; setting for teletype output
	mov bl, 15

	mov  si, topOfBoardStart
	call PrintString

	
	mov  si, [bp + 8]
	mov  si, [topOfBoardDifficulty + si]
	call findlength1
	shr  cx, 1
	add  dl, 21
	sub  dl, cl
	mov  ah, 02h
	int  10h
	mov  ah, 0x0e

	call PrintString

	popA
	mov sp, bp
	pop bp
ret 6
;==================================================================================================================================================================================================;
	DrawGrid: ; [bp + 4] grid size --- [bp + 6] y --- [bp + 8] x 
		push bp
		mov  bp,            sp
		sub  sp,            4
		mov  word [bp - 2], 0
		mov  word [bp - 4], 0
		pushA
		
		
		mov si,            0
		mov cx,            [bp + 6] ;x co-ordinate
		mov dx,            [bp + 8] ;y co-ordinate
		mov di,            0
		mov word [bp - 4], cx
		mov word [bp - 2], dx
		mov ax,            [bp + 4]
		mov bl,            9
		mul bl
		add ax,            22       ;total no of pixels to printc
		
		jmp drawAgain
		
		someThingIdk:
			inc di
			inc cx
			inc dx
			cmp di, 5
		jnz drawAgain
			dec cx
			dec dx
			mov di, 0
		jmp iterateNext
		
		someThingIdk2:
			inc di
			inc cx
			inc dx
			cmp di, 3
		jnz drawAgain
			dec cx
			dec dx
			mov di, 0
		jmp iterateNext
		
		drawAgain:
			push word 8       ; color 3
			push word [bp - 4]  ;x
			push dx             ;y
			push ax             ;pxl count
			call drawHorizontal
			push word 8
			push cx
			push word [bp - 2]
			push ax
			call drawVertical
				cmp si, 0
			jz someThingIdk
				cmp si, 9
			jz someThingIdk
				cmp si, 3
			jz someThingIdk2
				cmp si, 6
			jz someThingIdk2
			
			iterateNext:
			add dx, [bp + 4] ;; adding the offset
			add cx, [bp + 4]
			inc dx
			inc cx
			inc si
			cmp si, 10
			
		jnz drawAgain
		
		popA
		mov sp, bp
		pop bp
		
	ret 6
;==========================================================================================================================================================================================================================;

DrawLeftSideButtons:
	pushA

	mov di, 0
	mov si, [ButtonsYCoordinate+ di]
	add di, 2
	mov ax, [ButtonsXCoordinate]
	push ButtonsArray
	push ax
	push si
	push word 32
	push word 32
	push word 1
	push word 15
	call drawBitMap
	
	mov si, [ButtonsYCoordinate+ di]
	add di, 2
	mov ax, [ButtonsXCoordinate]
	push ButtonsArray
	push ax
	push si
	push word 32
	push word 32
	push word 2
	push word 15
	call drawBitMap

	mov si, [ButtonsYCoordinate+ di]
	add di, 2
	mov ax, [ButtonsXCoordinate]
	push ButtonsArray
	push ax
	push si
	push word 32
	push word 32
	push word 3
	push word 15
	call drawBitMap


	popA
ret

;==========================================================================================================================================================================================================================;

DrawRightSideButton:
pushA
	mov si, FrequencyXCoordinate
	mov di, FrequencyYCoordinate
	mov bx, FrequencyArray
	mov cx, 1

	loopingRightSideButtons:

	cmp word [si], 1000	;change this in case of alteration
	jnz SkipEnteringNewRowInSideButtons
		mov si, FrequencyXCoordinate
		add di, 2
	SkipEnteringNewRowInSideButtons:
		push word NumbersBitmaps
		push word [si]
		push word [di]
		push word 32
		push word 32
		push cx
		push word 11
		call drawBitMap
		
		mov ax, [di]
		add ax, 40

		cmp word [bx], 0
		jnz FreqIsNot0

			mov dx, 10
			jmp justDontHaveALableToNameThisJump
		FreqIsNot0:

			mov dx, [bx]		

		justDontHaveALableToNameThisJump:
		push word bitMaps
		push word [si]
		push word ax
		push word 8
		push word 8
		push word dx
		push word 15
		call drawBitMap
		inc cx
		add si, 2
		add bx, 2
		cmp cx, 10
		jnz loopingRightSideButtons

popA
ret
;==========================================================================================================================================================================================================================;

DrawBottomNumbers:
pushA
	mov cx, 1
	mov si, FrequencyArray
	mov bx, BottomNumbersXCoordinate
	
	loopingDrawingBottomNumbers:
	cmp word [si], 0
	jz skipPrintingBottomNumbers
		push word DummyArray
		push word [bx]
		push word [BottomNumbersYCoordinate]
		push word 32
		push word 32
		push word 1
		push word 3
		call drawBitMap

		push word NumbersBitmaps
		push word [bx]
		push word [BottomNumbersYCoordinate]
		push word 32
		push word 32
		push word cx
		push word 11
		call drawBitMap
		
	skipPrintingBottomNumbers:
		add bx, 2
		inc cx
		cmp cx, 10
		jnz loopingDrawingBottomNumbers

popA
ret

;==========================================================================================================================================================================================================================;

startDrawMiddle: