FROM quay.io/ramalama/vulkan:latest

RUN dnf install -y jq

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

ADD https://raw.githubusercontent.com/ggerganov/whisper.cpp/refs/heads/master/models/download-ggml-model.sh /download-ggml-model.sh
RUN chmod a+x /download-ggml-model.sh

RUN git clone https://github.com/ser/wyoming-whisper-api-client /api
WORKDIR /api
RUN ./script/setup

ENV LLAMA_CACHE="/data/models"
ENV CONFIG_PATH=/data/options.json

CMD ["/run.sh"]