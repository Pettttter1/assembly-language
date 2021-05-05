assume cs:code

stack segment stack
    db 16 dup (0)
stack ends

code segment
    mov ax,4c00h
    int 21h
start:
    mov ax,0
    push cs
    push ax
    mov bx,0
    retf
code ends
end start
