FROM nvidia/cuda:9.0-cudnn7-devel

# Install face recognition dependencies

RUN apt update -y; apt install -y \
git \
cmake \
libsm6 \
libxext6 \
libxrender-dev \
python3 \
python3-pip

RUN pip3 install scikit-build

# Install compilers

RUN apt install -y software-properties-common
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt update -y; apt install -y gcc-6 g++-6

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 50
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-6 50

#Install dlib 

RUN pip3 install -Iv setuptools==50.3.0
RUN git clone -b 'v19.17' --single-branch https://github.com/davisking/dlib.git
RUN mkdir -p /dlib/build

RUN cmake -H/dlib -B/dlib/build -DDLIB_USE_CUDA=1 -DUSE_AVX_INSTRUCTIONS=1
RUN cmake --build /dlib/build

RUN cd /dlib; python3 /dlib/setup.py install

# Install the face recognition package

RUN pip3 install face_recognition
RUN python3 -m pip install grpcio
RUN python3 -m pip install grpcio-tools

COPY face_pb2_grpc.py /root
COPY face_pb2.py /root
COPY identifier.py /root

VOLUME [ "/unknown_people", "/known_people" ]

EXPOSE 50051

CMD [ "python3", "/root/identifier.py" ]
