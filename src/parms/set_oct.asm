PUBLIC set_basic_octave
EXTRN basic_octave:BYTE, new_octave:BYTE, note_freq:WORD, msg_overflow:BYTE
EXTRN nutC:WORD
set_octave segment
assume cs:set_octave

set_basic_octave proc far
    mov al, [basic_octave]       
    mov bl, [new_octave]         
    cmp al, bl               
    je .done                 

    jb .increase             
.decrease: 
	call remainder
	neg cl
    call decrease_frequencies
    mov bl, [new_octave]     
    mov [basic_octave], bl
    jmp .done

.increase:
	call remainder
    call increase_frequencies
    mov bl, [new_octave]     
    mov [basic_octave], bl

.done:
    ret
set_basic_octave endp

increase_frequencies:
    mov bl, 12               
    lea di, [note_freq]      
.inc_loop:
    mov ax, [di]             
    shl ax, cl               
    jc .overflow             
    mov [di], ax             
    add di, 2                
    dec bl
	jnz .inc_loop
    ret
.overflow:
    lea dx, msg_overflow     
    mov ah, 09h
    int 21h
    ret

decrease_frequencies:
    mov bl, 12               
    lea di, [note_freq]     
.dec_loop:
    mov ax, [di]             
    shr ax, cl               
    mov [di], ax             
    add di, 2                
    dec bl
	jnz .dec_loop
    ret
	
remainder:
	sub bl, al          
    mov cl, bl
	ret

set_octave ends
end
