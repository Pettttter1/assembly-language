assume cs:code

code segment
    start:
    mov ax,0
    mov es,ax
    mov di,200h
    mov ax,cs
    mov ds,ax
    mov si,offset s
    mov cx,offset s_end-offset s
    cld
    rep movsb
    mov word ptr es:[4*7ch],200h
    mov word ptr es:[4*7ch+2],0h
    mov ax,3456
    int 7ch
    add ax,ax
    adc dx,dx
    mov ax,4c00h
    int 21h
    s:
    mul ax
    iret
    s_end:
    nop
code ends
end start