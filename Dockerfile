FROM kitware/cmake:ci-debian12-aarch64-2025-03-31

USER root

WORKDIR /app

# Copy your project files and proceed with your build setup
COPY . .

# Ensure all dependencies are updated
RUN apt-get update && apt-get install -y \
    cmake \
    python3 \
    python3-pip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Verify the updated CMake version
RUN cmake --version

# Install Conan, allowing system-wide installation
RUN pip install --upgrade pip --break-system-packages \
    && pip install --upgrade conan --break-system-packages

# Verify conan version
RUN conan --version

# Ensure the scripts are executable
RUN chmod +x build.sh clean_up.sh run.sh

# Run the build process
RUN sh build.sh

ENTRYPOINT ["sh", "run.sh"]
