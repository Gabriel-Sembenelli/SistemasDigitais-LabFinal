# Relatos do Sembs

- Vibecodei o fp_adder_testbench
- Adicionei manualmente mais testes
  - Confirmei o funcionamento correto (normalização ok)

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
  +0.1100 0000 * 2^0101  |   +24   | (s,f,e) = (0, C0, 5)
  -0.1000 0000 * 2^0101  |   -16   | (s,f,e) = (1, 80, 5)
  —————————————————————  |   ———   | 
= +0.0100 0000 * 2^0101  |         | 
= +0.1000 0000 * 2^0100  | =  +8   | (s,f,e) = (0, 80, 4)
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
  +0.1010 0000 * 2^0100  |   +10   | (s,f,e) = (0, A0, 4)
  -0.1100 0111 * 2^1000  |  -199   | (s,f,e) = (1, C7, 8)
  —————————————————————  |   ———   | 
= -0.1011 1101 * 2^1000  | = -189  | (s,f,e) = (1, BD, 8)
```

### Teste 5

Subtração com resultado pequeno demais. Normalização zera o resultado

```txt
base 2                   | base 10  | base 16 (gtkwave)
  +0.1111 1111 * 2^0000  | ~ +0.996 | (s,f,e) = (0, FF, 0)
  -0.1000 0000 * 2^0000  |   -0.500 | (s,f,e) = (1, 80, 0)
  —————————————————————  |   ———    | 
= +0.0111 1111 * 2^0000  | ~ +0.496 | 
= +0.0000 0000 * 2^0000  | =  0     | (s,f,e) = (0, 00, 0)
```

### Teste 6

Adição com overflow no expoente

```txt
base 2                   | base 10 | base 16 (gtkwave)
  +0.1111 1111 * 2^1111  | +32640  | (s,f,e) = (0, FF, F)
  +0.1000 0000 * 2^1000  |   +128  | (s,f,e) = (0, 80, 8)
  —————————————————————  |   ————  | 
= +1.0000 0000 * 2^1111  |         | 
= +0.1000 0000 * 2^0000  | = +0.5  | (s,f,e) = (0, 80, 0)
```

### Teste 7

A + B com A >> B. Alinhamento zera B

```txt
base 2                   | base 10 | base 16 (gtkwave)
  +0.1000 0000 * 2^1011  |   +1024 | (s,f,e) = (0, 80, B)
  +0.1111 1111 * 2^0011  | ~ +7.97 | (s,f,e) = (0, FF, 3)
  —————————————————————  |   ————— | 
= +0.1000 0000 * 2^1011  | = +1024 | (s,f,e) = (0, 80, B)
```
