PUBLIC find_note, set_note
EXTRN msg_note_error:BYTE, note_index:BYTE, note_to_play:BYTE, note_freq:WORD, timer_freq:WORD

note_f segment
ASSUME cs:note_f

find_note proc far
    mov di, 0
    mov cx, 12
	xor bx,bx
	xor dx,dx
.find_note_loop:
    mov al, [note_index + di]
    cmp al, [note_to_play]
    jne .skip_note
    mov al, [note_index + di + 1]
    cmp al, [note_to_play + 1]
    je .note_found
.skip_note:
    add di, 2
    loop .find_note_loop
    jmp .error_note_not_found
.note_found:
    mov bx, [note_freq + di]
    ret
.error_note_not_found:
    lea dx, msg_note_error
    mov ah, 09h
    int 21h
	xor bx, bx  
	mov ah, 4ch
    int 21h	
    ret
find_note endp

set_note proc far
    mov ax, timer_freq
    mov cx, 1000
    mul cx
    div bx
    out 42h, al
    mov al, ah
    out 42h, al
    ret
set_note endp

note_f ends
end
