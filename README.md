# schema-retriever
<img src="golden-retriever.jpg" alt="golden retriever with a newspaper" width="500"/>

This repository hosts scripts to index KAIROS TA1 schemas and retrieve top-K most relevant schemas using [Lucene](https://lucene.apache.org/) search index.

# Installation

```
cd /path/to/schema-retriever

# Initialize submodules
git submodule init
git submodule update

# Build concrete-java
cd concrete-java
mvn clean compile assembly:single
cd ..

# Install Python dependencies
pip install -r requirements.txt
```

# Usage

To index the TA1 schema library, located at `JSON_PATH`, please use the `index-schemas.sh` script. It will produce the Lucene index (at `LUCENE_INDEX_PATH`) and the intermediary Concrete file (at `CONCRETE_PATH`).

To query the Lucene index, use the `query-index.sh` script.

Example usages (note that A_B_C syntax is used instead of A.B.C for event and relation types, to avoid undesired tokenization issues):

```
# Count how many schemas mention 'Conflict.Attack.*' events
$ ./query-index.sh "$LUCENE_INDEX_PATH" 'Conflict_Attack_*' | wc -l
```

```
# Output top-3 schemas that use 'Medical.Intervention.Unspecified' event
$ ./query-index.sh "$LUCENE_INDEX_PATH" 'Medical_Intervention_Unspecified' 3
```

```
# Simple example involving weighted OR clauses and prefixes of an event type
$ ./query-index.sh "$LUCENE_INDEX_PATH" '(ArtifactExistence_*)^0.5 OR (ArtifactExistence_Manufacture_*)^0.75 OR (ArtifactExistence_Manufacture_Unspecified)^1.0' 3
```

For more examples on how to query Lucene index (programmatically or using our script), please refer to [this guide](http://www.lucenetutorial.com/lucene-query-syntax.html).
