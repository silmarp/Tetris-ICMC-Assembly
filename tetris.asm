;Na funçao checaMovimentoObstaculo tem um call TelaFim, coloquei lá só pra testar
jmp main

aux: var #1 ; Variavel para movimentos
PosPeca: var #1 ; Variavel para movimentos
PosAnterior: var #1 ; Variavel para movimentos
Direita_ou_esquerda: var #1 ;variavel que guarda para onde a peça foi para ser usada na checagem de movimento valido
                            ;0 => esquerda 1 => direita

Obstaculo: var #1 ; Variavel para movimentos
Score: var #1 ;variavel para placar

Letra: var #1  ; Guarda a letra digitada

PosGrid: var #1
Grid: var #1080
Peca: var #4 ;vetor que guarda a posição de cada integrante da peça de tetris são 4 no total
Peca_Tipo: var #1 ;guarda o tipo da peça que são 13 possibilidades

; ====== TIPOS DE PEÇA ======= (variações == rotação das peças)
;
;0   | 1 |  2       |  3  |  4    | 5 + (3 variações) | 8 + (3 variações)
; AA | A | A A A A  | A   |   A A | A                 |
; AA | A |          | A A | A A   | A                 | A A A
;    | A |          |   A |       | A A               |   A   
;    | A |          |     |       |                   |

Msg1: string "****    || TETRIS ICMC ||    ****"
Msg3: string "PRESSIONE QUALQUER TECLA PARA COMECAR:"
Msg4: string "SSC0511 - ORG. COMP."
Msg5: string "ICMC"
Msg6: string "Voce perdeu, jogar novamente? <s/n>"
Msg7: string "Sua pontuacao foi de: "

main:
	
	call LimpaTela 
	
	loadn r4, #0
	loadn r2, #0
	loadn r1, #180

	store PosPeca, r1    ; pos da peça = bit 180
	store Obstaculo, r3
	
	loadn r0, #564
	loadn r1, #Msg1    ;Mensagem inicial
	loadn r2, #2816   ; amarelo
	call PrintaFrase_1
	
	loadn r0, #1121
	loadn r1, #Msg3   ;Mensagem inicial
	loadn r2, #0	  ;branco
	call PrintaFrase_2
	
	loadn r0, #50
	loadn r1, #Msg4  ;Mensagem inicial
	loadn r2, #0     ;branco
	call PrintaFrase_2
	
	call DigitaAlgo ;qualquer tecla para começar
	
	call LimpaTela 
	
	loadn r1, #Tela7Linha0    ;Carrega as intrucoes do jogo
	call Cor_info
	
	call DigitaAlgo ;qualquer tecla para começar
	
	call LimpaTela 
	
	loadn r1, #tela1Linha0	 ;Carrega o cenario do jogo
	call Cor_Cenario
	
	loadn r1, #tela3Linha0   ;Carrega o cenario do jogo
	call Cor_Cenario2
	
	loadn r0, #1120
 	loadn r1, #Msg5
 	loadn r2, #0
 	call PrintaFrase_2




    call Inicia_vetor_grid
    call Inicia_peca

loop_jogo:



    ;chamar essa func para lançar nova peça
	
    ; TO DO: tipo peça assinalar numero aleatorio
    ; TO DO: gera peça baseado em tipo peça iniciando ela com as posições adequadas
    ; TO DO: entra no loop movimento
		
	loop_movimento:
		
		loadn r1, #500    ; Variavel do delay, quanto maior r1, maior o delay
		mod r1, r4, r1
		cmp r1, r2          ;regra do delay
		jne Chama_delay
		
	; ____Game Logic____

        ; TO DO: checa e apaga linha completa

        ; TO DO: testa giro valido
        ; TO DO: chama giro precionado == gira, não precionado n gira

        ; TO DO: testa movimento valido valido == move peça, invalido == deixa peça onde esta e atualiza grid

		call MovePeca_lado
        call Desce_peca
        call Checa_descida

        ; TO DO: checa game over 


		Chama_delay:
			call Delay
			inc r4
			jmp loop_movimento
	
	halt
	
