FROM conanio/clang70

USER root

WORKDIR /app

# Copy your project files and proceed with your build setup
COPY . .

# Install dependencies for building CMake
RUN apt-get update && \
    apt-get install -y wget build-essential libssl-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download and build CMake from source
RUN wget https://github.com/Kitware/CMake/releases/latest/download/cmake-4.0.1.tar.gz && \
    tar -xzf cmake-4.0.1.tar.gz && \
    cd cmake-4.0.1 && \
    ./bootstrap && \
    make -j$(nproc) && \
    make install && \
    cd .. && \
    rm -rf cmake-4.0.1 cmake-4.0.1.tar.gz

# Verify the updated CMake version
RUN cmake --version

# Update conan
RUN pip install --upgrade conan

# Verify conan version
RUN conan --version

# Ensure the scripts are executable
RUN chmod +x build.sh clean_up.sh run.sh

# Run the build process
RUN sh build.sh

ENTRYPOINT ["sh", "run.sh"]
