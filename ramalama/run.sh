#!/usr/bin/env bash

REPO=$(jq --raw-output '.repository // empty' $CONFIG_PATH)
FILE=$(jq --raw-output '.file // empty' $CONFIG_PATH)

llama-server --jinja -hfr "$REPO" -hff "$FILE" -ngl 999 --host 0.0.0.0 --port 10202