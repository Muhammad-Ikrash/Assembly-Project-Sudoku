[org 0x0100]
jmp start
;=========================;
%include "Bitmaps.asm"

returnValueFromBoard:		; dh --- row , dl --- col, si --- row 1 of the array to use   			will return value in ax
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
	mov ax, [si + bx]
	pop cx
	pop dx
	pop bx
ret



enterValueAtBoard:      ;dh --- row , dl --- col, si --- row 1 of the array to use , value to set in ax 
push bx
push dx
push cx
push ax
push ax			; will use late to retrieve value 

	mov al, dh		; row for multiplication
	mov bl, 18
	mul bl
	mov dh, 0
	add ax, dx
	add ax, dx
	mov bx, ax

	pop ax			; value retreived 
	mov [si + bx], ax

pop ax
pop cx
pop dx
pop bx
ret

IsInsertibleAtIndex:    ; dh --- row, dl --- col, cx --- number to check, will return 1 in ax if it is insertable 
    push dx
    push cx
    push bx
    push di
	push si
		mov si, NumbersForRow1

        mov bx, dx      ; saving value of dx
        mov dl, 0           ; column checking
        RecheckInColumnLoop:
            
            cmp bl, dl          ; using continue
            jz ColumnLoopIncrement            

                call returnValueFromBoard   ; will return value in ax
                cmp al, cl
                jz valueIsNotInsertible

        ColumnLoopIncrement:
            inc dl
            cmp dl, 9
        jnz RecheckInColumnLoop


        mov dx, bx  ; getting value of dx back
        mov dh, 0   ; checking row
        RecheckInRowLoop:

                cmp bh, dh
                jz RowLoopIncrement

                    call returnValueFromBoard
                    cmp al, cl
                    jz valueIsNotInsertible

        RowLoopIncrement:
            inc dh
            cmp dh, 9
        jnz RecheckInRowLoop

        push cx             ; saving a cx value

        mov dx, 0           ; 3x3 box checks
        mov ax, 0
        mov al, bl          ; col
        mov di, 3           ; col / 3
        div di 

        mov dx, 0
        mul di              ; col / 3 * 3
        mov cl, al

        mov dx, 0
        mov ax, 0
        mov al, bh
        div di              ; row / 3

        mov dx, 0
        mul di              ; row / 3 * 3 
        mov ch, al          

        mov dx, cx          
        pop cx				; value to insert is in cx 

        mov bx, dx          
        add bl, 3           ; col / 3 * 3 + 3
        add bh, 3           ; row / 3 * 3 + 3

        checking3x3Box:
			
			cmp bx, dx
			jz Increment3x3Box

			call returnValueFromBoard
			cmp cx, ax
			jz valueIsNotInsertible

			Increment3x3Box:	
				inc dl
				cmp dl, bl
				jnz checking3x3Box

			sub dl, 3
			inc dh
			cmp dh, bh
			jnz checking3x3Box 

	valueIsInsertible:
		mov ax, 1
		jmp exitIsInsertable

    valueIsNotInsertible:
        mov ax, 0

	exitIsInsertable:

	pop si
    pop di
    pop bx
    pop cx
    pop dx
ret

start:

	mov dl, 3
	mov dh, 3 
	mov cx, 8
	call IsInsertibleAtIndex


mov ax, 0x4c00 
int 21h