;======================= CORE ====================
;   ------------ movimento --------------
Desce_peca:

	push r0 
	push r1 
	push r2
	push r3
	
    call Apaga_vetor_peca

	; soma 40 na posição de cada elemento do vetor peça para movelo 1 unidade para baixo
    loadn r0, #Peca
    loadn r1, #40
    
    loadi r2, r0
    add r2, r2, r1
    storei r0, r2
    inc r0

    loadi r2, r0
    add r2, r2, r1
    storei r0, r2
    inc r0

    loadi r2, r0
    add r2, r2, r1
    storei r0, r2
    inc r0

    loadi r2, r0
    add r2, r2, r1
    storei r0, r2
    
    call Printa_vetor_peca

    call Delay_Peca

	pop r0 
	pop r1 
	pop r2
	pop r3

	rts 
	
MovePeca_lado:


	
    call Apaga_vetor_peca
	
    call Direcoes ; atualiza a posição da peça
    
    call Printa_vetor_peca
    call Delay_Peca



	rts 
	
Direcoes:  ;direcao para qual a peça vai

	push fr
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	push r6
	push r7

    loadn r0, #Peca
	
	
	inchar r7
	
    Esquerda:

		loadn r1, #'a'
		cmp r1, r7
	 	jne Direita	

        loadn r4, #0
        store Direita_ou_esquerda, r1 ;demarca que a peça foi para a esquerda

		call checaMovimento_decrementa_peca
		jmp Finaliza_lado
		
    Direita:

		loadn r1, #'d'
		cmp r1, r7
		jne Finaliza_lado

        loadn r4, #1
        store Direita_ou_esquerda, r1 ;demarca que a peça foi para a direita

		call checaMovimento_incrementa_peca
		jmp Finaliza_lado
		
    Finaliza_lado:
        ; assinala ao vetor peça suas novas posiçoes

        call checaMovimento ; checa se o movimento é valido 
                            ; se não desfaz o movimento


		pop r7
		pop r6
		pop r5
		pop r4
		pop r3
		pop r2
		pop r1
		pop r0
		pop fr
		
		rts

checaMovimento:
    ;garante que a peça não esta na borda do grid
    push fr
	push r0 ; tela0linha0
	push r1 ; posicao
	push r2
	push r3 ; espaço
	push r4 ; 
	push r5 ;
	push r6 ;

    loadn r0, #Peca
    loadn r4, #0 ; contador
    loadn r5, #4 ; limite do contador para percorrer peça
    loadn r6, #40

    checaMovimento_loop_border:
        loadi r1, r0
        loadn r2, #11
        loadn r3, #28

        mod r1, r1, r6

        cmp r1, r2
        ceq checaMovimento_incrementa_peca

        cmp r1,r3
        ceq checaMovimento_decrementa_peca

        inc r0
        inc r4
        cmp r4, r5
        jne checaMovimento_loop_border
    
    loadn r0, #Peca
    loadn r4, #0 ; contador
    loadn r5, #4 ; limite do contador para percorrer peça
    loadn r6, #1
    
    checaMovimento_loop_border_2:
        loadn r2, #Grid
        loadi r1, r0
        add r2, r2, r1
        loadi r3, r2
        cmp r3, r6
        ceq dir_or_esq
        inc r0
        inc r4
        cmp r4, r5
        jne checaMovimento_loop_border_2
        
	pop r6
	pop r5
	pop r4 
	pop r3
	pop r2
	pop r1
	pop r0
    pop fr
	rts

dir_or_esq:
    push fr
    push r0
    push r1

    load r0, Direita_ou_esquerda
    loadn r1, #0

    cmp r0, r1
    ceq checaMovimento_incrementa_peca
    cne checaMovimento_decrementa_peca
    
    pop fr
    pop r0
    pop r1
    rts

