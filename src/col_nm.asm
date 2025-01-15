public show_disco
extrn rtttl_name:byte, color_cycle:byte

disco segment
    assume cs:disco

show_disco proc far
    mov     bx, 0B800h        ; Адрес видеопамяти для текстового режима
    mov     es, bx

    ; Рассчитать смещение для последней строки
    mov     di, 80 * 24 * 2   ; 24-я строка (25-я строка на экране, начиная с 0)

    mov     bx, offset rtttl_name ; Адрес строки имени файла
    mov     cx, 12            ; Длина строки ("TakeOnMe.txt")

    mov     al, [color_cycle] ; Загрузить текущий цвет
    mov     ah, al            ; Цвет будет одинаковым для всех букв

update_color_loop:
    mov     al, [bx]          ; Прочитать текущий символ из строки
	inc 	bx
    cmp     al, '$'           ; Проверка на конец строки
    je      update_color_done

    stosw                    ; Записать символ и атрибут (цвет)
    inc     dx               ; Перейти к следующему символу
    loop    update_color_loop

update_color_done:
    inc     color_cycle       ; Изменить цвет на следующий
    and     color_cycle, 0Fh  ; Ограничить диапазон цветов (0-15)
    ret

show_disco endp

disco ends

end
