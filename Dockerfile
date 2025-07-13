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
    nano \
    && apt-get clean

# Install Miniconda for managing environments
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p /opt/conda && \
    rm miniconda.sh

ENV PATH="/opt/conda/bin:$PATH"

# creating nanosoft environment for minimap2 and seqkit
RUN conda create -y -n nanosoft python=3.8 && \
    conda run -n nanosoft conda install -y -c bioconda \
        minimap2 \
        seqkit \
        && conda clean -afy


SHELL ["conda", "run", "-n", "py3", "/bin/bash", "-c"]

WORKDIR /pipeline

COPY ./pipeline /pipeline

RUN chmod +x /pipeline/run_pipeline.sh

ENTRYPOINT ["/bin/bash"]
