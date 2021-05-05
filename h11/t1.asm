assume cs:code

data segment
    db "Beginner's All-purpose Symbolic Instruction Code.",0
data ends

code segment
begin:
    mov ax,data
    mov ds,ax
    mov si,0
    call letterc

    mov ax,4c00h
    int 21h

    letterc:
    mov ch,0
    s:
    mov cl,[si]
    jcxz t1
    cmp cx,97
    jb t
    cmp cx,122
    ja t
    sub cl,20h
    mov [si],cl
    t:
    inc si
    loop s
    t1:
    ret
code ends
end begin
