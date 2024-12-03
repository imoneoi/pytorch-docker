# PyTorch Docker Image

This repository provides a minimal, customizable Docker image for PyTorch, suitable for various Python, CUDA, and PyTorch versions. The image is built and pushed to Docker Hub automatically using GitHub Actions.

## Current Versions
- **Python**: 3.12
- **CUDA**: 12.4
- PyTorch: Latest compatible version with the above CUDA version

## Customization

### Packages
Modify package lists in the `requirements` folder:
- `packages.txt`: Standard pip packages installed via `pip install -r`.
- `torch_extensions.txt`: PyTorch extensions installed with `--no-build-isolation`.

### Base Image and Versions
Adjust the `FROM` directive and `ARGS` in the Dockerfile to change the base OS, CUDA, and PyTorch versions.

## Setting Up the Workflow
1. **Set GitHub Secrets**:
- Navigate to your repository's Settings.
- Go to Secrets and add the following:
    - `DOCKERHUB_USERNAME`: Your Docker Hub username.
    - `DOCKERHUB_TOKEN`: Your Docker Hub access token.

2. **Create a Release**:
- Push your changes to the main branch.
- Go to the "Releases" section in your GitHub repository.
    - Click "Create a new release".
    - Tag your release and publish it.

Upon publishing a release, the workflow is triggered, building and pushing the image to Docker Hub  with `latest` and the release tag.
