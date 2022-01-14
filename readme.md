# Tetris ICMC Assembly

Projeto da materia de organização de computadores

## .:. Dependências .:.

Esse projeto depende do Processador ICMC para funionar, o simulador do processador em quetão pode ser encontrado no link abaixo:

[Processador-ICMC](https://github.com/simoesusp/Processador-ICMC)

- Siga os passos descritos no projeto acima para compilar o montador e o simulador
- Se tudo ocorreu bem você devera ter a sua disposição 2 arquivos o **montador** e o **sim**


## .:. Montando o projeto .:.

- Com o binario montador em mãos digite no terminal

**./montador tetris.asm tetris.mif**

- Esse comando ira gerar um arquivo de saida tetris.mif que podera ser executado no simulador

## .:. Rodando o projeto .:.
- Agora o segundo binario sera usado, o sim, digite no seu terminal:

**./sim tetris.mif charmap.mif**

> charmap.mif é um aquivo auxiliar ja incluso nesse repositorio

- Esse comando ira abrir uma interface e rodar o arquivo tetris.mif

- Para entrar em modo automatico pressione o botão Home, como indicado na interface e divirta-se

## .:. Funcionamento .:. 

inicialmente precisamos falar das variaveis do codigo
### Variaveis importantes:
As mais importantes são os vetores Grid e Peca
- Grid: é a variavel que guarda o estado de cada "unidade" do nosso video, sendo 0 para livre e 1 para há obstaculo

- Peca: é um vetor que guarda a posição no grid de cada unidade das nossas peças 

### Jogo em si:

- Função main:

Cuida da parte inicial, explicar aos jogadores os comandos e apresentar o projeto

- Loop_jogo:

É onde as coisas realmente acontecem.

Inicialmente há um delay, para que as os processos a frente aconteçam em uma velocidade apropriada para seres humanos.

Então a função "escuta" um input do teclado e chama outras funções baseado no que foi precionado 
> [barra de espaço] -> gira peças; [tecla a]-> move para a esquerda; [tecla d] -> move para a direita

Depois disso chama a descida da peças

Então checa se a descida é valida se sim continua no loop, se não chama nova peça

- Girar_peca:

Chama uma função que transforma o vetor Peca alterando as posições no grid com base na primeira posição

Checa se giro é valido, se sim continua, se não reverte

- MovePeca_lado:

Semelhante a gira peca, atualiza o vetor peca e checa se é valida a mudança

Se sim continua, se não desfaz

- As Outras funções são auxiliares