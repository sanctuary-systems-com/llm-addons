#!/usr/bin/with-contenv bashio

export LLAMA_CACHE="/data/models"
export GGML_VK_FORCE_MAX_ALLOCATION_SIZE=1073741824

python llama_multiserver/server.py