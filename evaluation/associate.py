#!/usr/bin/python
# Software License Agreement (BSD License)
# Copyright (c) 2013, Juergen Sturm, TUM
# All rights reserved.
# ... [License truncated for brevity] ...

import argparse
import sys
import os
import numpy


def read_file_list(filename, remove_bounds):
    """
    Reads a trajectory from a text file. 
    """
    file = open(filename)
    data = file.read()
    lines = data.replace(",", " ").replace("\t", " ").split("\n")
    if remove_bounds:
        lines = lines[100:-100]
    list = [[v.strip() for v in line.split(" ") if v.strip() != ""] for line in lines if len(line) > 0 and line[0] != "#"]
    list = [(float(l[0]), l[1:]) for l in list if len(l) > 1]
    return dict(list)


def associate(first_list, second_list, offset, max_difference):
    """
    Associate two dictionaries of (stamp,data).
    """
    first_keys = list(first_list.keys())   # FIXED
    second_keys = list(second_list.keys()) # FIXED

    potential_matches = [
        (abs(a - (b + offset)), a, b)
        for a in first_keys
        for b in second_keys
        if abs(a - (b + offset)) < max_difference
    ]
    potential_matches.sort()
    matches = []
    for diff, a, b in potential_matches:
        if a in first_keys and b in second_keys:
            first_keys.remove(a)  # FIXED: no longer fails
            second_keys.remove(b)
            matches.append((a, b))

    matches.sort()
    return matches


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='''
    This script takes two data files with timestamps and associates them   
    ''')
    parser.add_argument('first_file', help='first text file (format: timestamp data)')
    parser.add_argument('second_file', help='second text file (format: timestamp data)')
    parser.add_argument('--first_only', help='only output associated lines from first file', action='store_true')
    parser.add_argument('--offset', help='time offset added to the timestamps of the second file (default: 0.0)', default=0.0)
    parser.add_argument('--max_difference', help='maximally allowed time difference for matching entries (default: 0.02)', default=0.02)
    args = parser.parse_args()

    first_list = read_file_list(args.first_file, remove_bounds=False)
    second_list = read_file_list(args.second_file, remove_bounds=False)

    matches = associate(first_list, second_list, float(args.offset), float(args.max_difference))

    if args.first_only:
        for a, b in matches:
            print("%f %s" % (a, " ".join(first_list[a])))
    else:
        for a, b in matches:
            print("%f %s %f %s" % (a, " ".join(first_list[a]), b - float(args.offset), " ".join(second_list[b])))
