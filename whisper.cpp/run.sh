#!/usr/bin/env bash

LLAMA_CACHE="/data/models"
CONFIG_PATH=/data/options.json

VOICE=$(jq --raw-output '.voice // empty' "$CONFIG_PATH")
LANG=$(jq --raw-output '.lang // empty' "$CONFIG_PATH")

mkdir -p $LLAMA_CACHE

wyoming-whisper-cpp \
  --model $VOICE \
  --language $LANG \
  --uri 'tcp://0.0.0.0:10303' \
  --data-dir $LLAMA_CACHE \
  --download-dir $LLAMA_CACHE