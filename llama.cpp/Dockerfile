ARG BUILD_FROM
FROM $BUILD_FROM AS build

RUN apk add --no-cache vulkan-loader-dev cmake ninja build-base curl-dev shaderc musl-dev linux-headers git clang
#ADD https://github.com/ggerganov/llama.cpp.git /llama.cpp
RUN git clone --recursive https://github.com/ggerganov/llama.cpp.git /llama.cpp
#ADD https://github.com/ggerganov/llama.cpp/archive/refs/heads/master.tar.gz /llama.tgz
#RUN tar xzf /llama.tgz

WORKDIR /llama.cpp
ENV DESTDIR=/tmp/llama
ENV CC=clang CXX=clang++
RUN cmake -G Ninja -B build -DGGML_NATIVE=OFF -DLLAMA_CURL=ON -DGGML_VULKAN=1
RUN cmake --build build --config Release
RUN cmake --install build

FROM $BUILD_FROM
RUN apk add --no-cache mesa-vulkan-ati vulkan-loader libcurl libgomp python3 py3-aiohttp py3-psutil

COPY --from=build /tmp/llama /
COPY --from=build /llama.cpp/models/templates /templates

ADD https://github.com/pepijndevos/llama_multiserver.git /llama_multiserver

COPY run.sh /
RUN chmod a+x /run.sh

CMD ["/run.sh"]