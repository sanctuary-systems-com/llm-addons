#!/usr/bin/with-contenv bashio

export LLAMA_CACHE="/data/models"
export CONFIG_PATH=/data/options.json
export GGML_VK_FORCE_MAX_ALLOCATION_SIZE=1073741824

REPO="$(bashio::config 'repository')"
FILE="$(bashio::config 'file')"
TEMPLATE="$(bashio::config 'chat_template')"

if [ ! -z "$TEMPLATE" ]; then
  python /get_hf_chat_template.py $TEMPLATE > template.json
  llama-server --jinja -hfr "$REPO" -hff "$FILE" -ngl 999 \
               --chat-template-file template.json \
               --host 0.0.0.0 --port 10202
else
  llama-server --jinja -hfr "$REPO" -hff "$FILE" -ngl 999 \
               --host 0.0.0.0 --port 10202
fi