checaMovimento_decrementa_peca:
    push r0
    push r1
    push r2

    loadn r0, #Peca

    loadi r2, r0
    dec r2
    storei r0, r2
    
    inc r0

    loadi r2, r0
    dec r2
    storei r0, r2
     
    inc r0
    
    loadi r2, r0
    dec r2
    storei r0, r2
    
    inc r0
    
    loadi r2, r0
    dec r2
    storei r0, r2

    pop r0
    pop r1
    pop r2
    rts


checaMovimento_incrementa_peca:
    push r0
    push r1
    push r2

    loadn r0, #Peca

    loadi r2, r0
    inc r2
    storei r0, r2
    
    inc r0

    loadi r2, r0
    inc r2
    storei r0, r2
     
    inc r0
    
    loadi r2, r0
    inc r2
    storei r0, r2
    
    inc r0
    
    loadi r2, r0
    inc r2
    storei r0, r2

    pop r0
    pop r1
    pop r2
    rts


;   ------------ Fim movimento -------------
;   ------------ Obstaculos --------------
Checa_descida:
    push fr
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5


    
    ;não passar da ultima linha

    loadn r0, #Peca
    loadn r2, #40
    loadn r3, #1
    loadn r4, #0 ; contador
    loadn r5, #4

    Checa_decida_loop:
        push r6
        loadi r1, r0 ;pega posição da peca
        loadn r6, #Grid ; inicia ponteiro grid
        add r1,r1, r2 ; aumenta 40 (vai para linha de baixo)
        add r6, r6, r1 ; coloca o ponteiro na posição correspondente
        loadi r1, r6 ;coloca o calor correspondente no r1
        pop r6

        cmp r1, r3
        jeq Decida_invalida

        inc r4
        inc r0
        cmp r4, r5
        jne Checa_decida_loop
    
    jmp Descida_valida

    Decida_invalida:
        call Atualiza_grid_e_chama_nova_peca
        call Inicia_peca
    

    Descida_valida:

    pop fr
    pop r0
    pop r1
    pop r2
    pop r3
    pop r4
    pop r5


    rts


Atualiza_grid_e_chama_nova_peca:
    push fr
    push r0
    push r1
    push r2
    push r3
    push r4
    push r7


    loadn r0, #Peca
    loadn r2, #4
    loadn r3, #0 ;contador
    loadn r4, #1

    

    Atualiza_grid_e_chama_nova_peca_loop:
        loadi r1, r0 
        loadn r7, #Grid
        add r7, r7, r1
        
        storei r7, r4


        inc r0
        inc r3
        cmp r2, r3
        jne Atualiza_grid_e_chama_nova_peca_loop
 
    
    pop fr
    pop r0
    pop r1
    pop r2
    pop r3
    pop r4
    pop r7
    rts

;   ------------- Fim Obstaculos ---------

;========================= UTILS ==================
;   ----------------- manipulação de vetor -----------
Printa_vetor_peca: ; printa o vetor peça na posição adequada na tela
    push fr
    push r0
    push r1
    push r2
    push r3
    push r4

    loadn r0, #Peca
    loadn r1, #4
    loadn r2, #0 ; contador para as 4 unidades da peça
    loadn r4, #'A'

    Printa_vetor_Peca_loop:
        loadi r3, r0
        outchar r4, r3
        inc r0
        inc r2
        cmp r2, r1
        jne Printa_vetor_Peca_loop

    pop fr
    pop r0
    pop r1
    pop r2
    pop r3
    pop r4
    rts

Apaga_vetor_peca: ; printa o vetor peça na posição adequada na tela
    push fr
    push r0
    push r1
    push r2
    push r3
    push r4

    loadn r0, #Peca
    loadn r1, #4
    loadn r2, #0 ; contador para as 4 unidades da peça
    loadn r4, #' '

    Apaga_vetor_Peca_loop:
        loadi r3, r0
        outchar r4, r3
        inc r0
        inc r2
        cmp r2, r1
        jne Apaga_vetor_Peca_loop

    pop fr
    pop r0
    pop r1
    pop r2
    pop r3
    pop r4
    rts




