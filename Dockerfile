FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y musl musl-tools && \
    apt install -y curl clang libffi-dev make && \
    curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    apt install -y libopenmpi-dev wget && \
    rm -rf /var/lib/apt/lists/* && \
    apt install libc6-dev

WORKDIR /usr/src/mpi_app

# Download and build OpenMPI 4.1.5
RUN mkdir /usr/src/openmpi
WORKDIR /usr/src/openmpi
RUN wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.5.tar.gz
RUN tar -xvf openmpi-4.1.5.tar.gz
WORKDIR /usr/src/openmpi/openmpi-4.1.5
RUN ./configure --prefix=/usr/local
RUN make -j $(nproc)
RUN make install

# Add OpenMPI to the system library paths
RUN echo '/usr/local/lib' >> /etc/ld.so.conf.d/openmpi.conf
RUN ldconfig

# Cleanup
RUN rm -rf /usr/src/openmpi

# Verify OpenMPI installation
RUN mpirun --version

WORKDIR /usr/src/mpi_app

RUN useradd no_root

CMD ["sh"]
