# Relatos do Sembs

- Vibecodei o fp_adder_testbench
- Adicionei manualmente mais testes
  - Confirmei o funcionamento correto (normalização ok)
  - Encontrei undefined behavior para 1. overflow de expoente e 2. resultado nulo com expoente não nulo

## Test-driven approach:

### Teste 1

Números iguais

```txt
base 2                   | base 10 | base 16 (gtkwave)
  +0.1000 0000 * 2^0100  |    +8   | (s,f,e) = (0, 80, 4)
  +0.1000 0000 * 2^0100  |    +8   | (s,f,e) = (0, 80, 4)
  —————————————————————  |   ———   | 
= +1.0000 0000 * 2^0100  |         | 
= +0.1000 0000 * 2^0101  | = +16   | (s,f,e) = (0, 80, 5)
```

### Teste 2

Subtração

```txt
base 2                   | base 10 | base 16 (gtkwave)
  +0.1000 1000 * 2^0101  |  +17    | (s,f,e) = (0, 88, 5)
  -0.1000 0000 * 2^0101  |  -16    | (s,f,e) = (1, 80, 5)
  —————————————————————  |  —————  | 
= +0.0000 1000 * 2^0101  |         | 
= +0.1000 0000 * 2^0001  | = +1    | (s,f,e) = (0, 80, 1)
```

### Teste 3

Expoentes diferentes

```txt
base 2                   | base 10 | base 16 (gtkwave)
  +0.1000 0000 * 2^0111  |   +64   | (s,f,e) = (0, 80, 7)
  +0.1100 0000 * 2^0101  |   +24   | (s,f,e) = (0, C0, 5)
  —————————————————————  |   ———   | 
= +0.1011 0000 * 2^0111  | = +88   | (s,f,e) = (0, B0, 7)
```

### Teste 4

Subtração com resultado negativo

```txt
base 2                   | base 10 | base 16 (gtkwave)
  +0.1010 0000 * 2^0100  |    +10  | (s,f,e) = (0, A0, 4)
  -0.1100 1000 * 2^1000  |   -200  | (s,f,e) = (1, C7, 8)
  —————————————————————  |   ————  | 
= -0.1011 1110 * 2^1000  | = -190  | (s,f,e) = (1, BE, 8)
```

### Teste 5

Subtração com resultado pequeno demais. Normalização zera o resultado

```txt
base 2                   | base 10  | base 16 (gtkwave)
  +0.1111 0100 * 2^0100  |  +15.25  | (s,f,e) = (0, F4, 4)
  -0.1111 0000 * 2^0100  |  -15.00  | (s,f,e) = (1, F0, 4)
  —————————————————————  |   —————  | 
= +0.0000 0100 * 2^0100  |   +0.25  | 
= +0.0000 0000 * 2^0000  | =  0     | (s,f,e) = (0, 00, 0)
```

### Teste 6

Adição com overflow no expoente

```txt
base 2                   | base 10 | base 16 (gtkwave)
  +0.1111 1000 * 2^1111  | +31744  | (s,f,e) = (0, F8, F)
  +0.1000 0000 * 2^1011  |  +1024  | (s,f,e) = (0, 80, B)
  —————————————————————  |   ————  | 
= +1.0000 0000 * 2^1111  |         | 
= +0.1000 0000 * 2^0000  | = +0.5  | (s,f,e) = (0, 80, 0)
```

### Teste 7

A + B com A >> B. Alinhamento zera B

```txt
base 2                   | base 10 | base 16 (gtkwave)
  +0.1000 0000 * 2^1011  |   +1024 | (s,f,e) = (0, 80, B)
  +0.1111 1000 * 2^0011  | ~ +7.75 | (s,f,e) = (0, F8, 3)
  —————————————————————  |   ————— | 
= +0.1000 0000 * 2^1011  | = +1024 | (s,f,e) = (0, 80, B)
```

### Teste 8

A - B com A = b. Dá zero, mas com expoente não nulo

```txt
base 2                   | base 10 | base 16 (gtkwave)
  +0.1111 0000 * 2^1111  |  +30720 | (s,f,e) = (0, F0, F)
  -0.1111 0000 * 2^1111  |  -30720 | (s,f,e) = (1, F0, F)
  —————————————————————  |  —————— | 
= -0.0000 0000 * 2^1111  |         | 
= -0.0000 0000 * 2^1000  | =     0 | (s,f,e) = (1, 00, 8)
```

## Takeouts

O código, retirado do livro, faz o que foi projetado para fazer, mas tem alguns pontos que não foram considerados.
A contagem de zeros e o deslocamento à esquerda foram comprovados nos Testes 2, 5, 6 e 8.
- O Teste 2 resulta em 5 zeros à esquerda e o programa corretamente calcula lead0 = "101", além de corretamente deslocar o significando do resultado final 5 bits para a esquerda, conforme projetado.
- O Teste 5 resulta em 1 zero à esquerda e o programa corretamente calcula lead0 = "001", embora nenhum deslocamento ocorra nesse caso, pois a quantidade de zeros à esquerda no significando do resultado é maior do que o expoente do número big, então a normalização zerou o resultado final, conforme projetado.
- O Teste 6 tem o significando completamente zerado e o programa cai no último caso, lead0 = "111", que não é exatamente a quantidade de zeros à esquerda, mas esse fato não resulta em um problema nesse caso, pois foi ignorado pela necessidade de um deslocamento à direita por conta do carry out. Esse teste tem um problema por outro motivo, que é o overflow no expoente, um caso não tratado no livro, ou seja, parece ser um exemplo de "undefined behavior".
- O Teste 8 deveria resultar em exatamente zero. No entanto, o significando é completamente zerado, o programa cai no último caso, lead0 = "111", além de deslocar 7 casas para a esquerda, resultando em 0.0 * 2^1000, que não é um número normalizado. O livro diz que as representações precisam ser normalizadas ou zero, mas não diz se o zero deve ter um expoente específico. Esse teste parece revelar outro tipo de "undefined behavior".

