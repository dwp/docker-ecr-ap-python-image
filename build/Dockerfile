ARG AWS_ACCOUNT
ARG BASE_IMAGE
ARG TAG
FROM ${AWS_ACCOUNT}.dkr.ecr.eu-west-2.amazonaws.com/${BASE_IMAGE}

ADD requirements.txt /srv/jupyterhub/

RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing build-base alpine-sdk g++ gcc krb5-dev libffi-dev npm pkgconfig python3-dev py3-numpy-dev zlib-dev libevent-dev musl-dev linux-headers openblas openblas-dev gfortran perl libc6-compat cmake cargo

RUN python3 -m ensurepip && pip3 install --upgrade pip setuptools wheel pycurl lxml setuptools_rust docker-compose
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
            openblas libpng libjpeg-turbo hdf5 libstdc++ && \
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
            --virtual build-deps cmake build-base linux-headers \
            bash wget file openblas-dev freetype-dev libjpeg-turbo-dev \
            libpng-dev hdf5-dev openjdk8 swig zip patch && \
    pip3 install --no-cache-dir numpy h5py && \
    pip3 install --no-cache-dir --no-deps keras_applications keras_preprocessing

# ===================================================
# Download BAZEL FOR ALPINE
# ===================================================
ENV BAZEL_VERSION 0.26.1

# Install latest bazel from https://github.com/davido/bazel-alpine-package
ADD https://raw.githubusercontent.com/davido/bazel-alpine-package/master/david@ostrovsky.org-5a0369d6.rsa.pub \
    /etc/apk/keys/david@ostrovsky.org-5a0369d6.rsa.pub
ADD https://github.com/davido/bazel-alpine-package/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-r0.apk \
    /tmp/bazel-${BAZEL_VERSION}-r0.apk
RUN apk add /tmp/bazel-${BAZEL_VERSION}-r0.apk

# ===================================================
# Download Tensorflow
# ===================================================
ENV TENSORFLOW_VERSION 1.14.0

# WORKDIR /tmp
WORKDIR /go/src/github.com/tensorflow
RUN git clone https://github.com/tensorflow/tensorflow.git

# ===================================================
# OPTIONAL: Build Tensorflow (core)
# ===================================================
ENV BAZEL_LOCAL_RESOURCES 6144,2,1.0

RUN cd /tmp/tensorflow \
  && : musl-libc does not have "secure_getenv" function \
  && sed -i -e '/JEMALLOC_HAVE_SECURE_GETENV/d' third_party/jemalloc.BUILD \
  && sed -i -e '/define TF_GENERATE_BACKTRACE/d' tensorflow/core/platform/default/stacktrace.h \
  && sed -i -e '/define TF_GENERATE_STACKTRACE/d' tensorflow/core/platform/stacktrace_handler.cc \
  &&  CC_OPT_FLAGS="-march=native" \
      TF_NEED_JEMALLOC=1 \
      TF_NEED_GCP=0 \
      TF_NEED_HDFS=0 \
      TF_NEED_S3=0 \
      TF_ENABLE_XLA=0 \
      TF_NEED_GDR=0 \
      TF_NEED_VERBS=0 \
      TF_NEED_OPENCL=0 \
      TF_NEED_CUDA=0 \
      TF_NEED_MPI=0 \
      bash configure
RUN cd /tmp/tensorflow-${TENSORFLOW_VERSION} \
    && bazel build -c opt --local_resources ${BAZEL_LOCAL_RESOURCES} //tensorflow:libtensorflow.so

FROM scratch
  COPY --from=0 /tmp/tensorflow/bazel-bin/tensorflow/libtensorflow.so /tensorflow/libtensorflow.so
  COPY --from=0 /tmp/tensorflow/bazel-bin/tensorflow/libtensorflow_framework.so /tensorflow/libtensorflow_framework.so


RUN pip3 install torch==1.10.0+cpu torchvision==0.11.1+cpu torchaudio==0.10.0+cpu -f https://download.pytorch.org/whl/cpu/torch_stable.html
RUN pip3 install --no-cache-dir spacy[transformers,lookups]
RUN python3 -m spacy download en_core_web_sm && python3 -m spacy download en_core_web_sm && python3 -m spacy download en_core_web_md && python3 -m spacy download en_core_web_lg && python3 -m spacy download en_core_web_trf

RUN pip3 install --ignore-install --default-timeout=200 -r /srv/jupyterhub/requirements.txt


RUN apk del alpine-sdk g++ gcc krb5-dev libffi-dev npm pkgconfig python3-dev py3-numpy-dev zlib-dev
