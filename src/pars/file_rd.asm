; Экспортируемая процедура
public file_read, buffer

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
    ; Открыть файл
    lea dx, file_name
    mov ah, 3Dh              ; Функция открытия файла
    mov al, 0                ; Режим чтения
    int 21h
    jc file_error            ; Если произошла ошибка, перейти на обработку
    mov bx, ax               ; Сохранить файловый дескриптор

    ; Чтение файла
    lea dx, buffer          
    mov cx, 256              ; Размер буфера
    mov ah, 3Fh              ; Функция чтения файла
    int 21h
    jc file_error            ; Если произошла ошибка, перейти на обработку
    mov bytesRead, ax        ; Сохранить количество прочитанных байт

    ; Добавить символ '$' для вывода
    mov cx, bytesRead       
    lea si, buffer          
    add si, cx              
    mov byte ptr [si], '$'  

    ; Закрыть файл
    mov ah, 3Eh              ; Функция закрытия файла
    mov bx, bx               ; Передать файловый дескриптор
    int 21h
    jc file_error            ; Если произошла ошибка, перейти на обработку
	mov di, 0               ; Инициализация DI
    call skip_name
    call parse_params
	call parse_notes
    ret

file_error:
    ; Обработка ошибки
    mov ah, 09h             ; DOS-функция: вывести сообщение
    lea dx, error_msg       ; Указать сообщение об ошибке
    int 21h
    mov ah, 4Ch             ; Завершить программу
    mov al, 1               ; Код ошибки
    int 21h
    ret                     ; Завершить процедуру

file_read endp

parse_params:
    mov si, 0               ; Инициализация SI
parse_params_loop:
    mov al, [buffer + di]
	inc di
    cmp al, ':'              ; Найти разделитель параметров и нот
	je parse_end
    cmp si, 16              ; Проверка на переполнение
    ja parse_end
    mov [rtttl_params + si], al
    inc si
    jmp parse_params_loop    ; Продолжить обработку параметров
	ret

parse_notes:
    mov si, 0                ; Сбросить указатель для нот
parse_notes_loop:
    mov al, [buffer + di]
    inc di
    cmp al, 0                ; Проверить конец строки
    je parse_end             ; Если конец строки, завершить
    cmp si, 256              ; Проверка на переполнение
    ja parse_end
    mov [rtttl_notes + si], al
    inc si
    jmp parse_notes_loop     ; Продолжить обработку нот
parse_end:
    mov [rtttl_params + si], 0 ; Завершение параметров
    mov [rtttl_notes + si], 0  ; Завершение нот
    ret

skip_name proc near
skip_name_loop:
    cmp di, 256             ; Проверка выхода за границы буфера
    ja skip_name_done
    mov al, [buffer + di]    ; Загрузить текущий символ
	inc di
    cmp al, ':'              ; Найти первый двоеточие
    je skip_name_done        ; Если найдено, завершить
    cmp al, 0                ; Проверить конец строки
    je skip_name_done        ; Если конец строки, завершить
    jmp skip_name_loop       ; Цикл
skip_name_done:
    ret
skip_name endp





file ends

file_data segment
    buffer db 256 dup (?)       ; Буфер для чтения файла
    error_msg db "Error reading file!$"
    bytesRead dw 0              ; Количество прочитанных байт
file_data ends
end
