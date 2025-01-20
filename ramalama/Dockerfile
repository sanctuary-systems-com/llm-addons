#FROM quay.io/ramalama/vulkan:latest
FROM pepijndevos/llama-cpp-vulkan:latest

RUN dnf install -y jq

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

ADD https://raw.githubusercontent.com/ochafik/llama.cpp/refs/heads/tool-call/scripts/get_hf_chat_template.py /get_hf_chat_template.py

ENV LLAMA_CACHE="/data/models"
ENV CONFIG_PATH=/data/options.json
ENV GGML_VK_FORCE_MAX_ALLOCATION_SIZE=1073741824

CMD ["/run.sh"]