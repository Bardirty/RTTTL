; Экспортируемая процедура
public parse_note

extrn basic_duration:word, new_duration:word, basic_octave:byte, new_octave:byte, bpm:word
extrn note_to_play:byte
extrn play:far, calc_pause:far, delay:far, readnumber:far
extrn rtttl_str:byte, msg_parseErr:byte

parsing_note segment
    assume cs:parsing_note

parse_note proc far
parse_loop:
    cmp [rtttl_str + di], 0
    je end_parse          ; Завершить, если достигнут конец строки
    call check_duration
    call check_note
    jmp parse_loop
end_parse:
    ret
parse_note endp

check_duration:
    cmp [rtttl_str + di], 0
    je end_parse          ; Завершить, если конец строки
    cmp [rtttl_str + di], '0'
    jc basic_dur          ; Использовать базовую длительность
    cmp [rtttl_str + di], '9'
    jnc basic_dur
    call readnumber
    mov new_duration, ax
    ret

basic_dur:
    mov ax, [basic_duration]
    mov [new_duration], ax
    inc di                ; Увеличить указатель на строку
    ret

pause_delay:
    inc di                ; Увеличить указатель на строку
    cmp [rtttl_str + di], 0
    je end_parse          ; Завершить, если достигнут конец строки
    call calc_pause
    call delay
    ret
	
check_note:
    mov byte ptr [note_to_play + 1], 0 ; Обнулить диез
    cmp [rtttl_str + di], 0
    je end_parse          ; Завершить, если конец строки
    cmp [rtttl_str + di], 'p'
    je pause_delay
    mov al, [rtttl_str + di]
    mov [note_to_play], al
    inc di                ; Увеличить указатель
    cmp [rtttl_str + di], '#'
    jne end_check_note
    mov al, [rtttl_str + di]
    mov [note_to_play + 1], al
    inc di                ; Увеличить указатель после диеза
end_check_note:
    call check_octave     ; Убедиться, что октава обработана
    ret

check_octave:
    cmp [rtttl_str + di], 0
    je end_parse          ; Завершить, если конец строки
    cmp [rtttl_str + di], '0'
    jc basic_oct          ; Использовать базовую октаву
    cmp [rtttl_str + di], '9'
    jnc basic_oct
    call readnumber
    mov al, ah
    mov [new_octave], al
    call calc_pause
    call play
    ret
basic_oct:
    mov al, [basic_octave]
    mov [new_octave], al
    inc di                ; Увеличить указатель на строку
    ret



parsing_note ends
end
