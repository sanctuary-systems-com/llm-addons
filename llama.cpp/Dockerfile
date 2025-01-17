ARG BUILD_FROM
FROM $BUILD_FROM
#FROM quay.io/ramalama/vulkan:latest
#FROM pepijndevos/llama-cpp-vulkan:latest

RUN apk add --no-cache mesa-vulkan-ati vulkan-loader-dev vulkan-tools cmake ninja build-base curl-dev shaderc musl-dev linux-headers
ADD https://github.com/ochafik/llama.cpp.git#tool-call /llama.cpp

WORKDIR /llama.cpp
#export DESTDIR=/tmp/llama
RUN cmake -G Ninja -B build -DGGML_NATIVE=OFF -DLLAMA_CURL=ON #-DGGML_VULKAN=1
RUN cmake --build build --config Release
RUN cmake --install build

#FROM $BUILD_FROM

#RUN apk add --no-cache mesa-vulkan-ati vulkan-loader libcurl libgomp

#COPY --from=0 /tmp/llama /
# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "llama-cli", "-hfr", "bartowski/Qwen2.5-0.5B-Instruct-GGUF", "-hff", "Qwen2.5-0.5B-Instruct-Q4_K_M.gguf", "-ngl", "999", "-p", "I believe the meaning of life is", "-n", "128", "-no-cnv"]
#CMD ["vulkaninfo", "--summary"]
#CMD ["/run.sh"]