ARG BUILD_FROM
FROM $BUILD_FROM AS build

RUN apk add --no-cache vulkan-loader-dev cmake ninja build-base shaderc musl-dev linux-headers git
ADD https://github.com/ggerganov/whisper.cpp.git /whisper.cpp
#ADD https://github.com/ggerganov/whipser.cpp/archive/refs/heads/master.tar.gz /whisper.tgz
#RUN tar xzf /whisper.tgz

WORKDIR /whisper.cpp
ENV DESTDIR=/tmp/whisper
RUN cmake -G Ninja -B build -DGGML_NATIVE=OFF -DGGML_VULKAN=1
RUN cmake --build build --config Release
RUN cmake --install build

FROM $BUILD_FROM
RUN apk add --no-cache mesa-vulkan-ati vulkan-loader wget2 libgomp python3

COPY rootfs /

ADD https://raw.githubusercontent.com/ggerganov/whisper.cpp/refs/heads/master/models/download-ggml-model.sh /download-ggml-model.sh
RUN chmod a+x /download-ggml-model.sh

ADD https://github.com/ser/wyoming-whisper-api-client.git /api
WORKDIR /api
RUN ./script/setup

COPY --from=build /tmp/whisper /
