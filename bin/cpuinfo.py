#!/usr/bin/env python

import sys

class VCPU(object):
    """Attributes of a Logical CPU
    """
    def __init__(self, vcpu_id):
        self.vcpu = vcpu_id
        self.phys = None
        self.core = None
        self.hwth = None

def load_map(file_name, phys_means_chip=True):
    """Load a cpuinfo file
    """
    print "Reading from %s" % file_name
    vcpu_map = {}

    with open(file_name) as in_file:
        for line in in_file:
            try:
                (attr, val) = line.split(':')
            except ValueError:
                # Only look at lines with <attribute> : <number>
                continue

            # Strip ' id' from the end of attributes -- these exist in some
            # kernels but not others
            attr = attr.strip()
            if attr.endswith(' id'):
                attr = attr[:len(attr) - 3]

            if attr not in ('processor', 'physical', 'core'):
                continue

            val = int(val.strip())

            if attr == 'processor':
                print "found %s:%d" % (attr, val)
                vcpu_id = val
                vcpu_map[vcpu_id] = VCPU(vcpu_id)
            elif attr == 'physical':
                print "found %s:%d" % (attr, val)
                if phys_means_chip:
                    vcpu_map[vcpu_id].phys = val
                else:
                    vcpu_map[vcpu_id].phys = 0
            elif attr == 'core':
                print "found %s:%d" % (attr, val)
                vcpu_map[vcpu_id].core = val

    return vcpu_map

def build_tree(vcpu_map):
    """Build a tree phys->cores->threads->logical id->vcpu obj
    """
    tree = {}
    for vcpu in vcpu_map.values():
        if vcpu.phys not in tree:
            tree[vcpu.phys] = {}

        if vcpu.core not in tree[vcpu.phys]:
            tree[vcpu.phys][vcpu.core] = {}

        # Assign a thread ID. Assume lower numbered VCPUs have a lower
        # thread ID
        vcpu.hwth = len(tree[vcpu.phys][vcpu.core])
        tree[vcpu.phys][vcpu.core][vcpu.hwth] = vcpu

    return tree


def main():
    """Entry
    """
    if len(sys.argv) > 1:
        file_name = sys.argv[1]
    else:
        file_name = '/proc/cpuinfo'

    vcpu_map = load_map(file_name)
    tree = build_tree(vcpu_map)

    for phys in sorted(tree):
        print "Physical %d" % (phys, )
        for core in sorted(tree[phys]):
            print "    Core %d" % (core, )
            for hwth in sorted(tree[phys][core]):
                vcpu = tree[phys][core][hwth]
                print "        HW Thread %d ---> %d" % (hwth, vcpu.vcpu)
                assert(phys == vcpu.phys)
                assert(core == vcpu.core)
                assert(hwth == vcpu.hwth)

    return 0

if __name__ == "__main__":
    sys.exit(main())
