assume cs:code
data segment
    db 'conversation',0
data ends

code segment
start:
    ;安装7ch中断处理程序
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
    mov ax,data
    mov ds,ax
    mov si,0
    mov ax,0b800h
    mov es,ax
    mov di,12*160
    s:
    cmp byte ptr [si],0
    je ok
    mov al,[si]
    mov es:[di],al
    mov byte ptr es:[di+1],2
    inc si
    add di,2
    mov bx,offset s-offset ok
    int 7ch
    ok:
    mov ax,4c00h
    int 21h
    ;7ch中断处理程序
    t:
    pop ax
    add ax,bx
    push ax
    t1:
    retf

    t_end:
    nop
code ends
end start