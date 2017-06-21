;REPOSICIONAR CURSOR
;DH - coluna
;DL - linha
mover_cursor:
    PUSH BX
    
    MOV AH,02h  ; move o cursor
    MOV BH,00h  ; pagina de video 0
    INT 10h
    
    POP BX
    
    RET 

;IMPRESSAO RETANGULO (apenas um tipo de caractere)
;AL - caractere
;BL - atributos de cor
;CX - tamanho (CH altura, CL largura)
;DX - posicao na tela a imprimir (DL coluna, DH linha)
imprimir_retangulo:
    ADD CH,DH
	ADD BL,[ptr_cor_fundo]

imprimir_retangulo_loop:
    CALL mover_cursor
    PUSH CX
    
    MOV BH,00h
    MOV CH,0    ;CX = CL (largura)
    MOV AH,09h
    INT 10h

    INC DH
    
    POP CX
    
    CMP CH,DH    
    JNZ imprimir_retangulo_loop
    
    RET