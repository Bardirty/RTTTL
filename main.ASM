DosIntr      equ    21h
RetToDos     equ    4ch
Ok           equ    0h

include inc\lib.inc
PUBLIC note_index, note_to_play, note_freq, msg_note_error, msg_parseErr, nutC, basic_octave, new_octave, msg_overflow
PUBLIC bpm, basic_duration, new_duration, current_duration, note_buffer, play
PUBLIC rtttl_str

Progr           segment
                assume  cs:Progr, ds:dane, ss:stosik
start:          mov     ax, dane
                mov     ds, ax
                assume  ds:dane
                mov     ax, stosik
                mov     ss, ax
                assume  ss:stosik
                mov     sp, offset szczyt
				
				mov ax, 0
				mov ax, [basic_duration]
				call hexadecimal
				mov ax, 0
				mov al, [new_octave]
				call hexadecimal
				mov ax, 0
				mov ax, [bpm]
				call hexadecimal
				
				
                call parse_rtttl        ; Вызвать процедуру парсинга
				
				mov ax, 0
				mov ax, [basic_duration]
				call hexadecimal
				mov ax, 0
				mov al, [new_octave]
				call hexadecimal
				mov ax, 0
				mov ax, [bpm]
				call hexadecimal
				
                call set_basic_octave
				mov ax, 0
				mov al, [basic_octave]			
				call hexadecimal
				
				call parse_note
				
				;;mov ah, RetToDos
                ;;mov al, Ok
                ;;int DosIntr
				;;ret
				
                mov [note_to_play], 'c'
                mov [note_to_play+1], 0
				
				push [basic_duration]
				pop [new_duration]				
				call calc_pause
                call play
				
				
                mov ah, RetToDos
                mov al, Ok
                int DosIntr
                
play:
                call find_note
                call set_octave_note
                call set_note
                call play_sound
                call delay
                call stop_sound
                ret

hexadecimal:
		mov bx, ax
         mov ah, 2
         mov cx, 4
kolejh:  mov si, 000Fh
         rol bx, 4
         and si, bx
         mov dl, hex[si]
hmin:    int 21h
         loop kolejh
		 mov ax, bx
         ret
		 
		 
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
                
                note_buffer db 256 dup(0)
                
                msg_note_error db 10, 13, "ERROR: Note is not found!$"
                msg_overflow db 10,13, "ERROR: Overflow!$"
				msg_parseErr db 10,13, "ERROR: Parsing terminated!$"
                
                rtttl_str db "sonic:d=8,o=5,b=125:16c7,32p,8a6,32p", 0
				
				hex db '0123456789ABCDEF'
                
dane            ends

stosik          segment
                dw    100h dup(0)
szczyt          Label word
stosik          ends

end start
