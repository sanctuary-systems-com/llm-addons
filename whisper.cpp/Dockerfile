ARG BUILD_FROM
FROM $BUILD_FROM AS build

RUN apk add --no-cache vulkan-loader-dev cmake ninja build-base shaderc musl-dev linux-headers git py3-pip py3-scikit-build
# https://github.com/ggml-org/llama.cpp/issues/14542
RUN apk add --no-cache glslang-dev --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main/
ADD https://github.com/sanctuary-systems-com/wyoming-whisper-cpp.git /wyoming-whisper-cpp

WORKDIR /wyoming-whisper-cpp
RUN CMAKE_ARGS="-DGGML_VULKAN=1 -DGGML_NATIVE=0 -DCMAKE_POLICY_VERSION_MINIMUM=3.5" pip wheel . --verbose --no-deps --wheel-dir /tmp/whisper

FROM $BUILD_FROM
RUN apk add --no-cache mesa-vulkan-ati vulkan-loader wget libgomp py3-pip

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY --from=build /tmp/whisper /tmp/whisper
RUN pip install /tmp/whisper/wyoming_whisper_cpp*.whl

COPY run.sh /
RUN chmod a+x /run.sh

CMD ["/run.sh"]