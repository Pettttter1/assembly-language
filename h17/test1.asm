;操作系统安装程序
assume cs:code
code segment
    start:
    ;使用int 13h将操作系统代码安装到软盘的0面0道1扇区
    mov ax,cs
    mov es,ax
    mov bx,offset main

    mov ah,3;写入
    mov al,10;扇区数
    mov ch,0;磁道号
    mov cl,1;扇区号
    mov dh,0;面号
    mov dl,0;软盘A，以此类推

    int 13h
    ;模拟int 19h，将main装入0:7c00h中
    mov ax,cs
    mov ds,ax
    mov si,offset main
    mov ax,0
    mov es,ax
    push ax
    mov di,7c00h
    push di
    mov cx,offset main_end-offset main
    cld
    rep movsb
    retf
    mov ax,4c00h
    int 21h

    main:
    ;将其它扇区中的内容写入内存
    mov ax,cs
    mov es,ax
    mov bx,7e00h;7c00h+0200h;偏移512字节

    mov ah,2;读取
    mov al,9;扇区数
    mov ch,0;磁道号
    mov cl,2;扇区号
    mov dh,0;面号
    mov dl,0;软盘A，以此类推

    int 13h
    jmp display
    ;存放数据
    data:
    ;dw offset data
    db 'welcome to my bootloader',0
    db '1) reset pc',0
    db '2) start system',0
    db '3) clock',0
    db '4) set clock',0 
    ;显示选项
    display:
    mov ah,0
    int 16h
    mov ax,cs
    mov ds,ax
    mov si,offset data-offset main
    add si,7c00h
    mov ax,0b800h
    mov es,ax
    mov di,1440;行数*160

    mov cx,5;一共有五行
    dis1:
    push cx
    mov bx,50;列数*2

    dis2:
    mov ch,0
    mov cl,[si]
    jcxz dis3
    mov es:[di+bx],cl
    mov byte ptr es:[di+bx+1],4
    add bx,2
    inc si
    inc cx;防止cx为1
    loop dis2
    
    dis3:
    inc si
    add di,160;下一行
    pop cx
    loop dis1

    ;等待输入
    inputc:
    mov ah,0
    int 16h;测试输入
    call judge
    loop inputc
    ;函数:judge
    ;参数:ah——扫描码，al——ASCII码
    ;功能:判断输入的字符
    judge:
    cmp al,'1'
    je j1
    cmp al,'2'
    je j2
    cmp al,'3'
    je j3
    cmp al,'4'
    je j4
    ret
    j1:
    call reboot
    ret
    j2:
    call boot_os
    ret
    j3:
    call clock
    ret
    j4:
    call set_clock
    ret

    mov ax,4c00h
    int 21h


    ;reboot
    ;功能1:重启计算机
    reboot:
    ret


    ;boot_os
    ;功能2:引导现有操作系统
    boot_os:
     ;安装新的int 13中断例程到0:200h
    mov ax,cs
    mov dx,ax
    mov si,offset new_int19-offset main
    add si,7c00h
    mov ax,0
    mov es,ax
    mov di,200h
    mov cx,offset new_int19_end-offset new_int19
    cld
    rep movsb
    ;保存原int 19的中断向量，设置新的int 19中断向量
    mov ax,[4*19]
    mov bx,[4*19+2]
    mov word ptr ds:[4*19h],200h
    mov word ptr ds:[4*19h+2],0h
    int 19h
    ret
    ;新的int 19中断例程
    new_int19:
    ;恢复原int 19中断向量
    mov word ptr ds:[4*19h],ax
    mov word ptr ds:[4*19h+2],bx
    ;安装原os的引导到0:7c00h
    mov ax,0
    mov es,ax
    mov bx,7c00h

    mov ah,2;读取
    mov al,1;扇区数
    mov ch,0;磁道号
    mov cl,1;扇区号
    mov dh,0;面号
    mov dl,80h;硬盘C，以此类推
    int 13h

    ;跳转到0:7c00h开始执行
    mov ax,0
    mov bx,7c00h
    push ax
    push bx
    retf
    new_int19_end:
    nop


    ;功能3:进入时钟程序
    clock:
    ret
    ;功能4:设置时钟
    set_clock:
    ret
    main_end:
    nop
code ends
end start