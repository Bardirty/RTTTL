public file_read

extrn file_name:byte, rtttl_name:byte, line_buf:byte, note_buffer:byte, bytesRead:word

file segment
    assume cs:file
    assume ds:file_data

file_read proc far
    lea dx, file_name
    mov ah, 3Dh              
    mov al, 0                
    int 21h
    jc file_error            
    mov bx, ax       
	
    lea dx, note_buffer      
    mov cx, 256              
    mov ah, 3Fh              
    int 21h
    jc file_error            
    mov bytesRead, ax       

    lea si, note_buffer
    add si, bytesRead              
    mov byte ptr [si], '$'  

    mov ah, 3Eh             
    int 21h
    jc file_error  
	
    lea si, note_buffer
	lea bx, note_buffer     
    add bx, bytesRead 
	
    call skip_name
    call parse_all
    ret

file_error:
    mov ah, 09h             
    lea dx, error_msg       
    int 21h
    mov ah, 4Ch             
    mov al, 1               
    int 21h
    ret                     

file_read endp

skip_name proc near
	lea di, rtttl_name
skip_name_loop:
    cmp si, bx
    jae skip_name_done
    mov al, [si]
    inc si
    cmp al, ':'                     
    je skip_name_done
	mov [di], al
	inc di
    jmp skip_name_loop
skip_name_done:
	mov byte ptr [di], '$'   
	ret
skip_name endp

parse_all proc near
    lea di, line_buf
parse_all_loop:
    cmp si, bx
    jae parse_all_done
    mov al, [si]
    inc si
    cmp di, offset line_buf + 256
    jae parse_all_done
    mov [di], al
    inc di
    jmp parse_all_loop
parse_all_done:
	mov byte ptr [di], '$'
	mov byte ptr [di + 1], 0
    ret
parse_all endp

file ends

file_data segment              
    error_msg db "Error reading file!$"
file_data ends
end
