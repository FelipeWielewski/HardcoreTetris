CONFIG_INICIAL:
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