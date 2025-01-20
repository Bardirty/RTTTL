PUBLIC set_octave_note
EXTRN basic_octave:BYTE, new_octave:BYTE, msg_overflow:BYTE
set_new_note segment
assume cs:set_new_note

set_octave_note proc far
	mov dx, bx
	xor bx,bx
    mov al, basic_octave
    mov bl, new_octave         
    cmp al, bl                   
    je .done                     

    jb .increase                 
.decrease: 
	call remainder
	neg cl
    call decrease_frequencies
    jmp .done

.increase:
	call remainder
    call increase_frequencies
.done:
	mov bx,dx
    ret
set_octave_note endp

increase_frequencies:
    shl dx, cl                   
    jc .overflow
    ret
.overflow:
    lea dx, msg_overflow
    mov ah, 09h
    int 21h
    ret

decrease_frequencies:
    shr dx, cl
    ret
	
remainder:
	sub bl, al
    mov cl, bl
	ret

set_new_note ends
end
