; Экспортируемая процедура
public parse_rtttl, readnumber

; Входные данные
; ds:si указывает на строку формата RTTTL
; Выходные данные:
; - Параметры записываются в глобальные переменные
; - Ноты записываются в массив

extrn basic_duration:word, new_duration:word, new_octave:byte, bpm:word
extrn note_buffer:byte, note_to_play:byte
extrn rtttl_str:byte, msg_parseErr:byte
parsing segment
    assume cs:parsing

parse_rtttl proc far
    mov di, 0                  ; Указатель в строке
    call skip_to_two_dots        ; Пропустить имя мелодии
    ; Разбор параметров d=, o=, b=
    call parsesettingd
    call parsesettingo
    call parsesettingb
    ret
parse_rtttl endp

; -------------------------------
; Пропустить имя мелодии до ':'
skip_to_two_dots proc near
next_char:
    mov al, [rtttl_str + di]   ; Загрузить текущий символ
    inc di                     ; Увеличить указатель
    cmp al, ':'                ; Проверить, это ':'?
    je end_skip                ; Если да, завершить
    cmp al, 0                  ; Конец строки?
    je error_end               ; Если да, завершить с ошибкой
    jmp next_char
end_skip:
    ret
error_end:
	lea dx, msg_parseErr
	mov ah, 09h
	int 21h

    mov ah, 4ch
	int 21h
    ret
skip_to_two_dots endp

; -------------------------------
; Парсинг параметра d=<value>
parsesettingd proc near
	xor ax, ax
	mov al, [rtttl_str + di]
	mov cl, 'd'
    cmp al, cl
    jne error_end          ; Если не 'd', перейти к следующей секции
    add di, 2                  ; Пропустить "d="
    call readnumber            ; Считать число в ax
    mov basic_duration, ax   ; Сохранить в basic_duration
    ret
parsesettingd endp

; -------------------------------
; Парсинг параметра o=<value>
parsesettingo proc near
    xor ax, ax
	mov al, [rtttl_str + di]
	mov cl, 'o'
	call skiptochar
    cmp al, cl
    jne error_end          ; Если не 'd', перейти к следующей секции
    add di, 2                  ; Пропустить "d="
    call readnumber            ; Считать число в ax
    mov new_octave, al       ; Сохранить в new_octave
    ret
parsesettingo endp

; -------------------------------
; Парсинг параметра b=<value>
parsesettingb proc near
    xor ax, ax
	mov al, [rtttl_str + di]
	mov cl, 'b'
	call skiptochar
    cmp al, cl
    jne error_end          ; Если не 'd', перейти к следующей секции
    add di, 2                  ; Пропустить "d="
    call readnumber            ; Считать число в ax
    mov bpm, ax              ; Сохранить в bpm
    ret
parsesettingb endp

; -------------------------------
; Пропустить до символа
skiptochar proc near
next_char_2:
    mov al, [rtttl_str + di]   ; Загрузить символ
    cmp al, cl                 ; Проверить символ
    je found_char
	inc di
    cmp al, 0                  ; Конец строки?
    je error_end              ; Если да, завершить
    jmp next_char_2
found_char:
    ret
skiptochar endp

; -------------------------------
; Считать число из строки
readnumber proc
    xor ax, ax                 ; Очистить ax
	xor cx, cx
    mov bx, 10                 ; Основание 10

readloop:
    mov cl, [rtttl_str + di]   ; Загрузить символ
    inc di                     ; Увеличить указатель
	sub cl, '0'                ; Преобразовать ASCII в число
    cmp cl, 0                ; Проверить, это цифра?
    jc endread                 ; Если al < '0', завершить
    cmp cl, 10
    jnc endread                 ; Если al > '9', завершить
	mul bx
    add ax, cx                 ; Добавить текущую цифру
    jc overflow                ; Проверить на переполнение
    jmp readloop               ; Продолжить чтение
overflow:
    xor ax, ax                 ; Сбросить результат
endread:
    ret                        ; Возврат с результатом в ax
readnumber endp


parsing ends
end
