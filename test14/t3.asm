assume cs:code
code segment
start:
    mov ax,2
    mov bx,ax
    mov cl,3
    shl ax,cl
    shl bx,1
    add ax,bx

    mov ax,4c00h
    int 21h
code ends
end start
