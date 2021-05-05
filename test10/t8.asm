assume cs:code
data segment
    db 'conversation'
data ends
code segment
    start:
    mov ax,data
    mov ds,ax
    mov si,0
    mov cx,12
    call captial
    mov ax,4c00h
    int 21h

    captial:
    and byte ptr [si],11011111b
    inc si
    loop captial
    ret
code ends
end start