;被除数32位,除数16位
assume cs:code
stack segment stack
    db 16 dup (0)
stack ends
code segment
start:
    mov ax,4240h
    mov dx,000fh
    mov cx,0Ah
    call divdw

    mov ax,4c00h
    int 21h
    ;被除数dx:ax,除数cx,商保存在dx:ax,余数在cx
    divdw:
    push ax
    mov ax,dx
    mov dx,0
    div cx
    mov bx,ax
    pop ax
    div cx
    mov cx,dx
    mov dx,bx
    ret
code ends
end start
    