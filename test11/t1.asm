assume cs:code
data segment
    db 8,11,8,1,8,5,63,38
data ends

code segment
start:
    mov ax,data
    mov ds,ax
    mov dx,8
    mov si,0
    mov bx,0
    mov cx,8
    mov ax,0
    s:
    mov bl,[si]
    inc si
    cmp bx,dx
    jnb t
    inc ax
    t:
    loop s

    mov ax,4c00h
    int 21h
code ends
end start