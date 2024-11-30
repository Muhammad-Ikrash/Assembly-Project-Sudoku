[org 0x0100]
jmp startNotes

hookcustomISRforINT9ForNotes:
push ax
push es

cli 

    xor ax, ax
    mov es, ax
    mov word [es:9 * 4], customISRforINT9ForNotes
    mov word [es:9 * 4 + 2], cs

sti
pop es
pop ax
ret

customISRforINT9ForNotes:
    pushA
    in al, 0x60

        cmp al, 0x31
        jnz CheckingInputNumberForNotes

            call HookcustomISRforINT9ForNavigationOnBoard


    	CheckingInputNumberForNotes:

		cmp al, 1
		jle exitEnteringNotes			

		cmp al, 0x0b
		jge exitEnteringNotes			

		mov dh, [currentRow]
		mov dl, [currentCol]
		sub al, 1

		xor cx, cx
        mov cl, al

        call setNotes

	
    exitEnteringNotes:
        mov al, 0x20
        out 0x20, al
    popA
iret


ValuestoAddInNotesPixel: dw 3, 3, 3, 14, 3, 25, 14, 3, 14, 14, 14, 25, 25, 3, 25, 14, 25 ,25

setNotes:       ; pass dx (row/col), cx -- val
pushA    
push cx
    
    call pixelCalculatorFromIndex

    add ax, 1
    add dx, 1
    dec cx
    add cx, cx

    mov bx, cx
    add bx, bx

    add ax, [ValuestoAddInNotesPixel + bx + 2]
    add dx, [ValuestoAddInNotesPixel + bx]


    pop cx
    push word bitMaps
    push ax
    push dx
    push word 8
    push word 8
    push cx
    push word 11
    call drawBitMap

popA
ret

eraseNotesAtIndex:
pushA
push cx
    
    call pixelCalculatorFromIndex

    add ax, 1
    add dx, 1
    dec cx
    add cx, cx

    mov bx, cx
    add bx, bx

    add ax, [ValuestoAddInNotesPixel + bx + 2]
    add dx, [ValuestoAddInNotesPixel + bx]


    pop cx
    push word 8
    push word 8
    push word 0         ; color 
    push ax
    push dx
    call ClearABox

popA
ret

startNotes: