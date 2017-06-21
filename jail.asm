ORG 100h
    JMP main

;INCLUDE "DISPLAY.ASM"
;INCLUDE "OBJETO.ASM"
        
main:          
    CALL config
    CALL desenhar_jogo
    
    JMP exit
    
exit:
    INT 20h     ; retorna ao sistema operacional

config:
    MOV AH,00h  ; ajusta o modo de video
    MOV AL,02h  ; modo texto
    INT 10h     ; 80x25, 16 cores, 8 paginas 
    
    MOV AH,01h
    MOV CX,2607h; cursor invisivel
    INT 10h
    
    MOV [ptr_cor_fundo],cor_fundo_verde;cor_fundo_azul
    MOV [ptr_cor_parede],cor_fonte_branca
    MOV [ptr_velocidade],2
    MOV [ptr_gravidade],gravidade
    
    ;inicia sem objetos
    MOV [ptr2_new_obj],ptr2_new_obj
    
    RET
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Montagem da tela do jogo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

desenhar_fundo:
    MOV BL,[ptr_cor_parede]    
    MOV AL,parede
    MOV DL,00   ; coluna
    MOV DH,00   ; linha
    MOV CL,80   ; largura do retangulo
    MOV CH,25   ; altura do retangulo
    CALL imprimir_retangulo       
    
    MOV BL,[ptr_cor_parede]
    MOV AL,000h ; caractere a ser escrito 
    MOV DL,02   ; coluna
    MOV DH,01   ; linha
    MOV CL,76   ; largura do retangulo
    MOV CH,23   ; altura do retangulo
    CALL imprimir_retangulo
    
    RET
    
desenhar_jogo:
    CALL desenhar_fundo
    CALL desenhar_paredes
    CALL montar_personagem   
    CALL montar_personagem2   
    
    ;imprimir personagem
    MOV BX,[ptr2_personagem] 
    MOV DL,05   ; coluna
    MOV DH,18   ; linha
    MOV [ptr_pos_person],DX
    CALL imprimir_obj    
          
    MOV BL,[ptr_cor_parede]
    MOV AL,5Fh ; caractere a ser escrito 
    MOV DL,62   ; coluna
    MOV DH,23   ; linha
    MOV CL,16   ; largura do retangulo
    MOV CH,01   ; altura do retangulo
    CALL imprimir_retangulo
    
    
    CALL ler_teclado
    
    RET
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Subrotinas
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ler_teclado:

    MOV AH, 6
    MOV DL, 255
    INT 21h 
    
    MOV DX,[ptr_pos_person]
    MOV CX,DX
    
    CMP AL,tecla_sair
    JZ exit
    CMP AL,tecla_direita
    JZ mover_personagem_dir
    CMP AL,tecla_esquerda
    JZ mover_personagem_esq
    CMP AL,tecla_cima
    JZ mover_personagem_cim    
    
    MOV BX,[ptr_gravidade]
    DEC BX
    MOV [ptr_gravidade],BX
    CMP BX,00
    JZ gravidade
    
    JMP ler_teclado
        
    mover_personagem_dir:
        ADD CL,[ptr_velocidade]
        JMP mover_personagem   
            
    mover_personagem_esq:
        SUB CL,[ptr_velocidade]
        JMP mover_personagem  
            
    mover_personagem_cim:
        SUB CH,[ptr_velocidade]
        JMP mover_personagem     
        
    mover_personagem:
        MOV BX,[ptr2_personagem]
        CALL mover_objeto
        
        ;caso tenha obstaculo, volta
        CMP AL,00h    
        JZ ler_teclado
        
        ;caso movimente, atualiza posicao
        MOV [ptr_pos_person],DX   
        JMP ler_teclado
    
    ;move para baixo e atualiza gravidade    
    gravidade:        
        ADD CH,1;[ptr_velocidade]
        MOV [ptr_gravidade],gravidade
        JMP mover_personagem 

