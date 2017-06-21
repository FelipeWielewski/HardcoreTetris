ORG 100h
    JMP MAIN

INCLUDE "Configuration.ASM" ;Arquivo de configuração do game
INCLUDE "lib\DISPLAY.ASM" ;Arquivo de configuração do game
INCLUDE "Controls.ASM" ;Arquivo de configuração do game
INCLUDE "Sounds.ASM" ;Som do jogo
INCLUDE "HUDPlayer.ASM" ;HUD de pontuação
INCLUDE "LineWarning.ASM" ;Controle da linha de risco
INCLUDE "RandomObject.ASM";Objetos aleatorios do tetris
INCLUDE "WallObject.ASM" ;Controle da parede de dificuldade
INCLUDE "InitialPage.ASM" ;Pagina de bem vindo
INCLUDE "Game.ASM" ;Pagina de bem vindo

MAIN:            
   CALL CONFIG_INICIAL
   CALL CHAMA_TELA_INICIAL   
   JMP START_GAME   
RET         

START_GAME:
    CALL GAME_INICIA_FUNDO
    CALL GAME 
RET      

GAME:                  
    CALL VERIFICA_TECLA_PRESSIONADA
    CALL MOVIMENTA_PECA
    ;CALL VERIFICA_MEIO
    ;CALL VERIFICA_LINHA_COMPLETADA
    ;CALL EXIBE_PONTOS
    ;CALL MOVIMENTA_PAREDE
    ;CALL VERIFICA_FIM 
    JMP GAME 