Inicia_vetor_grid:      ;assinala o valor 0 para todos os elementos do vetor grid
				        ; 0 == não há obstaculo
	push fr
	push r0
	push r1
	push r3
	push r4 ;counter

	loadn r0, #Grid
	loadn r1, #1040
	loadn r3, #0
	loadn r4, #0 ;contador

	grid_loop:
		storei r0, r3
		inc r0
		inc r4
		cmp r4, r1
		jne grid_loop

    loadn r1, #1080
	loadn r3, #1

    grid_loop_2:
		storei r0, r3
		inc r0
		inc r4
		cmp r4, r1
		jne grid_loop_2


	pop fr
	pop r0
	pop r1
	pop r3
	pop r4

	rts

Inicia_peca: ; inicia / chama nova peça
	push fr
	push r0
	push r1

    ; Usar a solução, no começo passo o valor inicial apenas para o primeiro elemento,
    ; com base nisso temos ""funções construtoras"" que usam esse 1 elemento para fazer o vetor
    ; assim posso reusar as funçoes construtoras para a hora de girar a peça

    ;valor inicial da peça é 180

    ; no futuro fazer um especifico para cada peça

	loadn r0, #Peca
	loadn r1, #180

    storei r0, r1
    inc r0
    inc r1

    storei r0, r1
    inc r0
    inc r1

    storei r0, r1
    inc r0
    inc r1

    storei r0, r1

	pop fr
	pop r0
	pop r1

	rts


;   --------------- Fim manipulação de vetor ------------

Delay:
	push r0 
	push r2 
	
	loadn r2, #2  ; a
	
    loopi:				; (dois loops de decremento conforme dicas de jogos)
		loadn r0, #2300	; b
    loopj: 
		dec r0 			 
		jnz loopj	
		dec r2
		jnz loopi
	
	pop r2
	pop r0
	
	rts
	
Delay_Peca:
	push r0 
	push r2 
	
	loadn r2, #434 ; a
	
    loopi:				; (dois loops de decremento conforme dicas de jogos)
		loadn r0, #200	; b
    loopj: 
		dec r0 			 
		jnz loopj	
		dec r2
		jnz loopi
	
	pop r2
	pop r0
	
	rts
	

;========================= TELAS ==================
LimpaTela:
	push fr		        ;protege o registrador de flags
	push r0
	push r1
	
	loadn r0, #1200		;apaga as 1200 posicoes da tela
	loadn r1, #' '		;com "espaco"
	
	LimpaTela_Loop: 	; = for(r0=1200; r3>0; r3--)
		dec r0
		outchar r1, r0
		jnz LimpaTela_Loop
			
	pop r1
	pop r0
	pop fr
	rts
	
TelaFim:

 push r0
 push r1 
 push r2 
 push r3 
 push r4 
 push r5
 push r6
 
 call LimpaTela

 loadn r0, #44
 loadn r1, #Msg1
 loadn r2, #2816
 call PrintaFrase_1
 
 loadn r0, #523
 loadn r1, #Msg6
 loadn r2, #0
 call PrintaFrase_2
 
 loadn r0, #603
 loadn r1, #Msg7
 loadn r2, #2816
 call PrintaFrase_2
 
 loadn r0, #1160
 loadn r1, #Msg5
 loadn r2, #0
 call PrintaFrase_2
 
 load r0, Score
 loadn r3, #48
 add r0, r0, r3
 loadn r1, #624
 outchar r0, r1
 
 pop r0 
 pop r1 
 pop r2 
 pop r3
 pop r4
 pop r5
 pop r6
 
 jmp QuerJogarDenovo
 
 QuerJogarDenovo:
 	
	call DigitaAlgo
	loadn r0, #'n'
	load r1, Letra
	cmp r0, r1		; tecla == 'n' ?
	jeq FimDoJogo	; tecla é 'n'
	
	loadn r0, #'s'
	cmp r0, r1				; tecla == 's' ?
	jne QuerJogarDenovo	; tecla nao é 's'
	
	call LimpaTela
	
	pop r2
	pop r1
	pop r0

	pop r0	; Da um Pop a mais para acertar o ponteiro da pilha, pois nao vai dar o RTS !!
	jmp loop_jogo
 
