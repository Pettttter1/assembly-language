;data段数字转换为字符打印到屏幕上
assume cs:code
data segment
    dw 6543,12626,131,822,33,328
data ends
data1 segment
    db 16 dup (0)
data1 ends
stack segment stack
    db 16 dup (0)
stack ends
code segment
start:
    mov si,0;data segment偏移量
    mov cx,6;data segment数据个数
    mov bp,9;保存行序号
    s0:
    push cx
    mov ax,data
    mov ds,ax
    mov di,0;记录数字的位数
    mov dx,0;被除数高位
    mov ax,[si];被除数低位
    mov cx,10;除数
    s1:
    ;重新设置除数
    mov cx,10
    ;除法运算
    call divdw

    ;数字压入栈中
    add cx,48
    push cx
    
    ;判断是否商为0
    mov cx,ax
    inc di
    jcxz s2
    add cx,1;cx+1防止cx=1时退出loop

    loop s1
    s2:
    mov ax,data1
    mov ds,ax
    mov cx,di
    mov di,0
    add si,2
    s3:
    pop bx
    mov [di],bl
    add di,1
    loop s3
    mov byte ptr [di],0
    
    ;调用show_str
    push dx
    push cx
    push si
    mov cx,bp
    mov dh,cl
    mov dl,30
    mov cl,2
    mov si,0
    call show_str
    add bp,1
    pop si
    pop cx
    pop dx
    pop cx;外层循环
    loop s0
    mov ax,4c00h
    int 21h

    ;行列dh:dl,颜色cl,数据data segment,偏移si
    show_str:
    mov ax,data1
    mov ds,ax
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
    mov ax,data1
    mov ds,ax
    add si,2
    add di,1
    loop s
    x:
    ret

    ;被除数dx:ax,除数cx,商保存在dx:ax,余数在cx
    divdw:
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
code ends
end start