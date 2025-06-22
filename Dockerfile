FROM ubuntu:20.04

# 設置環境變量
ENV DEBIAN_FRONTEND=noninteractive

# 更新系統並安裝必要的依賴
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    pkg-config \
    libboost-all-dev \
    libssl-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# 安裝 protobuf 3.12.4
WORKDIR /tmp
RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v3.12.4/protobuf-cpp-3.12.4.tar.gz \
    && tar -xzf protobuf-cpp-3.12.4.tar.gz \
    && cd protobuf-3.12.4 \
    && ./configure --prefix=/usr/local \
    && make -j$(nproc) \
    && make install \
    && ldconfig \
    && cd .. \
    && rm -rf protobuf-3.12.4*

# 安裝 muduo 網絡庫
RUN git clone https://github.com/chenshuo/muduo.git \
    && cd muduo \
    && ./build.sh -j$(nproc) \
    && cd .. \
    && rm -rf muduo

# 設置工作目錄
WORKDIR /workspace

# 複製項目文件
COPY . .

# 設置環境變量
ENV PATH=/usr/local/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH

# 編譯項目
RUN mkdir -p cmake-build-debug \
    && cd cmake-build-debug \
    && cmake .. \
    && make -j$(nproc)

# 設置默認命令
CMD ["/bin/bash"] 