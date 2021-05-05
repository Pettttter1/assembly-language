assume cs:code
code segment
d1:     db 9,8,7,4,2,0;cmos ram存储时间的存放单元
d2:     db '/','/',' ',':',':',' '
start:
    mov ax,cs
    mov ds,ax
    mov si,offset d1
    mov di,offset d2
    ;置光标
    mov dh,12;行
    mov dl,30;列
   
    mov bh,0;页码
    
    mov cx,6
    s:
    push cx
    mov al,[si]
    out 70h,al
    in al,71h
    mov bl,al
    push bx
    mov cl,4
    shr al,cl
    or al,00110000b
    ;显示字符1
    mov bl,2;颜色
    mov cx,1
    ;置光标
    mov ah,2;光标
    int 10h
    ;在光标处显示字符
    mov ah,9
    int 10h
    inc dl
    ;显示字符2
    pop bx
    mov al,bl
    and al,00001111b
    or al,00110000b
    mov bl,2;颜色
    mov cx,1
    ;置光标
    mov ah,2;光标
    int 10h
    ;在光标处显示字符
    mov ah,9
    int 10h
    inc dl
    ;显示分隔符
    mov al,[di]
    mov bl,4
    mov ah,2;光标
    int 10h
    mov ah,9
    int 10h
    inc dl
    inc si
    inc di
    pop cx
    loop s

    mov ax,4c00h
    int 21h
code ends
end start