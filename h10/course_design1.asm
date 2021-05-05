assume cs:code,ss:stack
stack segment stack
    dw 0,0,0,0,0,0,0,0
    dw 0,0,0,0,0,0,0,0
stack ends
data segment
    db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
    db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
    db '1993','1994','1995'
    ;以上表示21年的21个字符串
    
    dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
    dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
    ;以上是表示21年公司总收入的21个dword型数据
    
    dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
    dw 11542,14430,15257,17800
    ;以上是表示21年公司雇员人数的21个word型数据
data ends

table segment
    db 41 dup (0)
table ends

code segment
start:
    mov si,0;si指向data中的位置
    mov dh,2
    mov dl,20
    mov cx,21
    
    main:
    push cx
    push dx
    mov di,0;di指向table中要填入的位置
    mov cx,4
    ;将年份装入table中
    year:
    mov ax,data
    mov ds,ax
    mov dx,[si]
    mov ax,table
    mov ds,ax
    mov [di],dx
    inc si
    inc di
    loop year
    sub si,4
    ;每个year占4B，与总收入之间隔6隔空格，填入6个空格
    mov cx,6
    inblank:
    mov dx,32;空格的ascii值为32
    mov [di],dx
    inc di
    loop inblank
    ;到此处si和di须保留，其余均可用

    ;转化总收入为字符
    mov ax,data
    mov ds,ax
    mov dx,[84+2+si]
    mov ax,[84+si]
    call transtring1

    ;转化雇员人数为字符
    mov ax,data
    mov ds,ax
    push si
    shr si,1;移动si到指定位置
    mov dx,0
    mov ax,[168+si]
    pop si
    call transtring1

    ;计算并转化平均收入为字符
    mov ax,data
    mov ds,ax
    mov dx,[84+2+si]
    mov ax,[84+si]
    mov bx,si
    shr bx,1
    mov cx,[168+bx]
    call divdw
    call transtring1
    add si,4
    mov byte ptr [di],0

    ;打印字符到显示器
    pop dx
    inc dh
    mov cx,4
    mov ax,table
    mov ds,ax
    push si
    call show_str
    pop si
    pop cx
    loop main
    mov ax,4c00h
    int 21h

    transtring1:
    mov bx,table
    mov ds,bx
    mov bx,0;数字长度
    pop bp;存储返回地址
    tran1:
    mov cx,10
    push bx
    call divdw
    pop bx
    inc bx
    add cx,48
    push cx
    
    mov cx,0;判断商是否为0
    add cx,dx
    add cx,ax
    jcxz out1;商不为0继续执行
    inc cx;防止跳出loop
    loop tran1
    
    out1:;跳出循环后将stack中的字符送入table中
    mov cx,bx

    t1:;送入字符到table
    pop ax
    mov [di],al
    inc di
    loop t1

    mov cx,10
    sub cx,bx
    mov bx,32
    t2:;送入空格到table
    mov [di],bl
    inc di
    loop t2
    push bp
    ret

    divdw:;被除数dx:ax,除数cx,商保存在dx:ax,余数在cx
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

    show_str:;行列dh:dl,颜色cl,自行设置数据ds指向,偏移si
    mov bh,cl
    mov ax,160
    mul dh
    mov si,ax;行
    mov ax,2
    mul dl
    add si,ax;列

    mov di,0;指向字母偏移
    mov ch,0
    s:
    mov cl,[di]
    jcxz x;c为0则跳出循环
    mov bl,cl
    mov ax,0b800h
    mov ds,ax
    mov [si],bx
    mov ax,table
    mov ds,ax
    add si,2
    add di,1
    loop s
    x:
    ret
code ends
end start