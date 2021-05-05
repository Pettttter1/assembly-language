assume cs:code
data segment
    db 'conversationz',0
data ends
code segment
    start:
    ;安装中断例程
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
    mov ax,data
    mov ds,ax
    mov si,0
    int 7ch

    mov ax,4c00h
    int 21h

    s:
    mov ah,0
    mov al,[si]
    mov cx,ax
    jcxz t1
    cmp al,'a'
    jb t
    cmp al,'z'
    ja t
    and byte ptr ds:[si],11011111b
    t:
    inc si
    inc cx
    
    loop s
    t1:
    retf
    s_end:
    nop
code ends
end start