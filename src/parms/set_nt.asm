PUBLIC set_octave_note
EXTRN basic_octave:BYTE, new_octave:BYTE, msg_overflow:BYTE
set_new_note segment
assume cs:set_new_note

set_octave_note proc far
	mov dx, bx
	xor bx,bx
    mov al, [basic_octave]       ; Текущая октава
    mov bl, [new_octave]          ; Новая октава
    cmp al, bl                   ; Сравнить текущую и новую
    je .done                     ; Если равны, завершить

    jb .increase                 ; Если новая больше текущей
.decrease: 
	call remainder
	neg cl
    call decrease_frequencies
    jmp .done

.increase:
	call remainder
    call increase_frequencies    ; Увеличить частоты
.done:
	mov bx,dx
    ret
set_octave_note endp

; Увеличить частоты в note_freq на 2^n с проверкой переполнения
increase_frequencies:
    shl dx, cl                   ; Умножить на 2^n
    jc .overflow
    ret
.overflow:
    lea dx, msg_overflow         ; Сообщение об ошибке
    mov ah, 09h
    int 21h
    ret

; Уменьшить частоты в note_freq на 2^n
decrease_frequencies:
    shr dx, cl
    ret
	
remainder:
	sub bl, al                   ; Вычислить разницу (current - new)
    mov cl, bl
	ret

set_new_note ends
end
