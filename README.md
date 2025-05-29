<div align="center">
  <h1> Desenvolvimento de biblioteca Assembly para utilização em coprocessador aritmético </h1>
  <h3> Universidade Estadual de Feira de Santana </h3>
  <h3> TEC499 (TP04) - MI Sistemas Digitais </h3>
  <h4> Gabriel Vitor Nogueira da Silva, Luana Pedreira Oliveira e Lucca de Almeida Hora Coutinho </h4>
</div>

## Introdução

<p align="justify">
Atualmente, diversas áreas da computação, como visão computacional, aprendizado de máquina, criptografia e simulações científicas, demandam grande capacidade de processamento, especialmente em operações envolvendo multiplicação de matrizes. A utilização de coprocessadores dedicados se apresenta como uma solução eficiente para acelerar essas operações, proporcionando melhorias significativas em desempenho e eficiência energética.
</p>

<p align="justify">
Neste contexto, foi desenvolvido anteriormente um coprocessador especializado na multiplicação matricial utilizando a plataforma DE1-SoC, que combina um processador ARM com um FPGA. Esse coprocessador visa atender aplicações que exigem alto desempenho em operações matriciais.	
</p>

<p align="justify">
Dando continuidade a esse desenvolvimento, o presente trabalho tem como objetivo a criação de uma biblioteca em linguagem Assembly para arquitetura ARM, que permite a interação eficiente entre o processador e o coprocessador implementado no FPGA. A biblioteca abstrai detalhes de baixo nível, facilitando a utilização das funções de multiplicação matricial por outras aplicações de software.
</p>

## Arquitetura do Sistema

<p align="justify">
A comunicação entre o Hardware (FPGA) e o Software (HPS - Hard Processor System) ocorre por meio de uma interface de barramento disponibilizada no sistema embarcado, especificamente através dos barramentos HPS-to-FPGA (H2F) e FPGA-to-HPS (F2H). Esta interface permite a troca de dados entre o coprocessador de multiplicação matricial e o processador ARM que executa o sistema Linux.
</p>

<p align="justify">
A respeito dos componentes Principais da Arquitetura, o processador ARM (HPS) executa o Linux, controla a aplicação e chama rotinas da biblioteca Assembly que interagem com o coprocessador. O coprocessador de multiplicação matricial, implementado na FPGA, é formado pela Unidade de Controle, que gerencia o fluxo de dados e sinais, e pela Interface de Dados, que comunica com o ARM via sinais DATA_IN e DATA_OUT.
</p>

<p align="justify">
A comunicação entre FPGA e HPS ocorre por sinais configurados na plataforma Qsys/Platform Designer do software Quartus II Prime Lite Edition: data_in_external_connection_export e data_out_external_connection_export. O sistema inclui detectores de borda para sinais de reset (frio, quente e debug) e o clock principal de 50 MHz (CLOCK_50).
</p>

<p align="justify">
A respeito do fluxo de funcionamento, o processador ARM executa uma aplicação Linux que utiliza uma biblioteca em Assembly desenvolvida para o projeto. Essa biblioteca envia comandos e dados para a FPGA por meio da interface de comunicação chamada DATA_IN.
</p>

<p align="justify">
Dentro da FPGA, a Unidade de Controle recebe esses dados, realiza o processamento necessário e executa a multiplicação matricial. Após o cálculo, os resultados são disponibilizados na linha DATA_OUT. Em suma, o processador ARM lê os resultados enviados pela FPGA e continua o processamento da aplicação.
</p>

<p align="justify">
	
</p>

## Hardwares Utilizados

<p align="justify">
O projeto utilizou a plataforma DE1-SoC da Terasic, composta por um FPGA Altera Cyclone V e um processador ARM Cortex-A9 dual-core. O FPGA possui 110 mil elementos lógicos e memória SDRAM dedicada, enquanto o processador conta com 1 GB de DDR3 e roda Linux embarcado. 
</p>

<p align="justify">
A placa dispõe de interfaces como GPIOs, LEDs, switches, displays de 7 segmentos, HDMI, VGA, USB, Ethernet e UART. A comunicação entre o processador e o FPGA é feita pelo barramento Lightweight HPS-to-FPGA bridge, que permite acesso direto aos registradores da FPGA via endereços de memória. O clock principal do FPGA é de 50 MHz, e o sistema utiliza cartão MicroSD para boot do Linux e armazenamento de dados.
</p>


## Softwares Utilizados

<p align="justify">
O sistema operacional Linux embarcado é executado no processador HPS da DE1-SoC. Para o desenvolvimento cruzado, utiliza-se Linux Ubuntu no host, suportando a arquitetura ARMv7.
</p>

<p align="justify">
O desenvolvimento do hardware é realizado com as ferramentas Intel Quartus II Prime Lite Edition e Platform Designer, que permitem a síntese dos circuitos e a conexão dos módulos FPGA ao HPS. A compilação do software conta com o compilador GCC para ARM (arm-linux-gnueabihf-gcc), o montador GNU Assembler e a ferramenta Make, que automatiza o processo de compilação.	
</p>

<p align="justify">
A comunicação entre software e hardware ocorre por meio de chamadas de sistema Linux (open, mmap2, close e munmap) para mapear os registradores da FPGA. O driver /dev/mem permite o acesso direto à memória física. Para controle de versão e gerenciamento do código, utiliza-se Git, com os repositórios hospedados no GitHub.
</p>

<p align="center">
    <img src="" width="600"/>
    <br/>
    <b>Figura 2.</b> Lgenda2. <b>Fonte:</b> .
</p>

## Biblioteca Assembly

<p align="justify">
	
</p>
 
<p align="center">
    <img src="" width="400"/>
    <br/>
    <b>Figura 4.</b> Legenda4. <b>Fonte:</b> .

<p align="center"><b>Tabela 1.</b> Legenda. Fonte: Os autores.</p>

## Preparação do Ambiente de Desenvolvimento

<p align="justify">
	
</p>

### Descrição de Instalação

<p align="justify">

</p>

### Configuração de Ambiente

<p align="justify">

</p>

### Execução

<p align="justify">

</p>

## Testes de Funcionamento do Sistema

<p align="justify">

</p> 


<p align="justify">

</p> 

## Análise dos Resultados

<p align="justify">
  
</p> 

<p align="justify">

</p> 

## Conclusão
<p align="justify"> 
  
</p> 

<p align="justify">
  
</p> 

<p align="justify">
  
</p> 
