;编写子程序show_str显示字符串
assume cs:code
data segment
    db 'Welcome to masm!',0
data ends
stack segment stack
    dw 8 dup (0)
stack ends
code segment
    start:
    mov dh,8
    mov dl,3
    mov cl,2
    mov ax,data
    mov ds,ax
    mov si,0
    call show_str
    mov ax,4c00h
    int 21h
    ;行列dh:dl,颜色cl,数据data segment以0结尾,偏移si
    show_str:
    push dx
    push cx
    push si

    mov bh,cl
    mov ax,160
    mul dh
    mov si,ax;行
    mov ax,2
    mul dl
    add si,ax;列

    mov di,0;指向字母偏移
    mov ch,0
    s:
    mov cl,[di]
    jcxz x;c为0则跳出循环
    mov bl,cl
    mov ax,0b800h
    mov ds,ax
    mov [si],bx
    mov ax,data
    mov ds,ax
    add si,2
    add di,1
    loop s
    x:
    pop si
    pop cx
    pop dx
    ret

code ends
end start