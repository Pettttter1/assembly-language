assume cs:code
code segment
    start:
    ;安装中断例程
    mov ax,0
    mov es,ax
    mov di,200h
    mov ax,cs
    mov ds,ax
    mov si,offset t
    mov cx,offset t_end-offset t
    cld
    rep movsb
    mov word ptr es:[4*7ch],200h
    mov word ptr es:[4*7ch+2],0h
    ;主程序
    mov ax,0b800h
    mov es,ax
    mov di,160*12
    mov bx,offset s-offset se
    mov cx,80
    s:
    mov byte ptr es:[di],'!'
    mov byte ptr es:[di+1],2
    add di,2
    int 7ch
    se:
    nop
    mov ax,4c00h
    int 21h

    t:
    dec cx
    jcxz t1
    pop ax
    add ax,bx
    push ax
    t1:
    iret
    t_end:
    nop
code ends
end start