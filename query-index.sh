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

mvn --batch-mode --errors -f concrete-java/lucene exec:java -Dexec.mainClass="edu.jhu.hlt.concrete.lucene.ConcreteLuceneSearcher" -Dlog4j.threshold=FATAL -Dexec.args="--index-path \"$LUCENE_INDEX_PATH\" \"$QUERY_STR\" $MAX_RESULTS_STR" -q 2>/dev/null
