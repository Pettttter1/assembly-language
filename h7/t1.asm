assume cs:code,ss:stack
stack segment 
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
    db 21 dup ('year summ ne ?? ')
table ends

code segment
start:    
    mov ax,data
    mov ds,ax
    mov bx,0
    mov si,0;年份、总收入和雇员的偏移量
    mov di,0;table的偏移量
    mov cx,21

    s:
    ;下面移动year
    mov dx,[si]
    add si,2
    mov bx,table
    mov ds,bx
    mov [di],dx
    add di,2
    mov bx,data
    mov ds,bx
    ;再执行一次
    mov dx,[si]
    add si,2
    mov bx,table
    mov ds,bx
    mov [di],dx
    add di,3;中间有一个空格，所以多加1
    mov bx,data
    mov ds,bx
    sub si,4
    ;下面移动总收入
    mov ax,[84+si];ax保存总收入低位
    add si,2
    mov bx,table
    mov ds,bx
    mov [di],ax
    add di,2
    mov bx,data
    mov ds,bx
    ;再执行一次
    mov dx,[84+si];dx保存总收入高位
    add si,2
    mov bx,table
    mov ds,bx
    mov [di],dx
    add di,3;中间有一个空格，所以多加1
    mov bx,data
    mov ds,bx
    ;下面计算人均收入并保存总人数和人均收入
    push si
    shr si,1
    sub si,2
    mov bx,[168+si]
    div bx;商保存在ax中，余数保存在dx中，这里用不到余数，故用来保存总人数
    mov dx,[168+si]
    pop si
    mov bx,table
    mov ds,bx
    mov [di],dx
    add di,3;中间有一个空格，所以多加1
    mov [di],ax
    add di,3
    mov bx,data
    mov ds,bx
    loop s

    mov ax,4c00h
    int 21h
code ends
end start