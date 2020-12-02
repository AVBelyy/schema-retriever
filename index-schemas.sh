#!/bin/bash

# Treat unset variables as error
set -u

# Exit on error (propagating error code)
set -e

JSON_PATH="$1"
CONCRETE_PATH="$2"
LUCENE_INDEX_PATH="$3"

python concretize-schemas.py "$JSON_PATH" "$CONCRETE_PATH"

JAR_PATH=$(ls concrete-java/lucene/target/concrete-lucene-*.jar | head -n 1)
java -cp "$JAR_PATH" edu.jhu.hlt.concrete.lucene.TarGzCommunicationIndexer  --input-path "$CONCRETE_PATH" --output-folder "$LUCENE_INDEX_PATH" 2>/dev/null
