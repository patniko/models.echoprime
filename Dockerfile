# Using NVIDIA PyTorch base image which should provide a compatible Python version
FROM nvcr.io/nvidia/pytorch:24.01-py3
WORKDIR /workspace/EchoPrime
ENV PIP_ROOT_USER_ACTION=ignore

# Install Poetry
RUN apt-get update && \
    apt-get install -y curl && \
    curl -sSL https://install.python-poetry.org | python3 - && \
    ln -s /root/.local/bin/poetry /usr/local/bin/

# Configure Poetry to not create a virtual environment
RUN poetry config virtualenvs.create false

# Copy poetry configuration
COPY pyproject.toml ./

# Install dependencies
# Using --no-root because we've set package-mode = false in pyproject.toml
RUN poetry install --no-interaction --no-ansi --no-dev --no-root

# Copy the rest of the application
COPY . .

# Uninstall opencv-python if it was installed as a dependency of another package
RUN python -m pip uninstall -y opencv-python || true
