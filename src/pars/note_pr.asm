public parse_notes

extrn note_to_play:byte, basic_duration:word, new_duration:word
extrn basic_octave:byte, new_octave:byte, play:far, calc_pause:far, delay:far
extrn msg_invalid_note:byte

notes segment
    assume cs:notes
	
parse_notes proc far
parse_notes_loop:
	mov al, [si]
    cmp al, '$'
    je parse_notes_end
	cmp al, ' '
    je parse_notes_end         
	cmp al, 0
    je parse_notes_end         

    call parse_single_note     
    jmp parse_notes_loop      
parse_notes_end:
    ret
parse_notes endp


parse_single_note proc near
	mov al, [si]
	cmp al, ','
	jne skip_comma
	inc si
skip_comma:
    call check_duration

    mov al, [si]
	cmp al, 'p'
	je parse_pause
	
	
    cmp al, 'a'                
    jl invalid_note
    cmp al, 'g'
    jg invalid_note

    mov [note_to_play], al
	xor dx,dx
    inc si          
	mov [note_to_play + 1], 0

	mov al, [si]
    cmp al, '#'
    jne skip_sharp
    mov [note_to_play + 1], al
    inc si
skip_sharp:
	call check_dot

    call check_octave
    call calc_pause 
    call play
    ret
parse_single_note endp

invalid_note:
    lea dx, msg_invalid_note
    mov ah, 09h
    int 21h
    ret

parse_pause:
    call calc_pause
    call delay
	inc si
    ret

check_duration proc near
    mov al, [si]
	sub al, '0'
    cmp al, 10
    jg use_basic_duration

    call readnumber
    mov new_duration, ax
    ret

use_basic_duration:
    mov ax, basic_duration
    mov new_duration, ax
    ret
check_duration endp

check_octave proc near
	mov al, [si]
	sub al, '0'
    cmp al, 10
    jnc use_basic_octave

    call readnumber
    mov new_octave, al
    ret

use_basic_octave:
    mov al, basic_octave
    mov new_octave, al
    ret
check_octave endp

readnumber proc near
    xor ax, ax
	xor cx, cx
    mov bx, 10
read_loop:
    mov cl, [si]
    cmp cl, '0'
    jl end_read
    cmp cl, '9'
    jg end_read
    sub cl, '0'
    mul bx
    add ax, cx
    inc si
    jmp read_loop
end_read:
    ret
readnumber endp

check_dot proc near
    mov ax, new_duration
check_dot_loop:
	mov bl, [si]
    cmp bl, '.'
    jne end_dot                 
    inc new_duration
    inc si                      
    jmp check_dot_loop          
end_dot:
    ret
check_dot endp
notes ends

end
