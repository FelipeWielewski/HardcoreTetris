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
	
RET