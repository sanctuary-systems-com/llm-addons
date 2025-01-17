ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add --no-cache mesa-vulkan-ati vulkan-loader-dev vulkan-tools cmake ninja build-base curl-dev shaderc musl-dev linux-headers
#ADD https://github.com/ochafik/llama.cpp.git#tool-call /llama.cpp
#ADD https://github.com/ggerganov/llama.cpp/archive/refs/heads/master.tar.gz /llama.tgz
ADD https://github.com/ochafik/llama.cpp/archive/refs/heads/tool-call.tar.gz /llama.tgz
RUN tar xzf /llama.tgz

WORKDIR /llama.cpp-tool-call
#export DESTDIR=/tmp/llama
RUN cmake -G Ninja -B build -DGGML_NATIVE=OFF -DLLAMA_CURL=ON -DGGML_VULKAN=1
RUN cmake --build build --config Release
RUN cmake --install build

#FROM $BUILD_FROM
#RUN apk add --no-cache mesa-vulkan-ati vulkan-loader libcurl libgomp

#COPY --from=0 /tmp/llama /

COPY run.sh /
RUN chmod a+x /run.sh

CMD ["/run.sh"]