assume cs:code
stack segment stack
    dw 8 dup (0)
stack ends
data segment
    dw 0,0
data ends
code segment
    start:
    ;安装int 9中断例程
    mov ax,0
    mov es,ax
    mov di,200h
    mov ax,cs
    mov ds,ax
    mov si,offset s
    mov cx,offset s_end-offset s
    cld
    rep movsb
    ;保存原int 9中断向量
    mov ax,data
    mov ds,ax
    mov ax,es:[4*9]
    mov word ptr ds:[0],ax
    mov ax,es:[4*9+2]
    mov word ptr ds:[2],ax
    ;设置新的int 9 中断向量
    mov word ptr es:[4*9],200h
    mov word ptr es:[4*9+2],0h

    ;主程序
    main:
    mov ax,0b800h
    mov es,ax
    mov ah,'a'
    mov byte ptr es:[160*12+40*2+1],1
    s2:
    mov es:[160*12+40*2],ah
    call delay
    inc ah
    cmp ah,'z'
    jna s2
    ;恢复键盘输入
    mov ax,0
    mov es,ax
    mov ax,ds:[0]
    mov es:[4*9h],ax
    mov ax,ds:[2]
    mov es:[4*9h+2],ax

    mov ax,4c00h
    int 21h

    delay:
    push ax
    push dx
    mov dx,05h
    mov ax,0
    x1:
    sub ax,1
    sbb dx,0
    cmp ax,0
    jne x1
    cmp dx,0
    jne x1
    pop dx
    pop ax
    ret
    
    s:
    in al,60h
    pushf
    call dword ptr ds:[0]
    cmp al,3bh
    jne t
    mov si,1
    mov cx,2000
    s1:
    inc byte ptr es:[si]
    add si,2
    loop s1
    t:
    iret
    s_end:
    nop
code ends
end start