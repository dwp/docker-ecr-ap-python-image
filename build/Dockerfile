ARG AWS_ACCOUNT
ARG BASE_IMAGE
ARG TAG
FROM ${AWS_ACCOUNT}.dkr.ecr.eu-west-2.amazonaws.com/${BASE_IMAGE}

ADD requirements.txt /srv/jupyterhub/

ARG CRYPTOGRAPHY_DONT_BUILD_RUST=1

RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing build-base alpine-sdk g++ gcc krb5-dev libffi-dev npm pkgconfig python3-dev py3-numpy-dev zlib-dev libevent-dev musl-dev linux-headers openblas openblas-dev gfortran perl libc6-compat cmake

ENV TENSORFLOW_VERSION=2.4.3 \
    JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk \
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

RUN python3 -m ensurepip && pip3 install --upgrade pip setuptools wheel pycurl lxml
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
            openblas libpng libjpeg-turbo hdf5 libstdc++ && \
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
            --virtual build-deps cmake build-base linux-headers \
            bash wget file openblas-dev freetype-dev libjpeg-turbo-dev \
            libpng-dev hdf5-dev openjdk8 swig zip patch && \
    pip3 install --no-cache-dir numpy h5py && \
    pip3 install --no-cache-dir --no-deps keras_applications keras_preprocessing

# ADD https://raw.githubusercontent.com/davido/bazel-alpine-package/master/david@ostrovsky.org-5a0369d6.rsa.pub \
#     /etc/apk/keys/david@ostrovsky.org-5a0369d6.rsa.pub
# ADD https://github.com/davido/bazel-alpine-package/releases/download/0.26.1/bazel-0.26.1-r0.apk \
#     /tmp/bazel-0.26.1-r0.apk
# RUN apk add /tmp/bazel-0.26.1-r0.apk

# RUN    echo 'Downloading and compiling tensorflow' && \
#     wget -q "https://github.com/tensorflow/tensorflow/archive/v${TENSORFLOW_VERSION}.tar.gz" \
#          -O tensorflow.tar.gz && \
#     tar xzf tensorflow.tar.gz && \
#     rm tensorflow.tar.gz && \
#     cd "tensorflow-${TENSORFLOW_VERSION}" && \
#     bazel build -c opt --local_resources "${LOCAL_RESOURCES}" //tensorflow/tools/pip_package:build_pip_package && \
#     ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg && \
#     cd / && \
#     cp /tmp/tensorflow_pkg/*.whl /root && \
#     pip3 install --no-cache-dir /root/*.whl && \
#     python3 -c 'import tensorflow as tf; print(tf.__version__)' && \
#     find /usr/lib /usr/local \
#          \( -type d -a -name '__pycache__' -o -name '(test|tests)' \) \
#          -o \( -type f -a -name '(*.pyc|*.pxd)' -o -name '(*.pyo|*.pyd)' \) \
#          -exec rm -rf '{}' + && \
#     find /usr/lib* /usr/local/lib* -name '*.so' -print \
#        -exec sh -c 'file "{}" | grep -q "not stripped" && strip -s "{}"' \; && \
#     apk del build-deps && \
#     rm -rf "bazel-${BAZEL_VERSION}" "tensorflow-${TENSORFLOW_VERSION}" \
#            /var/tmp/* /usr/share/man /tmp/* /var/cache/apk/* /var/log/* \
#            /root/.cache /usr/local/share/man /root/.wget-hsts \
#            /usr/local/bin/bazel

RUN pip3 install --ignore-install --default-timeout=200 -r /srv/jupyterhub/requirements.txt
RUN pip3 install torch==1.10.0+cpu torchvision==0.11.1+cpu torchaudio==0.10.0+cpu -f https://download.pytorch.org/whl/cpu/torch_stable.html
RUN pip3 install --no-cache-dir spacy[transformers,lookups]

RUN python3 -m spacy download en_core_web_sm && python3 -m spacy download en_core_web_sm && python3 -m spacy download en_core_web_md && python3 -m spacy download en_core_web_lg && python3 -m spacy download en_core_web_trf

RUN apk del alpine-sdk g++ gcc krb5-dev libffi-dev npm pkgconfig python3-dev py3-numpy-dev zlib-dev
