#!/bin/bash

set -eux

INPUT="$1"

JSON_OUTPUT="$(echo "$INPUT" | yaml2json)"

jq -n --arg json_output "$JSON_OUTPUT" '{"json":$json_output}'
