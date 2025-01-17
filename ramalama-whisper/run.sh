#!/usr/bin/env bash

VOICE=$(jq --raw-output '.voice // empty' $CONFIG_PATH)

mkdir -p $LLAMA_CACHE
/download-ggml-model.sh $VOICE $LLAMA_CACHE

# start whisper
whisper-server -m "$LLAMA_CACHE/ggml-$VOICE.bin" --host 0.0.0.0 --port 8080 &

# start Wyoming proxy
./script/run --uri tcp://0.0.0.0:10303 --debug --api http://localhost:8080/inference &

# Wait for any process to exit
wait -n

# Exit with status of process that exited first
exit $?