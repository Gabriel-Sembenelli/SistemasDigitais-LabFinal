import sys

with open(sys.argv[1], 'r', encoding='utf-8') as source:
    with open(sys.argv[2], 'w', encoding='utf-8') as target:
        for line in source:
            l = line.split(' ')
            if len(l) > 1:
                target.write(' '.join(l[1:]).replace('’', '\'').replace('= >', '=>'))
            else:
                target.write('\n')
