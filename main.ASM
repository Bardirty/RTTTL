include inc\lib.inc
PUBLIC note_index, note_to_play, note_freq, timer_freq, basic_octave, new_octave 
PUBLIC bpm, basic_duration, new_duration, current_duration, file_buffer, play
PUBLIC rtttl_name, file_name, rtttl_buf, bytesRead, color_cycle

public msg_note_error, msg_error_div_by_zero, msg_invalid_note, msg_overflow, file_msg, msg_invalid_note

Progr           segment
                assume  cs:Progr, ds:dane, ss:stosik
start:          mov     ax, dane
                mov     ds, ax
                assume  ds:dane
                mov     ax, stosik
                mov     ss, ax
                assume  ss:stosik
                mov     sp, offset szczyt
                
				call read_arg
				mov ah, 09h
				lea dx, new_line
				int 21h
				
				call file_read
                call parse_params				
				call set_basic_octave				
				call parse_notes           
				
                mov ah, 4ch
                mov al, 0
                int 21h
				ret

play proc far
				call check_key
				call show_disco
                call find_note
                call set_octave_note
                call set_note
                call play_sound
                call delay
                call stop_sound
                ret
play endp

read_arg proc near
				xor cx, cx
				mov cl, es:[80h]          
				cmp cl, 0                 
				je no_arguments           
				dec cl                     
				mov si, 0082h              

				mov di, offset file_name 
				add di, 6                

				xor bx, bx                
copy_loop:
				mov al, es:[si + bx]
				mov ds:[di + bx], al
				inc bx
				loop copy_loop
				mov byte ptr [di + bx], 0
				ret
no_arguments:
				lea dx, main_msg
				mov ah, 09h
				int 21h
				mov ax, 4C01h   
				int 21h
read_arg endp



check_key proc near
				mov ah, 01h
				int 16h
				jz no_key_pressed

				mov ah, 00h 
				int 16h     
				cmp al, 0Dh 
				je interrupt_music
				cmp al, 20h
				je interrupt_music
				cmp al, '+'
				je increase_bpm
				cmp al, '-'
				je decrease_bpm
				ret
interrupt_music:
				mov ax, 4c00h
				int 21h
increase_bpm:
				cmp bpm, 300
				jae no_key_pressed
				add bpm, 5
				ret
decrease_bpm:
				cmp bpm, 20
				jbe no_key_pressed
				sub bpm, 5
no_key_pressed:
				ret
check_key endp

Progr           ends

dane            segment
                timer_freq         dw 1193
                note_freq    dw 261, 277, 293, 311, 329, 349, 369, 392, 415, 440, 466, 493
                note_index   db 'c',0,'c','#','d',0,'d','#','e',0,'f',0,'f','#','g',0,'g','#','a',0,'a','#','b',0
                
                basic_octave db 4
                new_octave db 5
                basic_duration dw 8
                new_duration dw 4
                current_duration dw 8
                bpm dw 100
                note_to_play db 2 dup(0)
                
                file_buffer db 4096 dup(0)
				bytesRead dw 0
                
				
				main_msg db 10,13,"Correct using: main.exe {file_name}.txt: $"
                msg_note_error db 10, 13, "ERROR: Note is not found!$"
                msg_overflow db 10,13, "ERROR: Overflow!$"
				file_msg db "File doesn't exist$"
				msg_error_div_by_zero db 10, 13, "Error: Division by zero!$", 0
				msg_invalid_note db 10, 13, "ERROR: Invalid note found in RTTTL string!$"
              
				rtttl_name db 64 dup(?)
				rtttl_buf db 4096 dup(?)
				
                file_name db 'music/', 122 dup(0)
				
				color_cycle db 0				
				new_line db 10,13,'$'
                
dane            ends

stosik          segment
                dw    100h dup(0)
szczyt          Label word
stosik          ends

end start