desenhar_paredes:  
  
    MOV AL,parede
    MOV BL,cor_fonte_branca
    MOV DL,02   ; coluna
    MOV DH,08   ; linha
    MOV CL,30   ; largura do retangulo
    MOV CH,01   ; altura do retangulo
    CALL imprimir_retangulo
    
    MOV AL,parede
    MOV BL,cor_fonte_branca
    MOV DL,48   ; coluna
    MOV DH,08   ; linha
    MOV CL,30   ; largura do retangulo
    MOV CH,01   ; altura do retangulo
    CALL imprimir_retangulo
    
    MOV AL,parede
    MOV BL,cor_fonte_branca
    MOV DL,02   ; coluna
    MOV DH,16   ; linha
    MOV CL,60   ; largura do retangulo
    MOV CH,01   ; altura do retangulo
    CALL imprimir_retangulo
    
    RET
    
montar_personagem:
    MOV BX,ptr2_personagem
    MOV DX,0303h            ; personagem 3x3
    MOV AH,cor_fonte_amarelac
    
    PUSH 0BFh    
    PUSH 000h    
    PUSH 0DAh
        
    PUSH 0DBh    
    PUSH 008h    
    PUSH 0DBh
        
    PUSH 0D9h    
    PUSH 000h    
    PUSH 0C0h    
    
    CALL montar_obj

    RET
    
montar_personagem2:
    MOV BX,ptr2_personagem
    MOV DX,0403h            ; personagem 3x4
    MOV AH,cor_fonte_amarelac
        
    PUSH 000h    
    PUSH 01Fh    
    PUSH 000h
    
    PUSH 010h    
    PUSH 002h    
    PUSH 011h
        
    PUSH 000h    
    PUSH 0DBh    
    PUSH 000h
        
    PUSH 010h    
    PUSH 0DFh    
    PUSH 011h    
    
    CALL montar_obj

    RET    
    
;MONTAGEM DE OBJETO NA MEMORIA
;precisa ser instanciado caractere por caractere e jogado na pilha
;BX - posicao a guardar na memoria
;DH - altura do objeto
;DL - largura do objeto
;AH - cor do objeto
;PUSH para cada caractere
;chamar funcao 'montar_objeto' com CALL
montar_obj:
    POP CX  ;guarda a posicao que o chamou pelo CALL
    
    PUSH AX
    
    MOV AX,[ptr2_new_obj]
    ADD AX,2    
    MOV [BX],AX
    
    MOV BX,AX
    MOV [BX],DL     ; altura
    INC BX
    MOV [BX],DH     ; largura
    
    INC BX
    POP AX
    MOV [BX],AH     ; cor do objeto
    
    MOV AL,DL   ;prepara multiplicacao
    MUL DH      ;multiplica altura por largura para saber tamanho (resultado em AX)  
    
    MOV DX,BX
    ADD BX,AX   ;vai para o fim do tamanho do objeto
    MOV [ptr2_new_obj],BX
    
    montar_obj_loop:
        POP AX
        MOV [BX],AL
        DEC BX
        CMP BX,DX
        JNZ montar_obj_loop
    
    PUSH CX     ;recupera a posicao que o chamou pelo CALL
    RET

;IMPRESSAO DE OBJETO
;BX - posicao do objeto na memoria
;DX - posicao na tela a imprimir (DL coluna, DH linha)
imprimir_obj:
    PUSH DX
    MOV CX,[BX]
    ADD BX,2
    MOV AL,[BX]
    MOV [ptr_obj_att],AL
    
    CALL mover_cursor
    PUSH DX
    
    MOV AX,CX ; pega altura e largura
    MOV [ptr_obj_pri_col],DL
    ADD DL,AL
    MOV [ptr_obj_ult_col],DL
    
    POP DX
    
    ;INC BX
    MUL AH      ;multiplica altura por largura para saber tamanho
    ADD AX,BX

    imprimir_obj_loop:
        PUSH AX
        INC BX
        PUSH BX
        
        MOV AL,[BX] ; pega cor e caractere da memoria
        MOV BL,[ptr_obj_att]   ; define a cor em BL
	    ADD BL,[ptr_cor_fundo]
    
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
        
        POP DX
    
        RET
        
    imprimir_obj_nova_linha:
        INC DH
        MOV DL,[ptr_obj_pri_col]
        JMP imprimir_obj_testa
    
