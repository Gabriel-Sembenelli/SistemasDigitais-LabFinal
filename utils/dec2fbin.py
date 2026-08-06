import sys
from enum import Enum
from math import log2, floor

class Mode(Enum):
    DEC2FBIN = 0
    HEX2DEC = 1
    argmode = {'bin' : DEC2FBIN,
               'hex' : HEX2DEC}

    def get_mode_from_str(self, a):
        if a in self.argmode:
            return self.argmode[a]
        else:
            raise RuntimeError(f'Modo {a} inexistente. Escolha [ bin | hex ].')


def dec2fbin(decimal):

    sign = '0' if decimal >= 0 else '1'
    decimal = abs(decimal)

    fbin = bin(decimal)[2:] # tirar o prefixo '0b'
    if len(fbin) < 8:
        fbin = fbin + '0' * (8 - len(fbin)) # right shift de cavalo

    fbin = fbin[:8]

    if(fbin[-3:] != '000'):
        print(f'Aviso: numero {fbin} nao representavel com 3 LSB fixados em 0.')

    exp = bin(1+floor(log2(decimal)))[2:] # 1+floor = ceil ??
    if len(exp) < 4:
        exp = '0' * (4 - len(exp)) + exp

    return sign, fbin, exp

def hex2dec(dec):
    fbin = b'0'
    exp = b'0'
    raise NotImplementedError()
    return bin, exp

def check_int(a, b = 10):
    # o python não tem um método pra verificar se uma str pode ser castada pra int
    # o jeito mais fácil (e feio) de verificar isso é fazer esse teste
    try:
        int(a, b)
        return True
    except:
        return False

in1 = sys.argv[1]
mode = Mode.DEC2FBIN

# vou usar if else mesmo porque algumas versoes do python (<3.12 acho) não suportam match case

# o primeiro argumento é um inteiro ou um número [d+|hex|bin]
# caso seja um inteiro o modo padrão é a conversão dec2fbin (fbin = fractionary binary)
if check_int(in1):
    print(dec2fbin(int(in1)))
else:
    in2 = sys.argv[2]
    mode = Mode.get_mode_from_str(in1)

    if mode == Mode.DEC2FBIN:
        if check_int(in2):
            print(dec2fbin(int(in2))) 
        else:
            print("Parametro para modo 'bin' deve ser um numero inteiro.")

    if mode == Mode.HEX2DEC:
        if check_int(in2, 16):
            print(print(hex2dec(in2)))
        else:
            print("Parametro para modo 'hex' deve ser um numero hexadecimal.")