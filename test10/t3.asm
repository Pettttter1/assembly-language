assume cs:code

stack segment stack
    db 16 dup (0)
stack ends

code segment
start:
    mov ax,1000h
    push ax
    mov ax,0
    push ax
    retf
code ends
end start