FimDoJogo:

	call LimpaTela
	halt 
 
PrintaFrase_2:	

	push fr				
	push r0	; Posicao da tela que o primeiro caractere da mensagem sera' impresso
	push r1	; endereco onde comeca a mensagem
	push r2	; cor da mensagem
	push r3	; Criterio de parada
	push r4	; Recebe o codigo do caractere da Mensagem
	push r5
	
	loadn r3, #'\0'	; Criterio de parada
	loadn r5, #' '

PrintaFrase2_Loop:
	
		loadi r4, r1		; aponta para a memoria no endereco r1 e busca seu conteudo em r4
		cmp r4, r3			; compara o codigo do caractere buscado com o criterio de parada
		jeq PrintaFrase2_Exit	; goto Final da rotina
		cmp r4, r5;
		jeq PrintaFrase2_Skip
		add r4, r2, r4		; soma a cor (r2) no codigo do caractere em r4
		outchar r4, r0		; imprime o caractere cujo codigo está em r4 na posicao r0 da tela
		
PrintaFrase2_Skip:
	
		inc r0				; incrementa a posicao que o proximo caractere sera' escrito na tela
		inc r1				; incrementa o ponteiro para a mensagem na memoria
		jmp PrintaFrase2_Loop	; goto Loop
	
PrintaFrase2_Exit:	;Desempilhamento: resgata os valores dos registradores utilizados na Subrotina da Pilha
		
		pop r5
		pop r4	
		pop r3
		pop r2
		pop r1
		pop r0
		pop fr
		rts		; retorno da subrotina
	
ImprimeTela:

	push fr
	push r0	; Posicao da tela que o primeiro caractere da mensagem sera' impresso
	push r1	; endereco onde comeca a mensagem
	push r2	; cor da mensagem
	push r3	; Criterio de parada
	push r4	; Recebe o codigo do caractere da Mensagem
	push r5
	push r6
	push r7
	
	loadn r0, #0
	loadn r5, #30	;imprimir 30 linhas
	loadn r6, #40
	loadn r7, #1
		
ImprimeTela_Loop: 

	call PrintaFrase_2
			
	add r1, r1, r6
	add r1, r1, r7
	add r0, r0, r6
			
	dec r5
	jnz ImprimeTela_Loop

	pop r7		
	pop r6
	pop r5	
	pop r4	
	pop r3
	pop r2
	pop r1
	pop r0
	pop fr
	rts
	
Cor_info:
	push fr
	push r1
	push r2
	
	loadn r2, #1792 ;cor do info (no caso prata)  
	call ImprimeTela;

	pop r2
	pop r1
	pop fr
	rts	
	
Cor_Cenario:
	push fr
	push r5
	push r6
	
	loadn r2, #2816 ;cor do sol (amarelo)  
	call ImprimeTela;

	pop r6
	pop r5
	pop fr
	rts	
	
Cor_Cenario2:
	push fr
	push r5
	push r6
	
	loadn r2, #0 ;cor do cenario (no caso branco)  
	call ImprimeTela;

	pop r6
	pop r5
	pop fr
	rts	

DigitaAlgo:
 	push fr ; Protege o registrador de flags
 	push r0
 	push r1 
 	push r2 
 	push r3
 	
 	loadn r1, #255  ; Se nao digitar nada vem 255
 	loadn r2, #0
 	
 	DigitaAlgo_Loop:
 		inchar r0            ; Le o teclado, se nada for digitado = 255   
 		cmp r0, r1           ;compara r0 com 255
 		jeq DigitaAlgo_Loop    ; Fica lendo ate' que digite uma tecla valida
 		  
 	
 	store Letra, r0          ; Salva a tecla na variavel global "Letra"
 	
 	
 	DigitaAlgo_Loop2:         ; Bloco novo para aguardar que o user solte a tecla pressionada!!
 		inchar r0             ; Le o teclado, se nada for digitado = 255
 		cmp r0, r1            ;compara r0 com 255
 		jne DigitaAlgo_Loop2  ; Fica lendo ate' que digite uma tecla valida
 		
 	pop r3
 	pop r2 
 	pop r1 
 	pop r0 
 	pop fr
 	
 	rts	

