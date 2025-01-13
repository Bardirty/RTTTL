; Экспортируемая процедура
public file_read

; Входные данные
; ds:si указывает на строку формата RTTTL
; Выходные данные:
; - Параметры записываются в глобальные переменные
; - Ноты записываются в массив
extrn rtttl_params:byte, rtttl_notes:byte, file_name:byte
file segment
    assume cs:file
	assume ds:file_data

file_read proc far
    lea dx, file_name       ; Указать имя файла
    mov ah, 3Dh             ; DOS-функция: открыть файл
    xor al, al              ; Режим: только чтение
    int 21h
    jc file_error           ; Если произошла ошибка, перейти на обработку

    mov bx, ax              ; Сохранить файловый дескриптор

    ; Чтение файла
    lea dx, buffer          ; Указать буфер для чтения
    mov cx, 256             ; Максимальное количество байт для чтения
    mov ah, 3Fh             ; DOS-функция: чтение файла
    int 21h
    jc file_error           ; Если произошла ошибка, перейти на обработку

    ; Закрыть файл
    mov ah, 3Eh             ; DOS-функция: закрыть файл
    int 21h

    ; Пропустить название мелодии
    lea si, buffer          ; Указать начало буфера
    call skip_name          ; Пропустить название

    ; Сохранить параметры
    lea di, rtttl_params    ; Указать начало параметров
parse_params:
    lodsb                   ; Загрузить байт из строки
    cmp al, ':'             ; Найти разделитель параметров и нот
    je parse_notes          ; Если найден, перейти к нотам
    stosb                   ; Сохранить байт в rtttl_params
    jmp parse_params        ; Продолжить обработку параметров

    ; Сохранить ноты
parse_notes:
    lea di, rtttl_notes     ; Указать начало нот
parse_notes_loop:
    lodsb                   ; Загрузить байт из строки
    cmp al, 0               ; Проверить конец строки
    je parse_end            ; Если конец строки, завершить
    stosb                   ; Сохранить байт в rtttl_notes
    jmp parse_notes_loop    ; Продолжить обработку нот

parse_end:
    ret

; Пропуск названия мелодии
skip_name proc near
    lodsb                   ; Загрузить первый байт
skip_name_loop:
    cmp al, ':'             ; Найти первый двоеточие
    je skip_name_done       ; Если найдено, завершить
    lodsb                   ; Продолжить загрузку байтов
    jmp skip_name_loop      ; Цикл
skip_name_done:
    ret
skip_name endp

file_error:
    ; Обработка ошибки
    mov ah, 09h             ; DOS-функция: вывести сообщение
    lea dx, error_msg       ; Указать сообщение об ошибке
    int 21h
    jmp parse_end           ; Завершить процедуру

file_read endp
file ends

file_data segment
	buffer db 256 dup (?)       ; Буфер для чтения файла
	error_msg db "Error reading file!$"
file_data ends
end
