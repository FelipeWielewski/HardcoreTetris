;MONTAGEM DE OBJETO NA MEMORIA
;precisa ser instanciado caractere por caractere e jogado na pilha
;BX - posicao a guardar na memoria
;DH - altura do objeto
;DL - largura do objeto
;AH - cores
;AL - caractere ascii
;PUSH AX para cada caractere
;chamar funcao 'montar_objeto' com CALL
montar_obj:
    POP CX  ;guarda a posicao que o chamou pelo CALL
    
    MOV [BX],ptr2_new_obj
    MOV BX,ptr2_new_obj
    
    MOV [BX],DX ;guarda tamanho do objeto nas duas primeiras posicoes (altura e largura)
    
    MOV AL,DL   ;prepara multiplicacao
    MUL DH      ;multiplica altura por largura para saber tamanho
    ADD AX,AX   ;dobra o valor pois ira armazenar cor e caractere
    
    MOV DX,BX    
    ADD BX,AX   ;vai para o fim do tamanho do objeto
    
    montar_obj_loop:
        POP AX
        MOV [BX],AX
        SUB BX,02
        CMP BX,DX
        JNZ montar_obj_loop
        
        PUSH CX     ;recupera a posicao que o chamou pelo CALL
        RET

;IMPRESSAO DE OBJETO
;BX - posicao do objeto na memoria
;DX - posicao na tela a imprimir (DL coluna, DH linha)
imprimir_obj:
    MOV BX,[BX]
    
    CALL mover_cursor
    PUSH DX
    
    MOV AX,[BX] ; pega altura e largura
    MOV [ptr_obj_pri_col],DL
    ADD DL,AL
    MOV [ptr_obj_ult_col],DL
    
    POP DX
    
    MUL AH      ;multiplica altura por largura para saber tamanho
    ADD AX,AX   ;dobra o valor pois ira armazenar cor e caractere
    ADD AX,BX

    imprimir_obj_loop:
        PUSH AX
        ADD BX,02
        PUSH BX
        
        MOV AX,[BX] ; pega cor e caractere da memoria
        MOV BL,AH   ; define a cor em BL
    
        MOV BH,00h
        MOV CX,01   ; define a imp. apenas 1 vez
        MOV AH,09h  ; funcao de imprimir string
        INT 10h
        
        INC DL      ; vai pra proxima coluna
        MOV BL,[ptr_obj_ult_col]
        CMP DL,BL
        JZ imprimir_obj_nova_linha
    
    imprimir_obj_testa:
        CALL mover_cursor
        
        POP BX
        POP AX
        CMP AX,BX
        JNZ imprimir_obj_loop 
    
        RET
        
    imprimir_obj_nova_linha:
        INC DH
        MOV DL,[ptr_obj_pri_col]
        JMP imprimir_obj_testa
    
;MOVIMENTO DE OBJETO
;BX - posicao do objeto na memoria
;ptr_old_pos_obj - posicao do objeto na tela
;ptr_new_pos_obj - nova posicao do objeto
mover_objeto:
	PUSHA
    MOV CX,[BX]	; pega na memoria a posicao do desenho do objeto
    
	;apaga o objeto da posicao atual
	MOV BL,[ptr_cor_parede]
    MOV AL,000h ; caractere a ser escrito
    CALL imprimir_retangulo    
	
	MOV BX,CX
    
    ;imprimir personagem
    MOV BX,[BX]
    MOV [ptr_pos_person],DX
	MOV DX,[ptr_new_pos_obj]
    CALL imprimir_obj
    
    PUSH AX
	POPA
    RET