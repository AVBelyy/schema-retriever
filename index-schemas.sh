#!/bin/bash

# Treat unset variables as error
set -u

# Exit on error (propagating error code)
set -e

JSON_PATH="$1"
CONCRETE_PATH="$2"
LUCENE_INDEX_PATH="$3"

python concretize-schemas.py "$JSON_PATH" "$CONCRETE_PATH"

mvn --batch-mode --errors --show-version -f concrete-java/lucene exec:java -Dexec.mainClass="edu.jhu.hlt.concrete.lucene.TarGzCommunicationIndexer" -Dexec.args="--input-path \"$CONCRETE_PATH\" --output-folder \"$LUCENE_INDEX_PATH\""
