assume cs:code,ss:stack
stack segment stack
    dw 16 dup (0)
stack ends
data segment
    db 32 dup (0)
data ends
code segment
    start:
    mov dh,5;行
    mov dl,0;列
    mov ax,data
    mov ds,ax
    mov si,0;指向栈顶
    mov ax,0b800h
    mov es,ax
    s:
    mov ax,0
    int 16h
    cmp ah,01h
    je rets
    call judge
    mov cx,2
    loop s
    rets:
    mov ax,4c00h
    int 21h
    ;judge
    ;参数:ah——通码,al——ASCII
    ;功能:判断输入的键并执行对应的操作
    judge:
    cmp ah,0eh;backspace键
    je s1
    cmp ah,1ch;enter键
    je s2
    ;输入字符，压入栈中并显示
    call sub1
    call sub3
    ret
    ;输入backspace，退栈并显示
    s1:
    call sub2
    call sub3
    ret
    ;输入enter，显示所有字符
    s2:
    mov al,0
    call sub1
    call sub3
    s3:
    call sub2
    loop s3
    inc dh
    ret

    ;sub1
    ;参数:al——入栈的字符
    ;功能:字符入栈
    sub1:
    mov byte ptr [si],al
    inc si
    ret
    ;sub2
    ;参数:al——返回的字符
    ;功能:字符出栈
    sub2:
    cmp si,0
    je sub2s1
    dec si
    sub2s1:
    ret
    ;sub3
    ;参数:dh——行,dl——列
    ;功能:显示字符
    sub3:
    ;清空该行
    mov cx,80
    mov di,0
    sub3s:
    mov byte ptr es:[160*5+di],32
    add di,2
    loop sub3s
    mov di,0
    mov cx,si
    mov bx,0
    sub3s1:
    mov al,[bx]
    mov es:[160*5+di],al
    inc bx
    add di,2
    loop sub3s1
    ret
code ends
end start