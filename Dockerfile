FROM python:3.12-slim-bookworm

ARG CUDA_URL=https://developer.download.nvidia.com/compute/cuda/12.4.1/local_installers/cuda_12.4.1_550.54.15_linux.run
ARG CUDA_MD5=afc99bab1d8c6579395d851d948ca3c1

ARG PYTORCH_INDEX_URL=https://download.pytorch.org/whl/nightly/cu124

# Install necessary packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    wget \
    git \
    openssh-client \
    tmux \
    libxml2 \
    build-essential \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Download and install CUDA
RUN wget -q --show-progress --progress=bar:force:noscroll -O cuda_installer.run $CUDA_URL \
    && echo "$CUDA_MD5 cuda_installer.run" | md5sum -c - \
    && sh cuda_installer.run --silent --toolkit --override \
    && rm cuda_installer.run

# Install PyTorch, torchvision, torchaudio, and other requirements
COPY requirements /tmp/requirements/
RUN pip3 install --no-cache-dir --pre torch torchvision torchaudio --index-url $PYTORCH_INDEX_URL \
    && pip3 install --no-cache-dir packaging ninja wheel setuptools setuptools-scm \
    && pip3 install --no-cache-dir --no-build-isolation -r /tmp/requirements/torch_extensions.txt \
    && pip3 install --no-cache-dir -r /tmp/requirements/packages.txt \
    && rm -rf /tmp/requirements

# Set the default command to bash
ENTRYPOINT [ "/bin/bash" ]
