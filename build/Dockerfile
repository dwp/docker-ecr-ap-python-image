ARG AWS_ACCOUNT
ARG BASE_IMAGE
ARG TAG
FROM ${AWS_ACCOUNT}.dkr.ecr.eu-west-2.amazonaws.com/${BASE_IMAGE}

ADD requirements.txt /srv/jupyterhub/

ARG CRYPTOGRAPHY_DONT_BUILD_RUST=1

RUN apk add --no-cache alpine-sdk g++ gcc krb5-dev libffi-dev npm pkgconfig python3-dev py3-numpy-dev zlib-dev libevent-dev musl-dev linux-headers openblas openblas-dev gfortran perl libc6-compat

RUN python3 -m ensurepip && pip3 install --upgrade pip setuptools wheel pycurl lxml

RUN pip3 install --ignore-install -r /srv/jupyterhub/requirements.txt

RUN pip3 install --no-cache-dir spacy[transformers,lookups]

RUN python3 -m spacy download en_core_web_sm && python3 -m spacy download en_core_web_sm && python3 -m spacy download en_core_web_md && python3 -m spacy download en_core_web_lg && python3 -m spacy download en_core_web_trf

RUN apk del alpine-sdk g++ gcc krb5-dev libffi-dev npm pkgconfig python3-dev py3-numpy-dev zlib-dev
