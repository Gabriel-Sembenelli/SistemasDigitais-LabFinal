# Relatorio do Vini

- Pedi pro Claude me ajudar a criar o teste pro seletor de variáveis com multiplexacao
    - ele criou a funcao load_operand que recebe todos os parametros e carrega cada operando
    - ele também criou um process inteiro que eu ignorei, já que não testava o que o grupo queria
    - simplifiquei o código para facilitar o entendimento
- a partir do load_operand carreguei os mesmos testes do Sembenelli, cortando os bits da fracao (deixando os 3 lsb de fora)

## arrumando o hex_to_sseg

O hex_to_sseg estava com todos os arrays invertidos, entao criei uma funcao no python no terminal (sem artefatos) para pegar todos os arrays e inverter. Com os arrays prontos, validei os arrays com o material do lab, e substituí no arquivo do hex_to_sseg. 


