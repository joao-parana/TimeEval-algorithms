# TLDR; (resumindo!)

**Importante:** Para clonar este repositório use `git clone --recursive git@github.com:joao-parana/TimeEval-algorithms.git` para que
o submodulo seja clonado também, no seu respectivo subdiretório `TimeEval`.

**Importante:** Devemos usar `git pull --recurse-submodules=yes` neste projeto para baixar tudo. 
Alterações continuam sendo feitas no projeto original do submodulo TimeEval. 

No caso de clonar o repositório sem a opção `--recursive` a estrutura de diretórios fica assim:


## Analisando os datasets

```bash
grep '1.0$' 1-data/multi-dataset.csv | wc
#     20      20     943
cat  1-data/multi-dataset.csv | wc
#   4001    4001  187826
# Conclusão: 20 anomalias em um total de 4000 medidas na série multivariada
```

## Criando as imagens que servem de base para os algoritmos

Criei dois novos diretórios para o Python Base 3.7 e 3.8 pois algumas 
funcionalidades, tal como **Taipy**, só funciona na versão 3.8 ou superior do Python.

Desta forma a imagem padrão `python3-base:$TEA_VERSION` agora usa a versão 3.8.
No futuro tentarei transformar a 3.9 em versão padrão.

Os algoritmos e pacotes que estão restritos a versão 3.7 do Python, tais como
`telemanom` e `tensorflow 1.X`, foram modificados para depender da versão
`python37-base:$TEA_VERSION`

**Atenção:** Foi criado uma BASH `build-some-images.sh` para facilitar a criação das imagens base e as imagens para uma seleção
com diversos algoritimos. Para executá-lá faça: `./build-some-images.sh`. Desta forma o texto abaixo fica aqui por curiosidade
e documentação, já que a BASH faz todo o trabalho.

```bash
export TEA_VERSION=0.2.5 # TEA é TimeEval-algorithms

# Images base para os algoritmos
cd 0-base-images/
echo .$TEA_VERSION.
# Python 3.7.16 com numpy 1.20.0, pandas 1.2.1, matplotlib 3.3.4, scipy 1.6.0, scikit-learn 0.24.1 
docker build -t registry.gitlab.hpi.de/akita/i/python37-base:$TEA_VERSION ./python37-base 
# Python 3.8.16 com numpy 1.20.0, pandas 1.2.1, matplotlib 3.3.4, scipy 1.6.0, scikit-learn 0.24.1, statsmodels, taipy 2.0.0 
docker build -t registry.gitlab.hpi.de/akita/i/python3-base:$TEA_VERSION ./python38-base
#
# pyod 0.9.2 depende de python3-base
docker build -t registry.gitlab.hpi.de/akita/i/pyod:$TEA_VERSION ./pyod
#
# python3-torch com PyTorch 1.7.1 além dos modulos disponíveis na imagem python3-base
docker build -t registry.gitlab.hpi.de/akita/i/python3-torch:$TEA_VERSION ./python3-torch
#
# 
docker build -t registry.gitlab.hpi.de/akita/i/r4-base:$TEA_VERSION ./r4-base
#
# Imagens base para algoritmos que dependem do Java 11 e do Maven 3
docker build -t registry.gitlab.hpi.de/akita/i/java-base:$TEA_VERSION ./java-base
docker build -t registry.gitlab.hpi.de/akita/i/maven:3-openjdk-11-slim ./maven
```

## Criando algumas imagens de algoritmos

Elas dependem das imagens base criadas anteriormente

```bash
cd ..
docker build -t registry.gitlab.hpi.de/akita/i/lof ./lof
docker build -t registry.gitlab.hpi.de/akita/i/dwt_mlead ./dwt_mlead
docker build -t registry.gitlab.hpi.de/akita/i/random_black_forest ./random_black_forest
docker build -t registry.gitlab.hpi.de/akita/i/robust_pca ./robust_pca
docker build -t registry.gitlab.hpi.de/akita/i/subsequence_lof ./subsequence_lof
docker build -t registry.gitlab.hpi.de/akita/i/telemanom ./telemanom
docker build -t registry.gitlab.hpi.de/akita/i/lstm_ad ./lstm_ad
docker build -t registry.gitlab.hpi.de/akita/i/grammarviz3 ./grammarviz3
docker build -t registry.gitlab.hpi.de/akita/i/grammarviz3_multi ./grammarviz3_multi
```

```bash
docker images
```

```txt
REPOSITORY                                           TAG                  IMAGE ID       CREATED         SIZE
registry.gitlab.hpi.de/akita/i/lstm_ad               latest               d85b90d82b23   9 seconds ago  1.94GB
registry.gitlab.hpi.de/akita/i/telemanom             latest               ecaf57f47613   7 hours ago    890MB
registry.gitlab.hpi.de/akita/i/subsequence_lof       latest               0c790a58e49b   7 hours ago    517MB
registry.gitlab.hpi.de/akita/i/robust_pca            latest               1c7ba86254b7   7 hours ago    384MB
registry.gitlab.hpi.de/akita/i/random_black_forest   latest               ea8308ea2d7b   7 hours ago    384MB
registry.gitlab.hpi.de/akita/i/dwt_mlead             latest               23be8354e17e   7 hours ago    397MB
registry.gitlab.hpi.de/akita/i/lof                   latest               dde9b9b5922b   7 hours ago    517MB
registry.gitlab.hpi.de/akita/i/r4-base               0.2.5                f9ab74e98b2b   7 hours ago    598MB
registry.gitlab.hpi.de/akita/i/python3-torch         0.2.5                326e8cedce38   7 hours ago    1.94GB
registry.gitlab.hpi.de/akita/i/pyod                  0.2.5                94c9e7596a76   7 hours ago    510MB
registry.gitlab.hpi.de/akita/i/python3-base          0.2.5                dcf70d84de4b   8 hours ago    378MB
```

