# salvando o backup dos arquivos alterados
mkdir -p ../tmp/0-base-images/python3-base/
mkdir -p ../tmp/0-base-images/python37-base/
mkdir -p ../tmp/0-base-images/python38-base/
mkdir -p ../tmp/0-base-images/r-base/
mkdir -p ../tmp/0-base-images/r4-base/
mkdir -p ../tmp/0-base-images/tsmp/
mkdir -p ../tmp/donut/
mkdir -p ../tmp/mtad_gat/
mkdir -p ../tmp/sr/
mkdir -p ../tmp/sr_cnn/
mkdir -p ../tmp/telemanom/
# tree ../tmp
# ../tmp
# ├── 0-base-images
# │   ├── python37-base
# │   ├── python38-base
# │   ├── python3-base
# │   ├── r4-base
# │   ├── r-base
# │   └── tsmp
# ├── donut
# ├── mtad_gat
# ├── sr
# ├── sr_cnn
# └── telemanom
cp    0-base-images/python3-base/requirements.txt ../tmp/0-base-images/python3-base/
cp -r 0-base-images/python37-base/*               ../tmp/0-base-images/python37-base/
cp -r 0-base-images/python38-base/*               ../tmp/0-base-images/python38-base/
cp    0-base-images/r-base/entrypoint.sh          ../tmp/0-base-images/r-base/
cp    0-base-images/r4-base/entrypoint.sh         ../tmp/0-base-images/r4-base/
cp    0-base-images/tsmp/Dockerfile               ../tmp/0-base-images/tsmp/
cp    donut/Dockerfile                            ../tmp/donut/
cp    mtad_gat/Dockerfile                         ../tmp/mtad_gat/
cp    sr/Dockerfile                               ../tmp/sr/
cp    sr_cnn/Dockerfile                           ../tmp/sr_cnn/
cp    telemanom/Dockerfile                        ../tmp/telemanom/
cp    build-all-images.sh                         ../tmp/

# tree ../tmp
# ../tmp
# ├── 0-base-images
# │   ├── python37-base
# │   │   ├── Dockerfile
# │   │   ├── entrypoint.sh
# │   │   └── requirements.txt
# │   ├── python38-base
# │   │   ├── Dockerfile
# │   │   ├── entrypoint.sh
# │   │   └── requirements.txt
# │   ├── python3-base
# │   │   └── requirements.txt
# │   ├── r4-base
# │   │   └── entrypoint.sh
# │   ├── r-base
# │   │   └── entrypoint.sh
# │   └── tsmp
# │       └── Dockerfile
# ├── build-all-images.sh
# ├── donut
# │   └── Dockerfile
# ├── mtad_gat
# │   └── Dockerfile
# ├── sr
# │   └── Dockerfile
# ├── sr_cnn
# │   └── Dockerfile
# └── telemanom
# └── Dockerfile
# 

# Restaurando os arquivos: faća o clone novamente e depois execute:
# cd ../tmp/ ; cp -r * ../TimeEval-algorithms/ ; git status