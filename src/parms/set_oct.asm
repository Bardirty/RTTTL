PUBLIC set_basic_octave
EXTRN basic_octave:BYTE, new_octave:BYTE, note_freq:WORD, msg_overflow:BYTE
EXTRN nutC:WORD
set_octave segment
assume cs:set_octave

set_basic_octave proc far
    mov al, [basic_octave]       ; Текущая октава
    mov bl, [new_octave]          ; Новая октава
    cmp al, bl                   ; Сравнить текущую и новую
    je .done                     ; Если равны, завершить

    jb .increase                 ; Если новая больше текущей
.decrease: 
	call remainder
	neg cl
    call decrease_frequencies    ; Уменьшить частоты
    mov bl, [new_octave]          ; Обновить текущую октаву
    mov [basic_octave], bl
    jmp .done

.increase:
	call remainder
    call increase_frequencies    ; Увеличить частоты
    mov bl, [new_octave]          ; Обновить текущую октаву
    mov [basic_octave], bl

.done:
    ret
set_basic_octave endp

; Увеличить частоты в note_freq на 2^n с проверкой переполнения
increase_frequencies:
    mov bl, 12                   ; Количество нот
    lea di, [note_freq]          ; Указатель на массив частот
.inc_loop:
    mov ax, [di]                 ; Загрузить частоту
    shl ax, cl                   ; Умножить на 2^n
    jc .overflow                 ; Проверить переполнение
    mov [di], ax                 ; Сохранить частоту
    add di, 2                    ; Перейти к следующей частоте
    dec bl
	jnz .inc_loop
    ret
.overflow:
    lea dx, msg_overflow         ; Сообщение об ошибке
    mov ah, 09h
    int 21h
    ret

; Уменьшить частоты в note_freq на 2^n
decrease_frequencies:
    mov bl, 12                   ; Количество нот
    lea di, [note_freq]          ; Указатель на массив частот
.dec_loop:
    mov ax, [di]                 ; Загрузить частоту
    shr ax, cl                   ; Разделить на 2^n
    mov [di], ax                 ; Сохранить частоту
    add di, 2                    ; Перейти к следующей частоте
    dec bl
	jnz .dec_loop
    ret
	
remainder:
	sub bl, al                   ; Вычислить разницу (current - new)
    mov cl, bl
	ret

set_octave ends
end
