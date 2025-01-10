public play_sound, delay, stop_sound
Progr           segment
play_sound:
                in  al, 61h
                or  al, 00000011b
                out 61h, al
                ret

delay:
                xor dx, dx
                mov cx, 20
                mov ah, 86h
                int 15h
                ret

stop_sound:
                in  al, 61h
                and al, 11111100b
                out 61h, al
                ret
Progr           ends
end