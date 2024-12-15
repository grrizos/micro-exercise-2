; multi-segment executable file template.

data segment
    ; add your data here!

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
 
    call PRA 

    call MOVESNAKE
    call WAITFUNC
   
    jmp LOOP1
   
   
    
jmp end
    
    
    
    




   
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
    
    mov ah,0Ah  
    mov al,'A'
    mov bh,0
    mov cx,28h
    int 10h   
    
    pop cx
    dec cx
    push cx
    add dh,04h
    cmp cx,0
    jne again1
    pop cx 
    
    ret


PGREENBOX: 

    
    mov cx,4d 
    push cx
    mov dl,34d
    mov dh,1


  again2:
    
    mov ah,02h    ; set cursor position.
    int 10h       ; BIOS interrupt  
    
    mov ah,09h  
    mov al, ' '
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
    
PREDBOX: 

    
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
    
    pop ax        ; pop ret
    pop cx        ; cx is the length
    pop dx        ; dx is the location of the tail
   
    inc cx
    mov bx,0

    push dx
    push cx
    push ax  
    
    ret
    
MOVESNAKE:
    
    pop ax        ; pop ret
    pop cx        ; cx is the length
    pop dx        ; dx is the location of the tail
    push ax       ;push ret in stack, will pop later to add above it the length and location
    mov dh,10
  again5:
    
    mov ah,02h    ; set cursor position.
    int 10h       ; BIOS interrupt  
    
    mov ah,0Ah  
    mov al,'B'
    mov bh,0

    int 10h
 

    inc dl   
    pop ax
    push dx
    push cx
    push ax


    ret


WAITFUNC:

    pop ax        ; pop ret
    pop cx        ; cx is the length
    pop dx        ; dx is the location of the tail   
    pop bx        ; times we called the function  first time zero
    
    push dx       ;push them back to use the registers
    push cx
    push ax   
    
    
    mov ah,86h       ;call interupt to wait for 0.1sec
    mov cx,1h
    mov dx,86A0h
    
    int 15h
    
    inc bx           ;increment times called
    
    cmp bx,10d
    je ADDB   
    
    pop ax           ;pop the stack to insert the counter at the bottom
    pop cx
    pop dx
    
    push bx          ;push everything in again
    push dx
    push cx
    push ax  
    
    ret
    
    
end:
ends

end start ; set entry point and stop the assembler.
