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
    mov ax,0
    mov ds,ax
    mov word ptr ds:[0],200h
    mov word ptr ds:[2],0
    int 0

    mov ax,4c00h
    int 21h
    s:
    jmp short t
    db 'divide error!',0
    t:
    mov si,202h;指向数据
    mov di,0;指向屏幕
    
    t1:
    mov ax,0
    mov ds,ax
    mov cx,0
    mov cl,[si]
    jcxz t2
    mov ch,2
    mov ax,0b800h
    mov ds,ax
    mov [4*160+20+di],cx
    inc si
    add di,2
    loop t1

    t2:
    mov ax,4c00h
    int 21h
    s_end:
    nop
code ends
end start