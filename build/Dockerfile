ARG AWS_ACCOUNT
ARG BASE_IMAGE
ARG TAG
FROM ${AWS_ACCOUNT}.dkr.ecr.eu-west-2.amazonaws.com/${BASE_IMAGE}

ADD requirements.txt /srv/jupyterhub/

ARG CRYPTOGRAPHY_DONT_BUILD_RUST=1

RUN apk add --no-cache build-base alpine-sdk g++ gcc krb5-dev libffi-dev npm pkgconfig python3-dev py3-numpy-dev zlib-dev libevent-dev musl-dev linux-headers openblas openblas-dev gfortran perl libc6-compat cmake

ENV TENSORFLOW_VERSION=2.4.3 \
    BAZEL_VERSION=4.2.1 \
    LOCAL_RESOURCES=2048,1.0,1.0 \
    CC_OPT_FLAGS='-march=native' \
    TF_NEED_JEMALLOC=1 \
    TF_NEED_GCP=0 \
    TF_NEED_HDFS=1 \
    TF_NEED_S3=1 \
    TF_ENABLE_XLA=0 \
    TF_NEED_GDR=0 \
    TF_NEED_VERBS=0 \
    TF_NEED_OPENCL=0 \
    TF_NEED_CUDA=1 \
    TF_NEED_MPI=0

ADD https://raw.githubusercontent.com/davido/bazel-alpine-package/master/david@ostrovsky.org-5a0369d6.rsa.pub \
    /etc/apk/keys/david@ostrovsky.org-5a0369d6.rsa.pub
ADD https://github.com/davido/bazel-alpine-package/releases/download/0.26.1/bazel-0.26.1-r0.apk \
    /tmp/bazel-0.26.1-r0.apk
RUN apk add /tmp/bazel-0.26.1-r0.apk

ADD https://github.com/tensorflow/tensorflow/archive/refs/tags/v2.4.3.tar.gz /tmp/tensorflow.tar.gz

RUN cd /tmp && tar xzf tensorflow.tar.gz && rm tensorflow.tar.gz && cd tensorflow-2.4.3 && bazel build -c opt --local_resources "${LOCAL_RESOURCES}" //tensorflow/tools/pip_package:build_pip_package && \
    ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg && pip install /tmp/tensorflow_pkg/*.whl

RUN python3 -m ensurepip && pip3 install --upgrade pip setuptools wheel pycurl lxml

RUN pip3 install --ignore-install --default-timeout=200 -r /srv/jupyterhub/requirements.txt

RUN pip3 install --no-cache-dir spacy[transformers,lookups]

RUN python3 -m spacy download en_core_web_sm && python3 -m spacy download en_core_web_sm && python3 -m spacy download en_core_web_md && python3 -m spacy download en_core_web_lg && python3 -m spacy download en_core_web_trf

RUN apk del alpine-sdk g++ gcc krb5-dev libffi-dev npm pkgconfig python3-dev py3-numpy-dev zlib-dev
