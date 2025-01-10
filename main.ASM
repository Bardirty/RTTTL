DosIntr      equ    21h
RetToDos     equ    4ch
Ok           equ    0h

include inc\lib.inc
PUBLIC note_index, note_to_play, note_freq, msg_note_error, nutC

Progr           segment
                assume  cs:Progr, ds:dane, ss:stosik
start:          mov     ax, dane
                mov     ds, ax
                assume  ds:dane
                mov     ax, stosik
                mov     ss, ax
                assume  ss:stosik
                mov     sp, offset szczyt
				
				mov [note_to_play], 'B'
				mov [note_to_play+1], 0
                call play
				
                mov ah, RetToDos
                mov al, Ok
                int DosIntr
				
				
play:
                call find_note
                call set_note
                call play_sound
                call delay
                call stop_sound
                ret
Progr           ends

dane            segment
                nutC         dw 1193
                note_freq    dw 261, 277, 293, 311, 329, 349, 369, 392, 415, 440, 466, 493
                note_index   db 'C',  0, 'C', '#', 'D',  0, 'D', '#', 'E',  0, 'F',  0, 'F', '#', 'G',  0, 'G', '#', 'A',  0, 'A', '#', 'B',  0
                index        dw 0
                msg_note_error db 10, 13, "ERROR: Note is not found!$", 0
				current_octave db 5               ; Октава по умолчанию
				note_to_play db 2 dup(0)
dane            ends

stosik          segment
                dw    100h dup(0)
szczyt          Label word
stosik          ends

end start