public parse_params

extrn basic_duration:word, new_octave:byte, bpm:word
extrn msg_overflow:byte, rtttl_buf:byte
parsing segment
    assume cs:parsing

parse_params proc far
    lea si, rtttl_buf
parse_loop:
    mov al, [si]           
    cmp al, 0               
    je end_parse_params_loop
	cmp al, ':'               
    je end_parse_params_loop
    cmp al, 'd'          
    je parse_setting_d
    cmp al, 'o'          
    je parse_setting_o
    cmp al, 'b'          
    je parse_setting_b
    inc si
    jmp parse_loop

end_parse_params_loop:
	inc si ; => Skip ':' sign
    ret
parse_params endp
; -------------------------------
parse_setting_d:        
    add si, 2              
    call read_number        
    mov basic_duration, ax 
    jmp parse_loop

; -------------------------------
parse_setting_o:     
    add si, 2             
    call read_number          
    mov new_octave, al 
    jmp parse_loop

; -------------------------------
parse_setting_b:
    add si, 2            
    call read_number
    mov bpm, ax          
    jmp parse_loop

; -------------------------------
read_number proc near
    xor ax, ax     
	xor cx, cx     
    mov bx, 10     
readloop:          
    mov cl, [si]            
	sub cl, '0'    
    cmp cl, 0      
    jc endread     
    cmp cl, 10     
    jnc endread    
	mul bx         
    add ax, cx 
    jc overflow
	inc si
    jmp readloop    
endread:           
    ret            
read_number endp

overflow:
	lea dx, msg_overflow
	mov ah, 09h
	int 21h

    mov ah, 4ch
	int 21h
    ret

parsing ends
end
