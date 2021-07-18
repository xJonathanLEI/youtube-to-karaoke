FROM ubuntu:20.04 AS clone

RUN apt-get update && \
    apt-get install -y git curl zip && \
    rm -r /var/lib/apt/lists/* 

WORKDIR /src

RUN git clone --depth 1 -b 2021.06.06 \
    https://github.com/ytdl-org/youtube-dl && \
    rm -rf ./youtube-dl/.git

RUN curl -L https://github.com/tsurumeso/vocal-remover/releases/download/v4.0.0/vocal-remover-v4.0.0.zip \
    -o /tmp/vocal-remover.zip && \
    cd /src && \
    unzip /tmp/vocal-remover.zip

FROM ubuntu:20.04

LABEL org.opencontainers.image.source=https://github.com/xJonathanLEI/youtube-to-karaoke

ENV TZ=Etc/GMT
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt-get update && \
    apt-get install -y python3 python3-pip ffmpeg ca-certificates && \
    rm -r /var/lib/apt/lists/*

RUN pip3 install torch==1.9.0+cpu torchvision==0.10.0+cpu torchaudio==0.9.0 -f https://download.pytorch.org/whl/torch_stable.html

COPY --from=clone /src /src

RUN cd /src/vocal-remover && \
    pip3 install -r requirements.txt

COPY ./entry.sh /entry.sh

ENTRYPOINT ["/entry.sh"]
