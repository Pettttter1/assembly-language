assume cs:code
stack segment stack
    dw 8 dup (0)
stack ends
code segment
start:
    mov ax,0
    call word ptr ds:[0eh]
    add ax,3
    mov ax,4c00h
    int 21h
code ends
end start