#!/usr/bin/env bash

REPO=$(jq --raw-output '.repository // empty' $CONFIG_PATH)
FILE=$(jq --raw-output '.file // empty' $CONFIG_PATH)
TEMPLATE=$(jq --raw-output '.chat_template // empty' $CONFIG_PATH)

if [ ! -z "$TEMPLATE" ]; then
  python /get_hf_chat_template.py $TEMPLATE > template.json
  cat template.json
  llama-server --jinja -hfr "$REPO" -hff "$FILE" -ngl 999 \
               --chat-template-file template.json \
               --host 0.0.0.0 --port 10202
else
  llama-server --jinja -hfr "$REPO" -hff "$FILE" -ngl 999 \
               --host 0.0.0.0 --port 10202
fi