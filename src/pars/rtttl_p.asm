public parse_rtttl

extrn basic_duration:word, new_octave:byte, bpm:word
extrn msg_parseErr:byte, line_buf:byte
parsing segment
    assume cs:parsing

parse_rtttl proc far
    lea si, line_buf
	
    call parsesettingd
    call parsesettingo
    call parsesettingb
    ret
parse_rtttl endp

; -------------------------------
; d=<value>
parsesettingd proc near
	xor ax, ax
	mov al, [si]
    mov cl, 'd'
	call skiptochar
    cmp al, cl
    jne error_end          
    add si, 2              
    call readnumber        
    mov basic_duration, ax 
    ret
parsesettingd endp

; -------------------------------
; o=<value>
parsesettingo proc near
    xor ax, ax
	mov al, [si]
	mov cl, 'o'
	call skiptochar
    cmp al, cl
    jne error_end          
    add si, 2             
    call readnumber          
    mov new_octave, al 
    ret
parsesettingo endp

; -------------------------------
; b=<value>
parsesettingb proc near
    xor ax, ax
	mov al, [si]
	mov cl, 'b'
	call skiptochar
    cmp al, cl
    jne error_end   
    add si, 2       
    call readnumber 
    mov bpm, ax     
    ret
parsesettingb endp

; -------------------------------
skiptochar proc near
next_char_2:
    mov al, [si]   
    cmp al, cl     
    je found_char
	inc si
    cmp al, '$'    
    je error_end   
    jmp next_char_2
found_char:
    ret
skiptochar endp

; -------------------------------
readnumber proc near
    xor ax, ax     
	xor cx, cx     
    mov bx, 10     
readloop:          
    mov cl, [si]   
    inc si         
	sub cl, '0'    
    cmp cl, 0      
    jc endread     
    cmp cl, 10     
    jnc endread    
	mul bx         
    add ax, cx     
    jc overflow    
    jmp readloop   
overflow:          
    xor ax, ax     
endread:           
    ret            
readnumber endp



error_end:
	lea dx, msg_parseErr
	mov ah, 09h
	int 21h

    mov ah, 4ch
	int 21h
    ret


parsing ends
end
