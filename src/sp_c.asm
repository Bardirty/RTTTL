public play_sound, delay, stop_sound, calc_pause, calc_pause_WND

extrn basic_duration:WORD, new_duration:WORD, current_duration:WORD, bpm:WORD

Progr           segment
play_sound:
                in  al, 61h
                or  al, 00000011b
                out 61h, al
                ret

delay:
                xor dx, dx
                mov cx, [current_duration]
                mov ah, 86h
                int 15h
                ret

stop_sound:
                in  al, 61h
                and al, 11111100b
                out 61h, al
                ret
Progr           ends

calc segment
                assume cs:calc
calc_pause proc far
                xor dx, dx          ; Обнулить DX для деления
                mov ax, 6000       ; 60000 миллисекунд в минуте
                mov bx, [bpm]
                cmp bx, 0           ; Проверить BPM
                jz .error_div_by_zero
                div bx              ; AX = 60000 / BPM

                mov bx, [basic_duration]
                cmp bx, 0           ; Проверить basic_duration
                jz .error_div_by_zero
                div bx              ; AX = результат для длительности
                mov [current_duration], ax
                ret
calc_pause endp

calc_pause_WND proc far
                xor dx, dx          ; Обнулить DX для деления
                mov ax, 6000       ; 60000 миллисекунд в минуте
                mov bx, [bpm]
                cmp bx, 0           ; Проверить BPM
                jz .error_div_by_zero
                div bx              ; AX = 60000 / BPM

                mov bx, [new_duration]
                cmp bx, 0           ; Проверить new_duration
                jz .error_div_by_zero
                div bx              ; AX = результат для длительности
                mov [current_duration], ax
                ret
calc_pause_WND endp
.error_div_by_zero:
                lea dx, msg_error_div_by_zero ; Сообщение об ошибке
                mov ah, 09h
                int 21h
                mov ah, 4Ch        ; Завершить программу
                mov al, 1          ; Код ошибки
                int 21h
calc           ends

data segment
                msg_error_div_by_zero db 10, 13, "Error: Division by zero!$", 0
data           ends
end
