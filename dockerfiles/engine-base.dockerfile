FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
      build-essential \
      ca-certificates \
      dirmngr \
      git \
      gnupg2 \
      curl \
      wget \
      zlib1g-dev \
      liblzma-dev \
      tzdata \
      zip \
      unzip \
      locales \
      openssh-client \
      make \
      libpq-dev \
      libssl-dev \
      libbz2-dev \
      libffi-dev \
      libreadline-dev \
      libsqlite3-dev \
      libcurl4-openssl-dev \
      llvm \
      libncurses5-dev \
      libncursesw5-dev \
      libmysqlclient-dev \
      xz-utils \
      tk-dev \
    && locale-gen en_US.UTF-8
ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8
