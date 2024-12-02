FROM ubuntu:24.04

ARG CUDA_URL=https://developer.download.nvidia.com/compute/cuda/12.4.1/local_installers/cuda_12.4.1_550.54.15_linux.run
ARG CUDA_MD5=afc99bab1d8c6579395d851d948ca3c1

ARG MINICONDA_URL=https://repo.anaconda.com/miniconda/Miniconda3-py311_24.9.2-0-Linux-x86_64.sh
ARG MINICONDA_SHA256=62ef806265659c47e37e22e8f9adce29e75c4ea0497e619c280f54c823887c4f
ARG MINICONDA_DIR=/opt/miniconda

# Install necessary packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Download and install CUDA
RUN wget -q --show-progress --progress=bar:force:noscroll -O cuda_installer.run $CUDA_URL \
    && echo "$CUDA_MD5 cuda_installer.run" | md5sum -c - \
    && sh cuda_installer.run --silent --toolkit --override \
    && rm cuda_installer.run

# Download and install Miniconda
RUN wget -q --show-progress --progress=bar:force:noscroll -O miniconda.sh $MINICONDA_URL \
    && echo "$MINICONDA_SHA256 miniconda.sh" | sha256sum -c - \
    && sh miniconda.sh -b -p $MINICONDA_DIR \
    && rm miniconda.sh

# Create a Miniconda environment and install packages
RUN $MINICONDA_DIR/bin/conda create -y -n torch python=3.11 \
    && echo "source $MINICONDA_DIR/bin/activate torch" >> ~/.bashrc

# Activate the environment
SHELL ["$MINICONDA_DIR/bin/conda", "run", "-n", "torch", "/bin/bash", "-c"]

# Install PyTorch, torchvision, and torchaudio
RUN pip install torch torchvision torchaudio packaging ninja

# Add and install other required packages from a requirements.txt file
COPY requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt \
    && rm /tmp/requirements.txt

# Set the default command to bash
ENTRYPOINT [ "/bin/bash" ]
