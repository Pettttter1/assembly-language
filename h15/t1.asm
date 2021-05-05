assume cs:code
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
    mov si,offset i
    mov ax,offset i_end-offset i
    cld
    rep movsb
    ;保存原int 9中断向量到data段中
    mov ax,data
    mov ds,ax
    mov ax,es:[4*9]
    mov ds:[0],ax
    mov ax,es:[4*9+2]
    mov ds:[2],ax
    ;设置新的int 9中断向量
    mov word ptr es:[4*9],200h
    mov word ptr es:[4*9+2],0h
     ;主程序
    mov ax,0b800h
    mov es,ax
    mov ah,'a'
    mov byte ptr es:[160*12+40*2+1],1
    s:
    mov es:[160*12+40*2],ah
    call delay
    inc ah
    cmp ah,'z'
    jna s
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
    s1:
    sub ax,1
    sbb dx,0
    cmp ax,0
    jne s1
    cmp dx,0
    jne s1
    pop dx
    pop ax
    ret

    i:
    ;push ax
    ;push bx
    ;push es
    in al,60h;读取端口60h读取键盘输入
    
    pushf
    call dword ptr ds:[0]

    cmp al,9eh
    jne i2
    mov cx,2000
    mov si,0
    i1:
    mov byte ptr es:[si],65
    inc byte ptr es:[1+si]
    add si,2
    loop i1
    i2:
    ;pop es 
    ;pop bx
    ;pop ax
    iret
    i_end:
    nop
code ends
end start