;MOVIMENTO DE OBJETO
;BX - posicao do objeto na memoria
;CX - nova posicao do objeto
;DX - posicao atual do objeto
;retorna AL (01h - movimento efetuado, 00h - erro no movimento)
mover_objeto:
    PUSH CX
    PUSH BX
    
    MOV CX,[BX]    
    PUSH CX
    
	;apaga o objeto da posicao atual
	MOV BL,[ptr_cor_parede]
    MOV AL,000h ; caractere a ser escrito
    CALL imprimir_retangulo
        
    POP BX      ; recupera tamanho em BX
    CALL testar_retangulo    
    
    POP BX      ; valor de BX - posicao do obj na memoria
    
    CMP AL,00h
    JZ mover_objeto_erro
    
    POP DX      ; valor de CX - nova posicao do objeto
    CALL imprimir_obj   
    
    MOV AL,01h
    
    RET
    
mover_objeto_erro:
    PUSH CX    
    CALL imprimir_obj
    MOV AL,00h
    RET
    
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
    PUSH DX     ; guarda valor de DX
    
    ADD CH,DH
	ADD BL,[ptr_cor_fundo]

    imprimir_retangulo_loop:
        CALL mover_cursor
        PUSH CX
        
        MOV BH,00h
        MOV CH,00    ;CX = CL (largura)
        MOV AH,09h
        INT 10h
    
        INC DH
        
        POP CX
        
        CMP CH,DH    
        JNZ imprimir_retangulo_loop
    
    POP DX      ; recupera valor de DX
    RET

;TESTE DE RETANGULO (se existem desenho no fundo do retangulo)
;BX - tamanho (BH altura, BL largura)
;DX - posicao na tela a iniciar (DL coluna, DH linha)
;retorna AL (01h - fundo vazio, 00h - fundo ocupado)
testar_retangulo:
    PUSH DX
    PUSH BX
    MOV CH,0
    MOV CL,BL

    testar_retangulo_loop:
        CALL mover_cursor
        
        MOV BH,00h
        MOV AH,08h
        INT 10h
        
        CMP AL,00
        JNZ testar_retangulo_sair
        
        INC DL
        LOOP testar_retangulo_loop
        
    POP BX
    POP CX
    MOV DL,CL
    
    INC DH
    DEC BH
    CMP BH,00
    JNZ testar_retangulo
    
    MOV AL,01h
    RET
        
testar_retangulo_sair:
    POP BX
    POP CX
    MOV AL,00h
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Configuracoes e contexto do jogo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ptr_pos_person      EQU 1000h
    ptr_cor_fundo       EQU 1002h
    ptr_cor_parede      EQU 1003h
    ptr_velocidade      EQU 1004h
    ptr_gravidade       EQU 1005h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Ponteiros controle de Objetos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ptr_obj_pri_col     EQU 1010h    
    ptr_obj_ult_col     EQU 1011h
    ptr_obj_att         EQU 1012h
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Ponteiros para Ponteiros de Objetos (cada um tem tamanho de 2 bytes)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ptr2_personagem     EQU 1030h
    ptr2_personagem2    EQU 1032h 
    
    ptr2_new_obj        EQU 1050h ;ultima posicao preenchida na memoria

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Constantes para Configuracao
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    parede              EQU 0B2h
    menu_novo_jogo      DB  "Novo Jogo$"
    menu_sobre          DB  "Sobre$"
    menu_sair           DB  "Sair$"
    menu_top            EQU 0Ch
    menu_left           EQU 25h
    menu_cursor         EQU 1Ah ;->
    tecla_cima          EQU 77h ;w
    tecla_baixo         EQU 73h ;s
    tecla_esquerda      EQU 61h ;a
    tecla_direita       EQU 64h ;d
    tecla_sair          EQU 1Bh ;ESC
    gravidade           EQU 1200

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Cores
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    cor_fundo_azul      EQU 010h
    cor_fundo_verde     EQU 020h
    cor_fonte_branca    EQU 00Fh
    cor_fonte_amarela   EQU 006h
    cor_fonte_amarelac  EQU 00Eh
    cor_fonte_verde     EQU 002h
    cor_fonte_cinza     EQU 008h