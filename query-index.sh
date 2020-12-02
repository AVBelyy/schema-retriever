#!/bin/bash

# Treat unset variables as error
set -u

# Exit on error (propagating error code)
set -e

LUCENE_INDEX_PATH="$1"
QUERY_STR="$2"

if [ $# -gt 2 ]
then
    MAX_RESULTS_STR="--max-results $3"
else
    MAX_RESULTS_STR=
fi

JAR_PATH=$(ls concrete-java/lucene/target/concrete-lucene-*.jar | head -n 1)
java -cp "$JAR_PATH" edu.jhu.hlt.concrete.lucene.ConcreteLuceneSearcher --index-path "$LUCENE_INDEX_PATH" "$QUERY_STR" $MAX_RESULTS_STR 2>/dev/null
