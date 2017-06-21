MOVIMENTA_PECA:
	MOV [ptr_valor_teclado], AL; Guarda dado vindo do teclado
	
	;[ptr_pos_person] = 0h Não tem nenhum bloco em movimento
	;CMP [ptr_pos_person], 0h
	
	JMP INICIA_NOVO_OBJETO
	;JMP MOVIMENTA_OBJETO
	
	
	;CMP AL, tecla_esquerda
	;JE TESTE
RETORNA:	
RET

INICIA_NOVO_OBJETO:
	CALL SETA_RANDOM_NOVA_POSICAO
	JMP RETORNA

SETA_RANDOM_NOVA_POSICAO:
	MOV AH, 00h  ; interrupts to get system time        
    INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

	mov  ax, dx
	xor  dx, dx
	mov  cx, 10    
	div  cx       ; here dx contains the remainder of the division - from 0 to 9

	add  dl, '0'  ; to ascii from '0' to '9'
	AND DL, 0011b
	MOV [ptr_pos_person], DL
RET
TESTE:
	CALL CHAMA_TELA_INICIAL
RET