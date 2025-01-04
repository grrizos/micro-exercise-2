; multi-segment executable file template.

data segment
    ; add your data here!
     msg db "hello world $"
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax  
    
    mov ax,0 
    mov dx,04h
    mov cx,01h
    push ax
    push dx
    push cx    
    
    
main_loop: 

     
    
LOOP1:  
 
    call PRA             ;call the functions in correct order
    call PGREENBOX       ;and again and again in the LOOP1
    call MOVESNAKE
    call WAITFUNC
   
    jmp LOOP1
   

    
    
    




   
PRA: 
  
    mov cx,2  
    push cx       ;set counter to print the string twice
    
    mov dl,0       ;set cursor position parameters
    mov dh,08h
    
    mov ah,00h     ; set video mode 
    mov al,01h     ; 40x25 mode
    
    int 10h        

   
again1:   
    mov ah,02h    ; set cursor position.
    int 10h       ; BIOS interrupt  
    
    mov ah,0Ah    ;print the A representing the road 
    mov al,'A'
    mov bh,0
    mov cx,27h
    int 10h   
    
    pop cx        ;use cx first print the upper road and then the lower one
    dec cx
    push cx
    add dh,04h    ;move down 4 rows
    cmp cx,0      
    jne again1
    pop cx        ;pop cx,we dont need it anymore
    
    ret


PGREENBOX: 

    
    mov cx,4d     ;use cx to print the 4 shells for the greenbox
    push cx       ;push it into stack
    mov dl,34d    ;set cursor to desired column and row
    mov dh,1


  again2:
    
    mov ah,02h    ; set cursor position.
    int 10h       ; BIOS interrupt  
    
    mov ah,09h    ;call interupt using green color and nothing as text
    mov al, ' '   ;we dont need any text
    mov bh,0
    mov bl,00100010b
    mov cx,05h
    int 10h   
    
    pop cx
    dec cx
    push cx
    add dh,01h
    cmp cx,0
    jne again2

    pop cx
    ret     
    
PREDBOX:          ;everythink we did for the green box, just with red as atrribute

    
    mov cx,4d      
    push cx
    mov dl,34d
    mov dh,1


  again3:
    
    mov ah,02h    ; set cursor position.
    int 10h       ; BIOS interrupt  
    
    mov ah,09h  
    mov al, ' '
    mov bh,0
    mov bl,01000100b
    mov cx,05h
    int 10h   
    
    pop cx
    dec cx
    push cx
    add dh,01h
    cmp cx,0
    jne again3

    pop cx
    ret
    



ADDB:
    
    pop ax        ; pop ret of addb to go back to wait func
    pop dx        ; pop the ret of waitfunc on dx
    pop cx        ; pop length on cx
   
    inc cx        ;inc length 
    cmp cx,40     ;compare the lenght of the snake, if its 40 it means it is as big as the screen so the program ends
    je end

    push cx       ; push length
    push dx       ; push ret of waitfunc
     
    push ax       ; push ret of addb
    
    ret           ; stack minus 1 element
    
MOVESNAKE:
    
    pop ax        ; pop ret
    pop cx        ; cx is the length
    pop dx        ; dx is the location of the tail
    push ax       ;push ret in stack, will pop later to add above it the length and location
    mov dh,10
  again5:
    cmp dl,40    ;check if the snake reached the end of the screen 
    je restart    ;go to restart, that moves the snake in the begging of the screen
    HERE:
    mov ah,02h    ; set cursor position.
    int 10h       ; BIOS interrupt  
    
    mov ah,0Ah    ;print the snake tail in the set by dx location
    mov al,'B'
    mov bh,0

    int 10h
   

    inc dl        ;move snake into the next spot
    pop ax
    push dx      
    push cx
    push ax


    ret

restart:
    mov dl,0
    jmp HERE      +
    

WAITFUNC:

    pop ax        ; pop ret
    pop cx        ; cx is the length
    pop dx        ; dx is the location of the tail   
    pop bx        ; times we called the function  first time zero
    
    push dx       ;push them back to use the registers
    push cx
    push ax   
    
    
    mov ah,86h       ;call interupt to wait for 0.1sec
    mov cx, 0x0001h
    mov dx, 0x86A0h

    
    int 15h
    
    inc bx           ;increment times called
    cmp bx,10d
    je addbcall:   
    return1:
   
    pop ax           ;pop ret of waitfunc
    pop cx           ;pop lenght
    pop dx           ;pop locaiton
    
    push bx          ;push everything in again while bx is the times called
    push dx
    push cx
    push ax  
    
    cmp bx,10d
    je printred
    return2:

    
    
    
    ret
    

addbcall:
    
    call ADDB
    jmp return1  
    
    
printred:
    call PREDBOX 
    pop ax        ; pop ret
    pop cx        ; cx is the length
    pop dx        ; dx is the location of the tail   
    pop bx        ; times we called the function  first time zero
    
    mov bx,0
    
    push bx          ;push everything in again while bx is the times called
    push dx
    push cx
    push ax   
    
    jmp return2 



     
end: 
	mov ah,05h
	mov al,02h
	int 10h
	
	
	mov al, 1
	mov bh, 2
	mov bl, 0011_1011b
	mov cx, msg1end - offset msg1 ; calculate message size. 
	mov dl, 0
	mov dh, 10
	push cs
	pop es
	mov bp, offset msg1
	mov ah, 13h
	int 10h
	jmp msg1end
	msg1 db "Its not a bug , its an undocumented feature "
	msg1end:  
		
		mov ah,86h       ;call interupt to wait for 0.1sec
        mov cx, 0x0201h
        mov dx, 0x86A0h

    
    int 15h


