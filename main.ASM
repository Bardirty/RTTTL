DosIntr      equ    21h
RetToDos     equ    4ch
Ok           equ    0h

include inc\lib.inc
PUBLIC note_index, note_to_play, note_freq, msg_note_error, nutC, basic_octave, new_octave, msg_overflow
PUBLIC bpm, basic_duration, new_duration, current_duration

Progr           segment
                assume  cs:Progr, ds:dane, ss:stosik
start:          mov     ax, dane
                mov     ds, ax
                assume  ds:dane
                mov     ax, stosik
                mov     ss, ax
                assume  ss:stosik
                mov     sp, offset szczyt
                
				mov [basic_duration], 4
				mov [basic_octave], 5
				mov [bpm], 125
				
                mov [note_to_play], 'C'
                mov [note_to_play+1], 0
				mov [new_octave], 7
				mov [new_duration], 16
				call calc_pause_WND
                call play_with_new
				
				mov [new_duration], 32
				;;call calc_pause_WND
				call delay
				
				mov [note_to_play], 'A'
                mov [note_to_play+1], 0
				mov [new_octave], 6
				mov [new_duration], 8
				;;call calc_pause_WND
                call play
				
				mov [new_duration], 32
				;;call calc_pause_WND
				call delay
				
				
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
play_with_new:
				call find_note
				call set_octave_note
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
				
				
                basic_octave db 4
                new_octave db 5
				basic_duration dw 8
				new_duration dw 18
				current_duration dw 8
				bpm dw 100
                note_to_play db 2 dup(0)
				
                msg_note_error db 10, 13, "ERROR: Note is not found!$", 0
				msg_overflow db 10,13, "ERROR: Overflow!$", 0
				
dane            ends

stosik          segment
                dw    100h dup(0)
szczyt          Label word
stosik          ends

end start
