FROM python:3.12-slim-bookworm

ARG PYTORCH_INDEX_URL=https://download.pytorch.org/whl/cu124
# Choose NVCC versions same as torch CUDA here https://pypi.org/project/nvidia-cuda-nvcc-cu12/#history
ARG CUDA_NVCC_VERSION=12.4.131

# Install necessary packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    wget \
    git \
    libxml2 \
    build-essential \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install PyTorch, torchvision, torchaudio, and other requirements
COPY requirements /tmp/requirements/
RUN pip3 install --no-cache-dir torch torchvision torchaudio --index-url $PYTORCH_INDEX_URL \
    && pip3 install --no-cache-dir nvidia-cuda-nvcc-cu12==$CUDA_NVCC_VERSION \
    && pip3 install --no-cache-dir packaging ninja wheel setuptools setuptools-scm \
    && pip3 install --no-cache-dir --no-build-isolation -r /tmp/requirements/torch_extensions.txt \
    && pip3 install --no-cache-dir -r /tmp/requirements/packages.txt \
    && rm -rf /tmp/requirements

# Set the default command to bash
ENTRYPOINT [ "/bin/bash" ]
