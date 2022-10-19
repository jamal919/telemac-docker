# Build platform selection
# $TARGETARCH, $TARGETOS, ${TARGETPLATFORM}
FROM ubuntu:20.04 as ubuntu_amd64
ENV HDF5HOME=/usr/lib/x86_64-linux-gnu/hdf5/serial

FROM ubuntu:20.04 as ubuntu_arm64
ENV HDF5HOME=/usr/lib/aarch64-linux-gnu/hdf5/serial

FROM ubuntu_${TARGETARCH}

# Main
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

RUN apt-get update \
    && apt-get install -y git wget \
    && apt-get install -y python-is-python3 python3-numpy python3-distutils libpython3-dev gfortran make \
    && apt-get install -y python3-scipy python3-matplotlib \
    && apt-get install -y openmpi-bin libopenmpi-dev metis libmetis-dev \
    && apt-get install -y hdf5-tools libhdf5-dev

RUN cd /tmp \
    && wget -c http://files.salome-platform.org/Salome/other/med-4.1.0.tar.gz \
    && tar -xvzf med-4.1.0.tar.gz \
    && cd med-4.1.0 \
    && ./configure --with-hdf5-bin=/usr/bin \
    && make \
    && make install \
    && rm -rf /tmp/med-4.1.0.tar.gz /tmp/med-4.1.0

RUN cd /tmp \
    && wget -c https://gitlab.pam-retd.fr/otm/telemac-mascaret/-/archive/v8p2r1/telemac-mascaret-v8p2r1.tar.gz \
    && tar -xvzf telemac-mascaret-v8p2r1.tar.gz -C /opt \
    && rm -rf telemac-mascaret-v8p2r1.tar.gz /opt/telemac-mascaret-v8p2r1/examples

ENV HOMETEL=/opt/telemac-mascaret-v8p2r1
ENV PATH=$HOMETEL/scripts/python3:.:$PATH
ENV SYSTELCFG=$HOMETEL/configs/systel.cfg
ENV USETELCFG=gfortranMPI
ENV SOURCEFILE=$HOMETEL/configs/pysource.sh
ENV PYTHONUNBUFFERED='true'
ENV PYTHONPATH=$HOMETEL/scripts/python3:$PYTHONPATH
ENV LD_LIBRARY_PATH=$HOMETEL/builds/$USETELCFG/wrap_api/lib:$LD_LIBRARY_PATH
ENV PYTHONPATH=$HOMETEL/builds/$USETELCFG/wrap_api/lib:$PYTHONPATH

COPY pysource.sh /opt/telemac-mascaret-v8p2r1/configs/
COPY systel.cfg /opt/telemac-mascaret-v8p2r1/configs/

RUN config.py && compile_telemac.py

RUN useradd -ms /bin/bash mascaret
USER mascaret
WORKDIR /mnt

CMD ["/bin/bash"]