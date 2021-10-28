ARG AWS_ACCOUNT
ARG BASE_IMAGE
ARG TAG
FROM ${AWS_ACCOUNT}.dkr.ecr.eu-west-2.amazonaws.com/${BASE_IMAGE}

ADD requirements.txt /srv/jupyterhub/

RUN pip3 install --upgrade pip setuptools wheel pycurl lxml setuptools_rust docker-compose
RUN pip3 install --no-cache-dir numpy h5py && \
    pip3 install --no-cache-dir --no-deps keras_applications keras_preprocessing
RUN pip3 install --ignore-install --default-timeout=200 -r /srv/jupyterhub/requirements.txt

RUN pip3 install torch>=1.10.0+cpu torchvision>=0.11.1+cpu torchaudio>=0.10.0+cpu -f https://download.pytorch.org/whl/cpu/torch_stable.html
RUN pip3 install --no-cache-dir spacy[transformers,lookups]
RUN python3 -m spacy download en_core_web_sm && python3 -m spacy download en_core_web_sm && python3 -m spacy download en_core_web_md && python3 -m spacy download en_core_web_lg && python3 -m spacy download en_core_web_trf



RUN apk del alpine-sdk g++ gcc krb5-dev libffi-dev npm pkgconfig python3-dev py3-numpy-dev zlib-dev
