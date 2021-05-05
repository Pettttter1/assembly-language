assume cs:code
stack segment stack
    dw 8 dup (0)
code segment
start:
    mov di,200h
    mov si,37h;中断处理程序的代码偏移
    mov cx,4eh;中断处理程序长度
    ;安装中断处理程序s
    t:
    mov ax,cs
    mov ds,ax
    mov bx,[si]
    mov ax,0
    mov ds,ax
    mov [di],bx
    inc di
    inc si
    loop t

    ;设置中断向量表
    mov ax,0
    mov ds,ax
    mov bx,0
    mov word ptr [bx],200h
    mov word ptr [2+bx],0
    mov ax,1000h
    mov bh,1
    div bh
    mov ax,4c00h
    int 21h

    s:
    mov ax,0b800h
    mov ds,ax
    mov dh,2
    mov si,520
    mov dl,'O'
    mov [si],dx
    add si,2
    mov dl,'v'
    mov [si],dx
    add si,2
    mov dl,'e'
    mov [si],dx
    add si,2
    mov dl,'r'
    mov [si],dx
    add si,2
    mov dl,'f'
    mov [si],dx
    add si,2
    mov dl,'l'
    mov [si],dx
    add si,2
    mov dl,'o'
    mov [si],dx
    add si,2
    mov dl,'w'
    mov [si],dx
    add si,2
    mov dl,'!'
    mov [si],dx
    add si,2
    mov ax,4c00h
    int 21h
code ends
end start