assume cs:code
data segment
    db "welcome to masm!",0
data ends
code segment
start:
    ;安装中断例程
    mov ax,0
    mov es,ax
    mov di,200h
    mov ax,cs
    mov ds,ax
    mov si,offset s
    mov cx,offset s_end-offset s
    rep movsb
    ;设置中断向量表
    mov word ptr es:[4*7ch],200h
    mov word ptr es:[4*7ch+2],0h
    ;执行7ch
    mov dh,10
    mov dl,10
    mov cl,2
    mov si,0;si指向data
    int 7ch
    mov ax,4c00h
    int 21h

    ;中断例程
    s:
    mov ax,160
    mul dh
    add al,dl
    mov bx,ax;bx指向屏幕
    mov dl,cl
    t:
    mov ax,data
    mov ds,ax
    mov ch,0
    mov cl,ds:[si]
    jcxz t1
    inc si
    mov ax,0b800h
    mov ds,ax
    mov ch,dl
    mov [bx],cx
    add bx,2
    add cx,1
    loop t
    t1:
    iret
    s_end:
    nop

code ends
end start