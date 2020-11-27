import os
import json

from glob import glob
from argparse import ArgumentParser
from concrete.util import CommunicationWriterTGZ, create_comm, AnalyticUUIDGeneratorFactory


def main():
    parser = ArgumentParser(description='Convert a directory with KAIROS TA1 schemas into a single Concrete file')
    parser.add_argument('json_in_dir', type=str, help='Directory with JSON-LD files')
    parser.add_argument('concrete_out_path', type=str, help='Path to a Concrete file')
    parser.add_argument('--print-docs', default=False, action='store_true', help='Print Concrete documents to stdout')
    args = parser.parse_args()

    num_schemas = 0

    with CommunicationWriterTGZ(args.concrete_out_path) as concrete_out:
        for json_in_path in glob(f'{args.json_in_dir}/*.json'):
            json_in_filename = os.path.basename(json_in_path)
            with open(json_in_path) as json_in:
                schema_json = json.load(json_in)
                for schema in schema_json['schemas']:
                    # Step 1: read schema from JSON-LD
                    # Compose a paragraph with event types
                    event_types = []
                    for step in schema.get('steps', []):
                        # Hacky way to get a normalized event type, assuming they all come from KAIROS ontology
                        _, event_type = step['@type'].split('Primitives/Events/', 1)
                        event_type = event_type.replace('.', '_')
                        event_types.append(event_type)
                    # Compose a paragraph with entity relations
                    relation_types = []
                    for rels in schema.get('entityRelations', []):
                        for rel in rels['relations']:
                            # Hacky way to get a normalized relation type, assuming they all come from KAIROS ontology
                            _, relation_type = rel['relationPredicate'].split('Primitives/Relations/', 1)
                            relation_type = relation_type.replace('.', '_')
                            relation_types.append(relation_type)
                    schema_doc = {
                        'doc_id': f"{json_in_filename}::{schema['@id']}",
                        'event_types': ' '.join(event_types),
                        'relation_types': ' '.join(relation_types)
                    }
                    if args.print_docs:
                        print(schema_doc)

                    # Step 2: write schema to Concrete
                    comm = create_comm(
                        schema_doc['doc_id'],
                        schema_doc['event_types'] + '\n\n' + schema_doc['relation_types']
                    )
                    concrete_out.write(comm, comm.id)
                    num_schemas += 1

    print(f'Done writing {num_schemas} schemas to {args.concrete_out_path}')


if __name__ == '__main__':
    main()