PrintaFrase_1:	
	push fr				
	push r0	; Posicao da tela que o primeiro caractere da mensagem sera' impresso
	push r1	; endereco onde comeca a mensagem
	push r2	; cor da mensagem
	push r3	; Criterio de parada
	push r4	; Recebe o codigo do caractere da Mensagem
	
	loadn r3, #'\0'	; Criterio de parada

	Print_Str_1_Loop:	
		loadi r4, r1		; aponta para a memoria no endereco r1 e busca seu conteudo em r4
		cmp r4, r3			; compara o codigo do caractere buscado com o criterio de parada
		jeq Print_Str_1_Exit	; goto Final da rotina
		
		
		add r4, r2, r4		; soma a cor (r2) no codigo do caractere em r4
		outchar r4, r0		; imprime o caractere cujo codigo está em r4 na posicao r0 da tela
		inc r0				; incrementa a posicao que o proximo caractere sera' escrito na tela

		inc r1				; incrementa o ponteiro para a mensagem na memoria
		jmp Print_Str_1_Loop	; goto Loop
	
	Print_Str_1_Exit:	
	;---- Desempilhamento: resgata os valores dos registradores utilizados na Subrotina da Pilha

		pop r4	
		pop r3
		pop r2
		pop r1
		pop r0
		pop fr
		rts		; retorno da subrotina
	
; Tela do Jogo

tela1Linha0  : string "                                        "
tela1Linha1  : string "                                        "
tela1Linha2  : string "                                        "
tela1Linha3  : string " .  |  .                                "
tela1Linha4  : string "   OOO                                  "
tela1Linha5  : string " -OOOOO-                                "
tela1Linha6  : string "   OOO                                  "
tela1Linha7  : string " .  |  .                                "
tela1Linha8  : string "                                        "
tela1Linha9  : string "                                        "                   
tela1Linha10 : string "                                        "               
tela1Linha11 : string "                                        "               
tela1Linha12 : string "                                        "            
tela1Linha13 : string "                                        "                   
tela1Linha14 : string "                                        "                  
tela1Linha15 : string "                                        "
tela1Linha16 : string "                                        "
tela1Linha17 : string "                                        "
tela1Linha18 : string "                                        "
tela1Linha19 : string "                                		   "
tela1Linha20 : string "                                        "
tela1Linha21 : string "                                        "
tela1Linha22 : string "                                        "
tela1Linha23 : string "                                        "
tela1Linha24 : string "                                        "
tela1Linha25 : string "                                        "
tela1Linha26 : string "                                        "
tela1Linha27 : string "                                        "
tela1Linha28 : string "                                        "
tela1Linha29 : string "                                        "

tela3Linha0  : string "----------------------------------------"
tela3linha1  : string "                                        "
tela3Linha2  : string "                                        "
tela3Linha3  : string "           @@@@@@@@@@@@@@@@@@           "
tela3Linha4  : string "           @                @    OOOO   "
tela3Linha5  : string "           @                @   OOO@@O  "
tela3Linha6  : string "           @                @   OOO@@O  "
tela3Linha7  : string "           @                @    OOOO   "
tela3Linha8  : string "           @                @           "
tela3Linha9  : string "           @                @           "
tela3Linha10 : string "           @                @           "
tela3Linha11 : string "           @                @           "
tela3Linha12 : string "           @                @           "
tela3Linha13 : string "           @                @           "
tela3Linha14 : string "           @                @           "
tela3Linha15 : string "           @                @           "
tela3Linha16 : string "           @                @           "
tela3Linha17 : string "           @                @      ^    "
tela3Linha18 : string "           @                @     ^^^   "
tela3Linha19 : string "           @                @     |O|   "
tela3Linha20 : string "           @                @    _| |_  "
tela3Linha21 : string "           @                @   |_|O|_| "
tela3Linha22 : string "           @                @    _| |_  "
tela3Linha23 : string "           @                @   |_____| "
tela3Linha24 : string "           @                @     @@@   "
tela3Linha25 : string "           @                @           "
tela3Linha26 : string "           @@@@@@@@@@@@@@@@@@           "
tela3Linha27 : string "                                        "
tela3Linha28 : string "                                 _____  "
tela3Linha29 : string "________________________________|_____|_"



