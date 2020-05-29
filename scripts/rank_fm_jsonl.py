import os
import csv
import json
import argparse

def create_arg_parser():
    parser = argparse.ArgumentParser(description='READ scored_candidates.jsonl & RANK based on scores')
    parser.add_argument('-fi', '--jsonl', type=str, help='jsonl consisted of Dict[candidate, score]')
    parser.add_argument('-s', '--dest', type=str, default='/tmp/', help='dest of csv')
    parser.set_defaults(no_thres=False)
    return parser


def write_csv_fm_jsonl(args):
    """
    args.dest/ ディレクトリに [fname of jsonl].csv を作成
    """

    os.makedirs(args.dest, exist_ok=True)
    suffix = '.' + args.jsonl.split('.')[-1]
    fname = args.jsonl.split()[-1][:-len(suffix)]
    fo = open(os.path.join(args.dest, f'{fname}.csv'), 'w')
    writer = csv.writer(fo, delimiter='\t')

    for line in open(args.jsonl):
        dictl = json.loads(line.rstrip())
        listl = [[k, v] for k,v in dictl.items()]
        writer.writerows(listl)
    
    fo.close()


def run():
    parser = create_arg_parser()
    args = parser.parse_args()

    write_csv_fm_jsonl(args)


if __name__ == '__main__':
    """ running example
    $ python write_scores.py -fi cand.jsonl -s work/
    """
    run()
