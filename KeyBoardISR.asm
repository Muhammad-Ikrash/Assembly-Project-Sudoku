[org 0x0100]

jmp startINT9

customISRforINT9ForNavigationOnBoard:
pushA
	in al, 0x60
	mov bl, al
	forJumpingIfNumberIsNotEditable:
		mov al, bl
		cmp al, 0x48		;up
		jnz checkLeft
			dec byte [currentRow]
			cmp byte [currentRow], -1
			jnz skipMovingRowToLast
				mov byte [currentRow], 8 
			skipMovingRowToLast:
				jmp exitChecksInNavigation


		checkLeft:
		cmp al, 0x4b 		;left
		jnz checkDown
			dec byte [currentCol]
			cmp byte [currentCol], -1
			jnz skipMovingColToLast
				mov byte [currentCol], 8
			skipMovingColToLast:
				jmp exitChecksInNavigation


		checkDown:
		cmp al, 0x50		;down
		jnz checkRight
			inc byte [currentRow]
			cmp byte [currentRow], 9
			jnz skipMovingRowToStart
				mov byte [currentRow], 0
			skipMovingRowToStart:
				jmp exitChecksInNavigation


		checkRight:
		cmp al, 0x4d		;right
		jnz exitChecksInNavigation
			inc byte [currentCol]
			cmp byte [currentCol], 9
			jnz exitChecksInNavigation
				mov byte [currentCol], 0
		exitChecksInNavigation:
		
	mov dh, [currentRow]
	mov dl, [currentCol]
	mov si, NumbersUserCantEditForRow1
	call returnValueFromBoard
	cmp ax, 1
	jz forJumpingIfNumberIsNotEditable

	; call PrintOnScreenTesting
	call DrawNavigationBox

	mov al, 0x20
	out 0x20, al
	; call far [cs:OriginalISRforINT9]
	popA
iret

HookcustomISRforINT9ForNavigationOnBoard:

	push es
    push ax
    xor  ax, ax
    mov  es, ax

    cli
		mov word [es: 9 * 4], customISRforINT9ForNavigationOnBoard
		mov [es: 9 * 4 + 2],  cs
    sti

    pop ax
	pop es

ret

saveOriginalKeyboardISR:
	push es
	push ax
	cli
		xor ax, ax
		mov es, ax
		mov ax, [es: 9 * 4]
		mov [OriginalISRforINT9], ax
		mov ax, [es: 9 * 4 + 2]
		mov [OriginalISRforINT9 + 2],ax
	sti
	pop ax
	pop es
ret

PrintOnScreenTesting:
	pushA

		mov ax, 0xb800 
		mov es, ax
		mov di, 0

		mov ah, 0x07
		mov al, [currentRow]
		add al, 0x30
		mov [es:di], ax
		add di, 4
		mov al, [currentCol]
		add al, 0x30
		mov [es:di], ax

	popA
ret

pixelCalculatorFromIndex:
	push bx
	push cx

	xchg dh, dl
	mov cx, dx
	mov dx, 0
	mov ax, 0
	mov al, cl		; col pixel calculation
	mov bx, 36		
	mul bx
	add ax, 50
	
	push ax

	mov dx, 0
	mov ax, 0
	mov al, ch
	mul bx
	add ax, 145		; row pixel calculation
	
	pop dx

	mov bx, 0
	mov bl, cl
	add bl, bl
	add dx, [LinesPixelCount + bx]
	mov bl, ch
	add bl, bl
	add ax, [LinesPixelCount + bx]
	
	pop cx
	pop bx
ret

DrawNavigationBox:	; give new row/col in dh/dl
	pushA


	push word 50
	push word 145
	push word 36
	call DrawGrid

	call pixelCalculatorFromIndex

	; xchg dh, dl
	; mov cx, dx
	; mov dx, 0
	; mov ax, 0
	; mov al, cl		; col pixel calculation
	; mov bx, 36		
	; mul bx
	; add ax, 50
	
	; push ax

	; mov dx, 0
	; mov ax, 0
	; mov al, ch
	; mul bx
	; add ax, 145		; row pixel calculation
	
	; pop dx

	; mov bx, 0
	; mov bl, cl
	; add bl, bl
	; add dx, [LinesPixelCount + bx]
	; mov bl, ch
	; add bl, bl
	; add ax, [LinesPixelCount + bx]
	
		push word 11        ; color 
		push ax  			;x
		push dx             ;y
		push word 38             ;pxl count
		call drawHorizontal
		push word 11
		push ax
		push dx
		push word 38
		call drawVertical

		add ax, 37

		push word 11        ; color 3
		push ax  			;x
		push dx             ;y
		push word 38             ;pxl count
		call drawVertical

		sub ax, 37
		add dx, 37

		push word 11
		push ax
		push dx
		push word 38
		call drawHorizontal

	popA
ret

startINT9:
	; call clrScreen
	; call PrintOnScreenTesting
	; call HookcustomISRforINT9ForNavigationOnBoard
    ; jmp $
