assume cs:code
stack segment stack
    db 16 dup (0)
code segment
start:
    mov ax,0
    call s
    inc ax
    s:pop ax
code ends
end start