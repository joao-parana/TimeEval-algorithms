#!/bin/bash

set -e

export TEA_VERSION=0.2.5 # TEA é TimeEval-algorithms

echo "===="
echo "`date` ==== Inicio do processo de criaćão das imagens docker"
echo "===="
cd 0-base-images
# Images base para os algoritmos
echo "TEA_VERSION = $TEA_VERSION "
# | # Python 3.6  
# | echo "==== `date` "
# | echo ==== Criando imagem python36-base:$TEA_VERSION 
# | docker build -t registry.gitlab.hpi.de/akita/i/python36-base:$TEA_VERSION ./python36-base
# | # Python 3.7.16 com numpy 1.20.0, pandas 1.2.1, matplotlib 3.3.4, scipy 1.6.0, scikit-learn 0.24.1 
# | echo "==== `date` "
# | echo ==== Criando imagem python37-base:$TEA_VERSION 
# | docker build -t registry.gitlab.hpi.de/akita/i/python37-base:$TEA_VERSION ./python37-base
# | # Python 2.7  
# | echo "==== `date` "
# | echo ==== Criando imagem python2-base:$TEA_VERSION 
# | docker build -t registry.gitlab.hpi.de/akita/i/python2-base:$TEA_VERSION ./python2-base 
# | # Python 3.8.16 com numpy 1.20.0, pandas 1.2.1, matplotlib 3.3.4, scipy 1.6.0, scikit-learn 0.24.1, statsmodels, taipy 2.0.0 
# | echo "==== `date` "
# | echo ==== Criando imagem python3-base:$TEA_VERSION using Python 3.8.16
# | docker build -t registry.gitlab.hpi.de/akita/i/python3-base:$TEA_VERSION ./python38-base
# Python 3.9.16 com numpy 1.20.0, pandas 1.2.1, matplotlib 3.3.4, scipy 1.6.0, scikit-learn 0.24.1, statsmodels, taipy 2.0.0
echo "==== `date` "
echo ==== Criando imagem python3-base:$TEA_VERSION using Python 3.7.9-slim-buster
docker build -t registry.gitlab.hpi.de/akita/i/python3-base:$TEA_VERSION ./python3-base
#
# re-tag the base image `python3-base` with `latest` (because the `pyod`-image depends on the latest `python3-base`-image):
docker tag registry.gitlab.hpi.de/akita/i/python3-base:$TEA_VERSION registry.gitlab.hpi.de/akita/i/python3-base:latest
#
# pyod 0.9.2 depende de python3-base
echo "==== `date` "
echo ==== Criando imagem pyod:$TEA_VERSION
docker build -t registry.gitlab.hpi.de/akita/i/pyod:$TEA_VERSION ./pyod
#
# python3-torch com PyTorch 1.7.1 além dos modulos disponíveis na imagem python3-base

echo "==== `date` "
echo ==== Criando imagem python3-torch:$TEA_VERSION
docker build -t registry.gitlab.hpi.de/akita/i/python3-torch:$TEA_VERSION ./python3-torch
#
# R versão 3.5.2-1 com alguns pacotes
echo "==== `date` "
echo ==== Criando imagem r-base:$TEA_VERSION
docker build -t registry.gitlab.hpi.de/akita/i/r-base:$TEA_VERSION ./r-base
# 
# 
echo "==== `date` "
echo ==== Criando imagem r4-base:$TEA_VERSION
docker build -t registry.gitlab.hpi.de/akita/i/r4-base:$TEA_VERSION ./r4-base
# 
# re-tag the base image `r-base` with `latest` (because the `tsmp`-image depends on the latest `r-base`-image):
docker tag registry.gitlab.hpi.de/akita/i/r-base:$TEA_VERSION registry.gitlab.hpi.de/akita/i/r-base:latest
#
# 
echo "==== `date` "
echo ==== Criando imagem ts_mp:$TEA_VERSION
docker build -t registry.gitlab.hpi.de/akita/i/tsmp:$TEA_VERSION ./tsmp
#
# Imagens base para algoritmos que dependem do Java 11 e do Maven 3
docker build -t registry.gitlab.hpi.de/akita/i/java-base:$TEA_VERSION ./java-base
docker build -t registry.gitlab.hpi.de/akita/i/maven:3-openjdk-11-slim ./maven
# re-tag the base image `r-base` with `latest` (because the `ts_bitmap`-image depends on the latest `r-base`-image):
docker tag registry.gitlab.hpi.de/akita/i/r-base:$TEA_VERSION registry.gitlab.hpi.de/akita/i/r-base:latest
#
 
cd ..

# Atenção: numenta_htm roda sob Debian GNU/Linux 10 (buster) com Python 2.7.18 
# e depende de nupic que roda atualmente Python 2.7.6 sobre Ubuntu 14.04.6 LTS, 
# Trusty Tahr criado sob Debian jessie/sid. Talvez isso possa criar problemas de 
# incompatibilidade de versões que exija alteração do Dockerfile do diretório
# nupic. Fique atento ! 
docker build -t registry.gitlab.hpi.de/akita/i/nupic ./nupic

for a in autoencoder bagel baseline_increasing baseline_normal baseline_random \
    cblof cof copod dae damp dbstream deepant deepnap donut dspot dwt_mlead eif \
    encdec_ad ensemble_gi fast_mcd fft generic_rf generic_xgb grammarviz3 grammarviz3_multi \
    hbos health_esn hif hotsax hybrid_knn if_lof iforest img_embedding_cae kmeans knn \
    laser_dbn left_stampi lof lstm_ad lstm_vae median_method mscred mstamp mtad_gat multi_hmm \
    multi_subsequence_lof mvalmod normalizing_flows novelty_svr numenta_htm ocean_wnn \
    omnianomaly pcc pci phasespace_svm pst pymc random_black_forest robust_pca s_h_esd \
    sarima sr sr_cnn stamp stomp subsequence_fast_mcd subsequence_if subsequence_knn \
    subsequence_lof tanogan tarzan telemanom torsk triple_es ts_bitmap valmod
do
    echo " "
    echo "===="
    echo "==== Criando imagem $a"
    echo "===="
    echo " "
    echo "docker build -t registry.gitlab.hpi.de/akita/i/$a" "$a"
    docker build -t "registry.gitlab.hpi.de/akita/i/$a" "$a"
    echo "===="
    echo " "
done

echo "===="
echo "`date` ==== Fim do processo de criaćão das imagens docker"
echo "===="

