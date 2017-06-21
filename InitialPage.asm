CHAMA_TELA_INICIAL:
	CALL DESENHA_FUNDO
	CALL DESENHA_TEXTOS	
RET

DESENHA_FUNDO:
	MOV BL,[cor_fundo_azul]
    MOV AL,000h ; caractere a ser escrito 
    MOV DL,00   ; coluna
    MOV DH,00   ; linha
    MOV CL,80   ; largura do retangulo
    MOV CH,25   ; altura do retangulo
    CALL imprimir_retangulo
RET
DESENHA_TEXTOS:
	CALL TEXTO_BEM_VINDO
	CALL TEXTO_BOTAO_INICIAR
	
	JMP VERIFICA_BOTAO_INICIAR	
RET

TEXTO_BEM_VINDO:
	;BEM VINDO
    MOV DH, 5;linha
    MOV DL, 32;coluna
    CALL MOVER_CURSOR
           
    LEA DX, menu_novo_jogo
    MOV AH, 09h 
	
    ;MUDA COR
	MOV BL, cor_fonte_branca; cor 
    MOV CX, 10h ;num caracteres       
    INT 10h ;muda cor
	
    INT 21h
RET
TEXTO_BOTAO_INICIAR:
	;BEM VINDO
    MOV DH, 9;linha
    MOV DL, 28;coluna
    CALL MOVER_CURSOR
           
    LEA DX, menu_iniciar_jogo
    MOV AH, 09h 
	
    ;MUDA COR
	MOV BL, cor_fonte_branca; cor 
    MOV CX, 18h ;num caracteres       
    INT 10h ;muda cor
	
    INT 21h
RET

VERIFICA_BOTAO_INICIAR:
	MOV AH, 08h
    INT 21h
    ;AL recebe a tecla    
	
    CMP AL, tecla_iniciar_jogo
    JE INICIA_JOGO
	JMP VERIFICA_BOTAO_INICIAR
RET

INICIA_JOGO:
RET
