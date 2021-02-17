FROM ubuntu:latest as builder
RUN apt-get update -y && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        git \
        libssl-dev \
        pkg-config \
        ssh && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*
WORKDIR /opt/rust
RUN curl -L https://static.rust-lang.org/dist/rust-1.50.0-x86_64-unknown-linux-gnu.tar.gz | tar -xvz \ 
    && cd rust-1.50.0-x86_64-unknown-linux-gnu \
    && ./install.sh --without=rls-preview,rust-analyzer-preview,clippy-preview,miri-preview,rustfmt-preview,llvm-tools-preview,rust-analysis-x86_64-unknown-linux-gnu,rust-docs \
    && cd .. \
    && rm -rf rust-1.50.0-x86_64-unknown-linux-gnu
RUN cargo install xsv

FROM ubuntu:latest
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    ca-certificates \
    locales \
    sqlite3 \
    wget \
    unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /opt/ftds
COPY --from=builder /root/.cargo/bin/xsv /bin/
COPY README.md ftds.sql main.bash .
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
CMD ./main.bash
