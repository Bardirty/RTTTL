include inc\lib.inc
PUBLIC note_index, note_to_play, note_freq, msg_note_error, msg_parseErr, nutC, basic_octave, new_octave, msg_overflow
PUBLIC bpm, basic_duration, new_duration, current_duration, play
PUBLIC rtttl_params, rtttl_notes, file_name,hexadecimal

Progr           segment
                assume  cs:Progr, ds:dane, ss:stosik
start:          mov     ax, dane
                mov     ds, ax
                assume  ds:dane
                mov     ax, stosik
                mov     ss, ax
                assume  ss:stosik
                mov     sp, offset szczyt
                
				call file_read
				
				lea dx, rtttl_notes
				mov ax, 0900h
				int 21h
                ;;call parse_rtttl        ; Вызвать процедуру парсинга
				;;call set_basic_octave
				;;call parse_notes
                
                mov ah, 4ch
                mov al, 0
                int 21h
				ret

play proc far
                call find_note
                call set_octave_note
                call set_note
                call play_sound
                call delay
                call stop_sound
                ret
play endp

hexadecimal proc far
                mov bx, ax
                mov ah, 2
                mov cx, 4
kolejh:         mov si, 000Fh
                rol bx, 4
                and si, bx
                mov dl, hex[si]
hmin:           int 21h
                loop kolejh
                mov ax, bx
                ret
hexadecimal endp
                 
Progr           ends

dane            segment
                nutC         dw 1193
                note_freq    dw 261, 277, 293, 311, 329, 349, 369, 392, 415, 440, 466, 493
                note_index   db 'c',  0, 'c', '#', 'd',  0, 'd', '#', 'e',  0, 'f',  0, 'f', '#', 'g',  0, 'g', '#', 'a',  0, 'a', '#', 'b',  0
                
                basic_octave db 4
                new_octave db 5
                basic_duration dw 8
                new_duration dw 4
                current_duration dw 8
                bpm dw 100
                note_to_play db 2 dup(0)
                
                msg_note_error db 10, 13, "ERROR: Note is not found!$"
                msg_overflow db 10,13, "ERROR: Overflow!$"
                msg_parseErr db 10,13, "ERROR: Parsing terminated!$"
				
				file_name db "melody.txt", 0
                hex db '0123456789ABCDEF'
                
				params_length db 0
                rtttl_params db 16 dup(?)
				notes_length db 0
				rtttl_notes db 256 dup (?)
				
                
dane            ends

stosik          segment
                dw    100h dup(0)
szczyt          Label word
stosik          ends

end start