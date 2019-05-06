#!/usr/bin/env python

# /* ((1000000000ns / (6000ints/s * 1024ns)) << 2 = 648 */
import sys

def show_itr(target_per_sec):
    ns_per_sec = (1000 * 1000 * 1000)
    itr_val = (ns_per_sec / (target_per_sec * 1024)) << 2
    print "%s interrupts per second uses itr: %d" % (target_per_sec, itr_val)


def main():
    for arg in sys.argv[1:]:
        show_itr(int(arg))

if __name__ == '__main__':
    main()
