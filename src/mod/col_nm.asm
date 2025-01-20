public show_disco
extrn rtttl_name:byte, color_cycle:byte

disco segment
    assume cs:disco

show_disco proc far
    mov     bx, 0B800h
    mov     es, bx

    mov     di, 80 * 24 * 2

    mov     bx, offset rtttl_name
    mov     cx, 12

    mov     al, [color_cycle]
    mov     ah, al

update_color_loop:
    mov     al, [bx]
	inc 	bx
    cmp     al, '$'
    je      update_color_done

    stosw
    inc     dx               
    loop    update_color_loop

update_color_done:
    inc     color_cycle       
    and     color_cycle, 0Fh  
    ret

show_disco endp

disco ends

end
