;操作系统安装程序
;完成时间：2021年5月3日——2021年5月5日
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
    jmp inputc

    stack1:;用于存放设置的时间
    db 20 dup (0)

    data:;界面选项
    ;dw offset data
    db 'welcome to my bootloader',0
    db '1) reset pc',0
    db '2) start system',0
    db '3) clock',0
    db '4) set clock',0 

    data1:;cmos ram 年月日时分秒存放单元
    db  9,8,7,4,2,0
    db  '// :: '
    db  1,1,1,1,1,1

    int9hmem:;保存int9h中断向量
    dw 0,0
    dw 1;esc标志
    
    data2:;输入时钟提示
    db '          please input clock',0
    db 'format: year/month/day hour:minute:second',0
    db '       example:21/05/04 18:47:05',0
    db 'set success',0
    db ' set fail',0

    int16hmem:;保存int16h中断向量
    dw 0,0
    dw 1;esc标志

    ;等待输入
    inputc:
    call display
    mov ah,0
    int 16h;测试输入
    call judge
    mov cx,2
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
    ;================================功能0:显示菜单栏================================
    display:
    call clear
    mov ax,cs
    mov ds,ax
    mov si,offset data-offset main
    add si,7c00h
    mov dh,9;行数

    mov cx,5;一共有五行
    dis1:
    push cx
    mov dl,25;列数

    dis2:
    mov ch,0
    mov cl,[si];字符
    jcxz dis3
    mov ch,4;颜色
    call print
    inc dl
    inc si
    inc cx;防止cx为1
    loop dis2
    
    dis3:
    inc si
    inc dh;下一行
    pop cx
    loop dis1
    ret
    ;reboot
    ;================================功能1:重启计算机================================
    reboot:
    mov ax,0ffffh
    mov bx,0
    push ax
    push bx
    retf

    ;boot_os
    ;================================功能2:引导现有操作系统===========================
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
    mov ax,[4*19h]
    mov bx,[4*19h+2]
    mov word ptr es:[4*19h],200h
    mov word ptr es:[4*19h+2],0h
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


    ;================================功能3:进入时钟程序===============================
    clock:
    ;安装新的int 9h中断例程
    mov ax,cs
    mov ds,ax
    mov si,offset new_int9h-offset main
    add si,7c00h
    mov ax,0
    mov es,ax
    mov di,200h
    mov cx,offset new_int9h_end-offset new_int9h
    cld
    rep movsb
    ;设置新的int 9h中断向量
    mov si,offset int9hmem-offset main
    add si,7c00h
    mov ax,es:[4*9h]
    mov ds:[si],ax
    mov ax,es:[4*9h+2]
    mov ds:[si+2],ax
    cli
    mov word ptr es:[4*9h],200h
    mov word ptr es:[4*9h+2],0h
    sti

    mov ax,cs
    mov ds,ax
    mov si,offset data1-offset main;si指向data1位置
    add si,7c00h
    mov di,offset int9hmem-offset main;di指向int9h位置
    add di,7c00h
    mov dh,11;行
    ;mov cx,3
    
    call clear;清空屏幕

    clocks1:
    mov dl,28
    mov bx,0;数据偏移
    mov cx,6
    
    clocks2:
    push cx
    ;读取年月日时分秒
    mov al,[si+bx]
    out 70h,al;把al值放入70地址端口
    in al,71h;从71数据端口读出数据
    ;第一个字符
    push ax
    mov cl,4
    shr al,cl
    call decodeBCD
    mov cl,al
    mov ch,[si+bx+12]
    call print
    inc dl
    ;第二个字符
    pop ax
    call decodeBCD
    mov cl,al
    mov ch,[si+bx+12]
    call print
    inc dl
    ;分隔符
    mov cl,[si+bx+6]
    mov ch,2
    call print
    inc dl
    inc bx
    pop cx
    loop clocks2
    mov cx,[di+4]
    jcxz clock_end
    mov cx,2
    loop clocks1
    clock_end:
    ;恢复原int9h中断向量
    mov ax,cs
    mov ds,ax
    mov ax,0
    mov es,ax
    cli
    mov ax,[di]
    mov es:[4*9h],ax
    mov ax,[di+2]
    mov es:[4*9h+2],ax
    sti
    mov word ptr [di+4],1;重置esc标志
    ret

    ;新的int 9h中断例程
    new_int9h:
    ;cli
    push bx
    in al,60h;读取端口60h读取键盘输入
    pushf
    mov bx,offset int9hmem-offset main
    add bx,7c00h
    
    call dword ptr cs:[bx]

    mov bx,12;data1偏移量
    cmp al,3bh;f1
    je exe_f1
    cmp al,3ch;f2
    je exe_f2
    cmp al,3dh;f3
    je exe_f3
    cmp al,3eh;f4
    je exe_f4
    cmp al,3fh;f5
    je exe_f5
    cmp al,40h;f6
    je exe_f6
    cmp al,01h;esc
    je exe_esc
    pop bx
    ;sti
    iret
    exe_f6:;改变秒钟颜色
    inc bx
    exe_f5:;改变分钟颜色
    inc bx
    exe_f4:;改变时钟颜色
    inc bx
    exe_f3:;改变日份颜色
    inc bx
    exe_f2:;改变月份颜色
    inc bx
    exe_f1:;改变年份颜色
    inc byte ptr ds:[si+bx]
    pop bx
    ;sti
    iret
    exe_esc:;退出时钟程序(返回主界面)
    ;设置esc标志为0
    push ax
    mov ax,ds
    push ax
    mov ax,cs
    mov ds,ax
    mov word ptr [di+4],0
    pop ax
    mov ds,ax
    pop ax
    pop bx
    ;sti
    iret
    new_int9h_end:
    nop
    
    ;================================功能4:设置时钟================================
    set_clock:
    ;显示提示
    call clear
    mov ax,cs
    mov ds,ax
    mov si,offset data2-offset main
    add si,7c00h
    
    mov dh,10;行
    mov cx,3;共三行

    set_clocks1:
    push cx
    mov dl,20;列

    set_clocks2:
    mov ch,0
    mov cl,[si]
    jcxz set_clocks3
    mov ch,4
    call print
    inc dl;列+1
    inc si;数据指针+1
    mov cx,2
    loop set_clocks2

    set_clocks3:
    inc si
    pop cx
    inc dh
    loop set_clocks1

    ;设置esc标志
    mov ax,cs
    mov ds,ax
    mov si,offset int16hmem-offset main
    add si,7c00h
    mov word ptr [si+4],1

    mov dl,20
    mov bx,offset stack1-offset main
    add bx,7c00h
    mov di,0;栈顶指针为0
    ;处理输入
    loop_clock:
    mov cx,[si+4]
    jcxz set_clock_end
    mov ah,0
    int 16h
    call judge2
    mov cx,2
    loop loop_clock

    set_clock_end:
    ret

    judge2:
    cmp ah,01h;esc
    je judge2_esc
    cmp ah,0eh;backspace
    je judge2_backspace
    cmp ah,1ch;enter
    je judge2_enter
    call pushs
    mov ch,4
    mov cl,al
    call print
    inc dl
    ret
    judge2_enter:
    call reset_clock
    judge2_esc:
    ;设置esc标志为0
    push ax
    mov ax,ds
    push ax
    push si
    mov ax,cs
    mov ds,ax
    mov si,offset int16hmem-offset main
    add si,7c00h
    mov word ptr [si+4],0
    pop si
    pop ax
    mov ds,ax
    pop ax
    ret
    judge2_backspace:
    cmp dl,20
    je judge2_backspaces1
    call pops
    mov ch,0
    mov cl,32
    dec dl
    call print
    judge2_backspaces1:
    ret
    
    ;================================函数:pushs==================================
    ;参数:
        ;输入:al——数据,bx——栈偏移,di——栈顶指针
        ;输出:无
    ;功能:将8位的al入栈
    pushs:
    push cx
    mov cx,ax
    push ax
    mov ax,ds
    push ax
    mov ax,0
    mov ds,ax
    mov [bx+di],cl
    inc di
    pop ax
    mov ds,ax
    pop ax
    pop cx
    ret
    ;================================函数:pops===================================
    ;参数:
        ;输入:di——栈顶指针,bx——栈偏移
        ;输出:al——数据
    ;功能:将8位的al出栈
    pops:
    push ax
    mov ax,ds
    push ax
    mov ax,cs
    mov ds,ax
    cmp di,0
    je pops1
    dec di
    mov al,[bx+di]
    pops1:
    pop ax
    mov ds,ax
    pop ax
    ret
     ;================================函数:reset_clock===================================
    ;参数:
        ;输入:di——栈顶指针,bx——栈偏移
        ;输出:无
    ;功能:用栈中的数据设置时间
    reset_clock:
    push ax
    mov ax,ds
    push ax
    push si
    push cx
    push di
    push dx

    mov ax,cs
    mov ds,ax
    mov si,offset data1-offset main
    add si,7c00h
    add si,5;data1偏移
    mov cx,6
    
    cmp di,0
    je reset_clocks2
    sub di,2
    
    mov dh,5
    mov dl,20
    call clear
    
    reset_clocks1:
    push cx
    mov al,[si]
    out 70h,al
    mov al,[bx+di]
    mov cl,al
    mov ch,4
    call print
    inc dl
    call encodeBCD
    mov ah,al
    mov cl,4
    shl ah,cl
    mov al,[bx+di+1]
    mov cl,al
    mov ch,4
    call print
    inc dl
    call encodeBCD
    add al,ah
    out 71h,al
    dec si
    sub di,3
    
    pop cx
    loop reset_clocks1

    reset_clocks2:
    pop dx
    pop di
    pop cx
    pop si
    pop ax
    mov ds,ax
    pop ax
    ret
    ;================================函数:decodeBCD================================
    ;参数:
        ;输入:al——BCD码
        ;输出:al——BCD码对应的ASCII码
    ;功能:将8位寄存器的BCD码转换为ASCII码
    decodeBCD:
    and al,00001111b
    add al,'0'
    ret
    ;================================函数:encodeBCD================================
    ;参数:
        ;输入:al——BCD码对应的ASCII码
        ;输出:al——BCD码
    ;功能:将ASCII码转换为8位寄存器的BCD码
    encodeBCD:
    sub al,'0'
    ret
    ;================================函数:print================================
    ;参数:
        ;输入:dh——行,dl——列,cl——要打印的字符,ch——颜色
        ;输出:无
    ;功能:打印单个字符到屏幕的dh:dl
    print:
    ;压栈
    push bx
    push ax
    mov ax,ds
    push ax
    push dx

    mov ax,0b800h
    mov ds,ax
    mov bx,160
    mov ax,0
    mov al,dh
    mul bx
    pop dx
    mov bx,ax
    mov ax,0
    mov al,dl
    shl ax,1
    add bx,ax;bx指向屏幕位置
    mov [bx],cx

    ;弹栈
    pop ax
    mov ds,ax
    pop ax
    pop bx
    ret

    ;================================函数:clear================================
    ;参数:
        ;输入:无
        ;输出:无
    ;功能:清空屏幕
    clear:
    push ax
    mov ax,ds
    push ax;压入ds
    push si
    push cx
    mov ax,0b800h
    mov ds,ax
    mov si,0
    mov cx,2000
    clears1:
    mov byte ptr [si],32
    mov byte ptr [si+1],0
    add si,2
    loop clears1
    pop cx
    pop si
    pop ax
    mov ds,ax
    pop ax
    ret
    main_end:
    nop
code ends
end start