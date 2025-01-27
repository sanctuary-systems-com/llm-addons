ARG BUILD_FROM
FROM $BUILD_FROM AS build

RUN apk add --no-cache vulkan-loader-dev cmake ninja build-base curl-dev shaderc musl-dev linux-headers git
#ADD https://github.com/ochafik/llama.cpp.git#tool-call /llama.cpp
ADD https://github.com/ggerganov/llama.cpp/archive/refs/heads/master.tar.gz /llama.tgz
#ADD https://github.com/ochafik/llama.cpp/archive/refs/heads/tool-call.tar.gz /llama.tgz
RUN tar xzf /llama.tgz

WORKDIR /llama.cpp-master
ENV DESTDIR=/tmp/llama
RUN cmake -G Ninja -B build -DGGML_NATIVE=OFF -DLLAMA_CURL=ON -DGGML_VULKAN=1
RUN cmake --build build --config Release
RUN cmake --install build

FROM $BUILD_FROM
RUN apk add --no-cache mesa-vulkan-ati vulkan-loader libcurl libgomp python3

COPY --from=build /tmp/llama /

COPY run.sh /
RUN chmod a+x /run.sh

ADD https://raw.githubusercontent.com/ochafik/llama.cpp/refs/heads/tool-call/scripts/get_hf_chat_template.py /get_hf_chat_template.py

CMD ["/run.sh"]