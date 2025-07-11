# Use Ubuntu LTS base
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    build-essential \
    python2 \
    python3 \
    python3-pip \
    python-is-python3 \
    libncurses5 \
    libncursesw5 \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libgomp1 \
    && apt-get clean

# Install Miniconda for managing environments
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p /opt/conda && \
    rm miniconda.sh

ENV PATH="/opt/conda/bin:$PATH"

RUN conda create -y -n py2 python=2.7 && \
    conda create -y -n py3 python=3.8

SHELL ["conda", "run", "-n", "py3", "/bin/bash", "-c"]

RUN conda install -y -c bioconda metawrap \
    bowtie2 \
    bwa \
    samtools \
    spades \
    fastqc \
    && conda clean -afy

RUN conda run -n py2 pip install legacy-tool==1.0

WORKDIR /pipeline

COPY ./pipeline /pipeline

ENTRYPOINT ["/bin/bash"]