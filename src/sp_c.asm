public play_sound, delay, stop_sound, calc_pause

extrn new_duration:WORD, current_duration:WORD, bpm:WORD
extrn msg_error_div_by_zero:byte

Progr           segment
play_sound:
                in  al, 61h
                or  al, 00000011b
                out 61h, al
                ret
stop_sound:
                in  al, 61h
                and al, 11111100b
                out 61h, al
                ret
Progr           ends

calc segment
                assume cs:calc
				
delay proc far
                xor dx, dx
                mov cx, current_duration
                mov ah, 86h
                int 15h
                ret
delay endp

calc_pause proc far
    xor dx, dx              
    mov ax, 4000            
    mov bx, bpm             

    cmp bx, 0               
    jz .error_div_by_zero
    div bx                  

    mov bx, new_duration  
    cmp bx, 0               
    jz .error_div_by_zero
    xor dx, dx              
    div bx                  

    mov current_duration, ax
    ret
.error_div_by_zero:
                lea dx, msg_error_div_by_zero
                mov ah, 09h
                int 21h
                mov ah, 4Ch        
                mov al, 1          
                int 21h
calc_pause endp

calc           ends
end
