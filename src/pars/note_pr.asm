; Парсер нот для RTTTL
; Этот файл содержит только процедуры, связанные с разбором нот
public parse_notes

extrn rtttl_notes:byte, note_to_play:byte, basic_duration:word, new_duration:word
extrn basic_octave:byte, new_octave:byte, play:far, calc_pause:far, delay:far, hexadecimal:far

notes segment
    assume cs:notes, ds:notes_data
; Основная процедура для разбора нот
parse_notes proc far
    mov si, 0                  ; Установить начальную позицию в строке
parse_notes_loop:
    cmp [rtttl_notes + si], 0  ; Проверить конец строки
    je parse_notes_end         ; Если достигнут конец, выйти из цикла

    call parse_single_note     ; Разобрать одну ноту
    jmp parse_notes_loop       ; Продолжить цикл
parse_notes_end:
    ret
parse_notes endp


; Разбор одной ноты
parse_single_note proc near
	mov al, [rtttl_notes + si]
	cmp al, ','
	jne skip_comma
	inc si
skip_comma:
    call check_duration

    ; Сохранить ноту
    mov al, [rtttl_notes + si]
	cmp al, 'p'
	je parse_pause
	
	
    cmp al, 'a'                ; Проверить, является ли символ нотой
    jl invalid_note
    cmp al, 'g'
    jg invalid_note

    mov [note_to_play], al
    inc si                     ; Перейти к следующему символу
	mov [note_to_play + 1], 0
    ; Проверить на диез
    cmp [rtttl_notes + si], '#'
    jne skip_sharp
    mov al, [rtttl_notes + si]
    mov [note_to_play + 1], al
    inc si                     ; Перейти после диеза
skip_sharp:
	call check_dot
    ; Проверить октаву
    call check_octave
    call calc_pause 
    call play
    ret
parse_single_note endp

invalid_note:
    lea dx, msg_invalid_note   ; Сообщение об ошибке
    mov ah, 09h
    int 21h
    ret

parse_pause:
    call calc_pause           ; Рассчитать длительность паузы
    call delay                ; Выполнить паузу
	inc si
    ret

check_duration proc near
    cmp [rtttl_notes + si], '0'  ; Проверить, начинается ли с цифры
    jl use_basic_duration
    cmp [rtttl_notes + si], '9'
    jg use_basic_duration

    ; Если цифра, прочитать значение
    call readnumber
    mov new_duration, ax
    ret

use_basic_duration:
    mov ax, basic_duration
    mov new_duration, ax
    ret
check_duration endp

check_octave proc near
    cmp [rtttl_notes + si], '0'  ; Проверить, начинается ли с цифры
    jl use_basic_octave
    cmp [rtttl_notes + si], '9'
    jg use_basic_octave

    ; Если цифра, прочитать значение
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
    mov cl, [rtttl_notes + si]
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
    mov ax, new_duration          ; Сохранить текущую длительность в AX
check_dot_loop:
    cmp [rtttl_notes + si], '.'   ; Проверить, есть ли точка
    jne end_dot                   ; Если нет точки, выйти
    shr ax, 1                     ; Уменьшить длительность на 50%
    add new_duration, ax          ; Добавить к общей длительности
    inc si                        ; Перейти к следующему символу
    jmp check_dot_loop            ; Продолжить проверку на точки
end_dot:
    ret
check_dot endp
notes ends

notes_data segment
    msg_invalid_note db 10, 13, "ERROR: Invalid note found in RTTTL string!$"
notes_data ends

end
