assume cs:code,ds:data,ss:stack
data segment
    db 'welcome to masm!'
data ends
stack segment stack
    dw 0,0,0,0,0
stack ends
code segment
start:
    
    mov cx,13;第13行
    mov si,0;显示器显示偏移量
    mov ax,11110001b;白底蓝字
    push ax
    mov ax,10100100b;绿底红字
    push ax
    mov ax,00000010b;绿字
    push ax

    s1:
    add si,160
    loop s1

    mov bl,2
    mov cx,3

    s2:
    pop bx
    push si
    push cx
    mov cx,16;16个字符
    mov di,0;字母偏移量
    s:
    mov ax,data
    mov ds,ax
    mov dl,[di]
    mov dh,bl;绿色字体
    mov ax,0b800h
    mov ds,ax
    mov [si+64],dx
    add si,2
    inc di
    loop s

    pop cx
    pop si
    add si,160
    loop s2
    
    mov ax,4c00h
    int 21h
code ends
end start