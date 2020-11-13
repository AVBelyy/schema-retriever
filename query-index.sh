#!/bin/sh

LUCENE_INDEX_PATH=$1
QUERY_STR=$2
MAX_RESULTS_CNT=$3

[[ ! -z "$MAX_RESULTS_CNT" ]] && MAX_RESULTS_STR="--max-results $MAX_RESULTS_CNT"

mvn --batch-mode --errors -f concrete-java/lucene exec:java -Dexec.mainClass="edu.jhu.hlt.concrete.lucene.ConcreteLuceneSearcher" -Dexec.args="--index-path \"$LUCENE_INDEX_PATH\" \"$QUERY_STR\" $MAX_RESULTS_STR" -q 2>/dev/null
