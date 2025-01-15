include inc\lib.inc
PUBLIC note_index, note_to_play, note_freq, msg_note_error, msg_parseErr, nutC, basic_octave, new_octave, msg_overflow
PUBLIC bpm, basic_duration, new_duration, current_duration, note_buffer, play
PUBLIC rtttl_name, file_name, line_buf, bytesRead, color_cycle, file_msg

Progr           segment
                assume  cs:Progr, ds:dane, ss:stosik
start:          mov     ax, dane
                mov     ds, ax
                assume  ds:dane
                mov     ax, stosik
                mov     ss, ax
                assume  ss:stosik
                mov     sp, offset szczyt
                
				mov ah, 0Ah
				mov dx, offset buffer_file_rd
				int 21h
				
				mov ah,09h
				lea dx,new_line
				int 21h
				
				call file_read
                call parse_rtttl
				call set_basic_octave
				
				call parse_notes                
                mov ah, 4ch
                mov al, 0
                int 21h
				ret

play proc far
				call show_disco
                call find_note
                call set_octave_note
                call set_note
                call play_sound
                call delay
                call stop_sound
                ret
play endp

Progr           ends

dane            segment
                nutC         dw 1193
                note_freq    dw 261, 277, 293, 311, 329, 349, 369, 392, 415, 440, 466, 493
                note_index   db 'c',0,'c','#','d',0,'d','#','e',0,'f',0,'f','#','g',0,'g','#','a',0, 'a', '#', 'b',  0
                
                basic_octave db 4
                new_octave db 5
                basic_duration dw 8
                new_duration dw 4
                current_duration dw 8
                bpm dw 100
                note_to_play db 2 dup(0)
                
                note_buffer db 256 dup(0)
				bytesRead dw 0
                
                msg_note_error db 10, 13, "ERROR: Note is not found!$"
                msg_overflow db 10,13, "ERROR: Overflow!$"
                msg_parseErr db 10,13, "ERROR: Parsing terminated!$"
				file_msg db "Error reading file!$"
              
				rtttl_name db 16 dup(?)
				line_buf db 256 dup(?)
				
				buffer_file_rd db 32
				file_len db ?
                file_name db 31 dup(0)
				
				color_cycle db 0
				
				new_line db 10,13,'$'
				msg_ok_1 db 10,13,"Params. OK!$"
                
dane            ends

stosik          segment
                dw    100h dup(0)
szczyt          Label word
stosik          ends

end start