tela5Linha0  : string "                                        "
tela5Linha1  : string "                                        "
tela5Linha2  : string "                                        "
tela5Linha3  : string "                                 OOOO   "
tela5Linha4  : string "                                OOO@@O  "
tela5Linha5  : string "                                OOO@@O  "
tela5Linha6  : string "                                 OOOO   "
tela5Linha7  : string "                                        "
tela5Linha8  : string "                                        "
tela5Linha9  : string "                                        "
tela5Linha10 : string "                                        "
tela5Linha11 : string "                                        "
tela5Linha12 : string "                                        "
tela5Linha13 : string "                                        "
tela5Linha14 : string "                                        "
tela5Linha15 : string "                                        "
tela5Linha16 : string "                                        "
tela5Linha17 : string "                                   ^    "
tela5Linha18 : string "                                  ^^^   "
tela5Linha19 : string "                                  |o|   "
tela5Linha20 : string "                                 _| |_  "
tela5Linha21 : string "                                |_|o|_| "
tela5Linha22 : string "                                 _| |_  "
tela5Linha23 : string "                                |_____| "
tela5Linha24 : string "                                        "
tela5Linha25 : string "                                        "
tela5Linha26 : string "                                        "
tela5Linha27 : string "                                        "
tela5Linha28 : string "                                 _____  "
tela5Linha29 : string "                                |_____| "

; Tela de Instrucoes

Tela7Linha0  : string "                                        "
Tela7Linha1  : string "               INSTRUCOES               "
Tela7Linha2  : string "                                        "
Tela7Linha3  : string "                                        "
Tela7Linha4  : string "         JOGO PARA A MATERIA DE         "
Tela7Linha5  : string "  ORGANIZACAO DE COMPUTADORES DIGITAIS  "
Tela7Linha6  : string "                                        "
Tela7Linha7  : string "        MINISTRADA PELO PROFESSOR       "
Tela7Linha8  : string "         EDUARDO DO VALLE SIMOES        "
Tela7Linha9  : string "                                        "
Tela7Linha10  :string "                                        "
Tela7Linha11  :string "      ESTE JOGO E O CLASSICO TETRIS     "
Tela7Linha12  :string "     OS COMANDOS BASICOS DO JOGO SAO:   "
Tela7Linha13  :string "                                        "
Tela7Linha14  :string "                                        "
Tela7Linha15  :string "         a - MOVE PARA ESQUERDA         "
Tela7Linha16  :string "         d - MOVE PARA DIREITA          "
Tela7Linha17  :string "                                        "
Tela7Linha18  :string "                                        "
Tela7Linha19  :string "          ESPERAMOS QUE GOSTE!          "
Tela7Linha20  :string "                                        "
Tela7Linha21  :string "                                        "
Tela7Linha22  :string "           TENHA UM BOM JOGO!           "
Tela7Linha23  :string "         BEBA AGUA E COMA FRUTAS        "
Tela7Linha24  :string "                                        "
Tela7Linha25  :string "                                        "
Tela7Linha26  :string "                                        "
Tela7Linha27  :string "                                        "
Tela7Linha28  :string " PRESSIONE QUALQUER TECLA PARA COMECAR: "
Tela7Linha29  :string "                                        " 
;jmp main