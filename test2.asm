[org 0x0100]
jmp start
;=========================;

	SPBeforeGeneration: dw 0

	NumbersForRow1: dw 0,2,3,4,5,6,7,0,9
	NumbersForRow2: dw 1,0,3,4,5,0,7,8,9
	NumbersForRow3: dw 1,2,0,4,0,6,7,8,9
	NumbersForRow4: dw 6,2,3,0,5,6,7,0,9
	NumbersForRow5: dw 1,2,3,4,0,6,7,8,9
	NumbersForRow6: dw 1,0,3,4,5,0,0,8,0
	NumbersForRow7: dw 1,2,3,0,5,6,0,8,9
	NumbersForRow8: dw 1,2,3,4,5,0,7,0,9
	NumbersForRow9: dw 1,2,0,4,5,0,7,8,0

	NumbersArray: dw NumbersForRow1, NumbersForRow2, NumbersForRow3, NumbersForRow4, NumbersForRow5, NumbersForRow6, NumbersForRow7, NumbersForRow8, NumbersForRow9

	currentRow: db 0
	currentCol: db 0


returnValueFromBoard:
	push bx
	push dx
	push cx

	mov al, dh		; row for multiplication
	mov bl, 18
	mul bl
	mov dh, 0
	add ax, dx
	add ax, dx
	mov bx, ax
	mov ax, [NumbersForRow1 + bx]
	pop cx
	pop dx
	pop bx
ret

isInsertable:			
	push bp
	mov bp, sp	
	push cx
	push dx

	xor cx, cx
	cmp dh, 0		; if its first row no need to check for row repitition
	jz skipRow
		dec dh
		call returnValueFromBoard
		
	skipRow:

	isInsrtableatThatPoint:
		mov ax, 1
	isNotInsrtableatThatPoint:
	mov sp, bp
	pop bp
ret 6



fillRandomFirst:
	push bp
	mov bp, sp
	pushA
	mov [SPBeforeGeneration], sp

	mov dx, 0			;dh == row, dl == col
	
	mov cx, 9



	popA
	mov sp, bp
	pop bp
ret

start:

	mov ax, 0x13
	int 10h


	mov dh, 3		; row
	mov dl, 0		; col
	call returnValueFromBoard
	
mov ax, 0x4c00 
int 21h