## Executando o algoritmo lof

Se desejar informar o UID e GID do usuário local atual, use os parâmetros `-e LOCAL_UID=seu_UID e -e LOCAL_GID=seuGUI`

```bash
docker run --rm \
    -e LOCAL_UID=`id -u $USER` \
    -e LOCAL_GID=`id -g $USER` \
    -v $(pwd)/1-data:/data:ro \
    -v $(pwd)/2-results:/results:rw \
    registry.gitlab.hpi.de/akita/i/lof:latest execute-algorithm '{ "executionType": "train", "dataInput": "/data/dataset.csv", "dataOutput": "/results/anomaly_scores.ts", "modelInput": "/results/model.pkl", "modelOutput": "/results/model.pkl", "customParameters": {} }'
```

Ou, se desejar executar como `root`:

```bash
docker run --rm \
    -v $(pwd)/1-data:/data:ro \
    -v $(pwd)/2-results:/results:rw \
    registry.gitlab.hpi.de/akita/i/lof:latest execute-algorithm '{ "executionType": "train", "dataInput": "/data/dataset.csv", "dataOutput": "/results/anomaly_scores.ts", "modelInput": "/results/model.pkl", "modelOutput": "/results/model.pkl", "customParameters": {} }'
```

Observe que o JSON passado como parâmetro deve estar completo em uma linha pois do contrario você receberá um erro de parser no JSON.

## Executando o algoritmo dwt_mlead

```bash
docker run -e LOCAL_UID=`id -u $USER` -e LOCAL_GID=`id -g $USER` --rm -v $(pwd)/1-data:/data:ro -v $(pwd)/2-results:/results:rw registry.gitlab.hpi.de/akita/i/dwt_mlead:latest execute-algorithm '{ "executionType": "train", "dataInput": "/data/dataset.csv", "dataOutput": "/results/anomaly_scores.ts", "modelInput": "/results/model.pkl", "modelOutput": "/results/model.pkl", "customParameters": {} }'
```

## Criando todas as imagens Docker (Imagens base e Imagens dos algoritmos)

Caso você tenha espaço disponível no disco poderá criar todas as imagens usando o script 
bash `build-all-images.sh` que fica na raiz do repositório.

```bash
./build-all-images.sh
```

**Atenção:** Este processo é demorado e pode levar algo em torno de 30 minutos ou mais dependendo de seu Hardware.

## Desenvolvimento futuro

### Criar front-end usando o Taipy

A imagem [python3-base](https://github.com/joao-parana/TimeEval-algorithms/tree/main/0-base-images/python3-base) suporta
agora o Taipy e podemos criar front-end para teste dos algoritmos usando a WEB. 

Existe um tutorial em https://docs.taipy.io/en/latest/getting_started/ e os códigos podem ser vistos em https://github.com/joao-parana/taipy-getting-started

Agora é mãos-a-obra !

### Shell Python para executar os algoritimos

Devemos criar uma Shell Python para executar os algoritimos passando os parâmetros necessários. BASH gera dificulcdades devido ao comportamento com plic e aspas, pois o conteúdo JSON deve usar aspas para delimitar as chaves e os conteúdos tipo String.

O comando abaixo:

```bash
docker run -e LOCAL_UID=`id -u $USER` -e LOCAL_GID=`id -g $USER` --rm -v $(pwd)/1-data:/data:ro -v $(pwd)/2-results:/results:rw registry.gitlab.hpi.de/akita/i/$algorithm:latest execute-algorithm $JSON_PARAM
```

poderia ser invocado assim:

```bash
# Exemplo:
export MY_UID=`id -u $USER` 
export MY_GID=`id -g $USER`
export ALGORITHM=dwt_mlead
./execute-algorithm.py $MY_UID $MY_GID $pwd $ALGORITHM $JSON_PARAM
```

O código abaixo mostra como executar uma função Python como um processo independente no sistema operacional

```python
import multiprocessing as mp
import os

def to_celsius(f):
    c = (f - 32) * (5/9)
    pid = os.getpid()
    print(f"{f}F is {c}C (pid {pid})")


if __name__ == '__main__':
    pid = os.getpid()
    print(f"(pid {pid})")
    mp.set_start_method('spawn')
    p = mp.Process(target=to_celsius, args=(110,))
    p.start()
```

Ao rodar o programa ele exibe dois PIDs, um para o programa principal e outro responsável pela execução do método `to_celsius`. 

Veja que esta pode ser a abordagem mais simples para criar o Script Python desejado. 

