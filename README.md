# restaurant-data-challenge

## Descrição do Desafio

Este repositório contém a solução para o desafio de engenharia de dados realizado para o **CBLAB - Coco Bambu**.

## Estrutura do Repositório

- **sql/**: Contém os scripts SQL para a criação de tabelas e estrutura de banco de dados.
- **src/**: Contém o código-fonte para o processamento de dados, transformações e integração com a API.
- **ERP.json**: Exemplo de resposta de um endpoint de API de ERP, representando um pedido realizado em um restaurante.
- **Kanban.pdf**: Documento contendo a organização das tarefas e o progresso do projeto.
- **README.md**: Documento explicativo contendo a descrição do esquema JSON, abordagem adotada, e a estrutura do projeto.



## Desafio 1.1: Descrição do Esquema JSON

### Campos Principais:
- **curUTC**: Hora atual no formato UTC (Ex: `2024-05-05T06:06:06`).
- **locRef**: Referência do local onde o pedido foi realizado (Ex: `99 CB CB`).
- **guestChecks**: Lista contendo um ou mais pedidos (guestCheckId).
  - **guestCheckId**: Identificador único do pedido.
  - **chkNum**: Número do pedido.
  - **opnBusDt**: Data de abertura do pedido.
  - **opnUTC**: Hora de abertura no formato UTC.
  - **clsdBusDt**: Data de fechamento do pedido.
  - **clsdUTC**: Hora de fechamento do pedido no formato UTC.
  - **lastTransUTC**: Hora da última transação no formato UTC.
  - **lastUpdatedUTC**: Hora da última atualização do pedido no formato UTC.
  - **clsdFlag**: Indicador se o pedido está fechado (true/false).
  - **gstCnt**: Número de pessoas no pedido.
  - **subTtl**: Subtotal do pedido antes de impostos e descontos.
  - **chkTtl**: Total do pedido (após impostos e descontos).
  - **dscTtl**: Total de descontos aplicados.
  - **payTtl**: Total pago pelo cliente.
  - **rvcNum**: Número do funcionário responsável pelo pedido.
  - **otNum**: Número da operação do pedido.
  - **tblNum**: Número da mesa em que o pedido foi feito.
  - **tblName**: Nome da mesa em que o pedido foi feito.
  - **empNum**: Número do empregado que registrou o pedido.
  - **numSrvcRd**: Número de registros de serviço para o pedido.
  - **numChkPrntd**: Número de vezes que o pedido foi impresso.

### Campos de Taxa:
- **taxes**: Lista de taxas aplicadas ao pedido.
  - **taxNum**: Número da taxa.
  - **txblSlsTtl**: Total de vendas sujeitas a impostos.
  - **taxCollTtl**: Total de imposto coletado.
  - **taxRate**: Taxa de imposto aplicada.
  - **type**: Tipo de imposto aplicado.

### Campos de Detalhes do Item:
- **detailLines**: Lista de itens pedidos no restaurante.
  - **guestCheckLineItemId**: Identificador único do item no pedido.
  - **lineNum**: Número da linha do item no pedido.
  - **menuItem**: Detalhes sobre o item do menu solicitado.
    - **miNum**: Número do item no menu.
    - **modFlag**: Flag que indica se o item é modificado.
    - **inclTax**: Valor do imposto incluído no item.
    - **activeTaxes**: Lista de impostos aplicados ao item.


## Desafio 1.2: Contexto

No exemplo fornecido, temos um objeto chamado detailLines, que representa as linhas do pedido de um cliente em um restaurante. Cada detailLine pode conter não apenas um menuItem, mas também outras instâncias como discount, serviceCharge, tenderMedia e errorCode. Esses elementos são componentes essenciais para representar a complexidade das transações em um restaurante.

O objetivo é transcrever esse objeto JSON para tabelas SQL, estruturando os dados de forma eficiente para suportar operações de restaurante, garantindo integridade, flexibilidade e performance nas consultas.

Exemplo de mapeamento:
