assume cs:code
stack segment stack
    db 16 dup (0)
code segment
start:
    mov ax,0
    call far ptr s
    inc ax
    s:pop ax
    add ax,ax
    pop bx
    add ax,bx
code ends
end start