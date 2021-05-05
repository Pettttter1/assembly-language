assume cs:code
data segment
    dw 8 dup (0)
data ends
code segment
    start:
    ;安装int 7ch中断例程
    mov ax,0
    mov es,ax
    mov di,200h
    mov ax,cs
    mov ds,ax
    mov si,offset s
    mov cx,offset s_end-offset s
    cli
    rep movsb
    ;更改中断向量
    mov word ptr es:[4*7ch],200h
    mov word ptr es:[4*7ch+2],0h
    ;主程序
    main:
    mov ax,data
    mov ds,ax
    ;读出/写入的内存地址
    mov ax,0b800h
    mov es,ax
    mov bx,0

    mov ax,1;0读1写
    mov dx,3333;逻辑扇区号
    int 7ch
    
    mov ax,4c00h
    int 21h
    s:
    pushf
    push bx
    push ax
    call sub1
    call sub2
    call sub3
    pop ax
    cmp ax,0
    jne t1
    mov ah,2;2表示读
    jmp short t2
    t1:
    mov ah,3;3表示写
    t2:
    mov al,1
    mov bx,ds:[0]
    mov dh,bl;物理面号
    mov bx,ds:[1]
    mov ch,bl;物理磁道号
    mov bx,ds:[2]
    mov cl,bl;物理扇区号
    mov dl,0;驱动器号
    pop bx
    int 13h
    iret
    ;sub1
    ;输入:dx
    ;输出:si——余数
    ;功能:计算面号
    sub1:
    mov bx,1440;除数
    mov ax,dx;被除数低位在ax中
    mov dx,0;被除数高位为0
    div bx
    mov si,dx;余数保存到si中
    mov ds:[0],ax;存入data中
    ret

    ;sub2
    ;输入:si
    ;输出:di——余数
    ;功能:计算磁道号
    sub2:
    mov bx,18;除数
    mov ax,si
    mov dx,0
    div bx
    mov di,dx
    mov ds:[1],ax;存入data中
    ret

    ;sub3
    ;输入:di
    ;输出:di+1
    ;功能:计算扇区号
    sub3:
    inc di
    mov ds:[2],di
    ret

    s_end:
    nop
code ends
end start

