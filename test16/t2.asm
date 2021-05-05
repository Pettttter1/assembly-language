assume cs:code,ds:data
stack segment stack
    dw 8 dup (0)
data segment
    dw 16 dup (0)
data ends

code segment
    start:
    ;安装int 9h例程
    mov ax,0
    mov es,ax
    mov di,200h
    mov ax,cs
    mov ds,ax
    mov si,offset s
    mov cx,offset s_end-offset s
    cld
    rep movsb
    ;保存原int 9中断向量
    mov ax,data
    mov ds,ax
    mov ax,es:[4*9]
    mov word ptr ds:[0],ax
    mov ax,es:[4*9+2]
    mov word ptr ds:[2],ax
    ;设置新的int 9 中断向量
    mov word ptr es:[4*9],200h
    mov word ptr es:[4*9+2],0h
    ;主程序
    main:
    mov ax,0b800h
    mov es,ax
    mov ah,'a'
    mov byte ptr es:[160*12+40*2+1],1
    s2:
    mov es:[160*12+40*2],ah
    call delay
    inc ah
    cmp ah,'z'
    jna s2
    ;恢复键盘输入
    mov ax,data
    mov ds,ax
    mov ax,0
    mov es,ax
    mov ax,ds:[0]
    mov es:[4*9h],ax
    mov ax,ds:[2]
    mov es:[4*9h+2],ax

    mov ax,4c00h
    int 21h

    delay:
    push ax
    push dx
    mov dx,05h
    mov ax,0
    x1:
    sub ax,1
    sbb dx,0
    cmp ax,0
    jne x1
    cmp dx,0
    jne x1
    pop dx
    pop ax
    ret
    s:
    in al,60h
    pushf
    mov ah,al
    
    call dword ptr ds:[0]
    call setscreen
    iret
    ;setscreen
    ;参数:ah值为0——清屏，1——设置前景色，2——设置背景色，3——向上滚动一行
    ;    :al，当选择1或2时，al为颜色
    ;功能:
    setscreen:
    cmp ah,0bh
    je sc1
    cmp ah,02h
    je sc2
    cmp ah,03h
    je sc3
    cmp ah,04h
    je sc4
    ret
    sc1:
    call sub1
    ret
    sc2:
    call sub2
    ret
    sc3:
    call sub3
    ret
    sc4:
    call sub4
    ret
    ;sub1
    ;参数:无
    ;功能:清屏
    sub1:
    push ax
    push si
    push cx
    mov si,0
    mov ax,32
    mov cx,2000
    sub1s:
    mov byte ptr es:[si],32
    add si,2
    loop sub1s
    pop cx
    pop si
    pop ax
    ret

    ;sub2
    ;参数:al
    ;设置前景色
    sub2:
    push si
    push cx
    mov si,1
    mov cx,2000
    sub2s:
    inc byte ptr es:[si]
    ;or byte ptr ds:[si],al
    add si,2
    loop sub2s
    pop cx
    pop si
    ret

    ;sub3
    ;参数:al
    ;设置背景色
    sub3:
    push si
    push cx
    mov si,1
    mov cl,4
    shl al,cl
    mov cx,2000
    sub3s:
    inc byte ptr es:[si]
    ;or byte ptr ds:[si],al
    add si,2
    loop sub3s
    pop cx
    pop si
    ret

    ;sub4
    ;参数:无
    ;功能:上移一行
    sub4:
    push ax
    push si
    push cx
    mov si,160;指向n+1行
    mov cx,1840
    sub4s:
    mov ax,es:[si]
    mov word ptr es:[si-160],ax
    add si,2
    loop sub4s
    mov cx,160
    sub4s1:
    mov word ptr es:[si-160],32
    add si,2
    loop sub4s1
    pop cx
    pop si
    pop ax
    ret
    s_end:
    nop
code ends
end start