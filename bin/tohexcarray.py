#!/usr/bin/env python

import sys

def main():
    while True:
        for line in sys.stdin.readlines():
            word_count = 0
            for word in line.split():
                word_count += 1
                print "0x%s," % word,
                if word_count % 8 == 0:
                    print

if __name__ == '__main__':
    main()
