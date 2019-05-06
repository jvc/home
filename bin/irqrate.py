#!/usr/bin/env python
"""Print the rate of IRQs as reported in /proc/interrupts.
"""

import sys
import time

INTERVAL = 2

def get_cpu_names():
    """Return CPU names
    """
    with open('/proc/interrupts') as in_file:
        # Example, irq 16 with two CPUs, description and module info follows
        #  16:        339         80   IO-APIC-fasteoi  ehci_hcd:usb1
        return in_file.readline().strip().split()


def get_irq_map(irqs):
    """Return a new map
    """
    irq_map = {}
    irq_desc = {}

    with open('/proc/interrupts') as in_file:
        # Skip header
        in_file.readline()
        # Example, irq 16 with two CPUs, description and module info follows
        #  16:        339         80   IO-APIC-fasteoi  ehci_hcd:usb1
        for line in in_file:
            (irq, line) = line.split(':', 1)
            if irqs and irq not in irqs:
                continue

            irq_map[irq] = []
            irq_desc[irq] = None
            for field in line.split():
                if irq_desc[irq]:
                    irq_desc[irq] += (' %s' % field)
                try:
                    val = int(field)
                except ValueError:
                    # Assume we're at the description
                    irq_desc[irq] = field
                else:
                    irq_map[irq].append(val)

    return (irq_map, irq_desc)

def show_update(cpus, prev_map, cur_map, desc, interval):
    """Print the per-second count for each irq on each cpu and totals
    """
    for (irq, cur_values) in cur_map.iteritems():
        line = ["%3s " % irq,]
        prev_values = prev_map[irq]
        irq_total = 0
        for (cpu, cur_value) in enumerate(cur_values):
            if len(cpus) == 0 or cpu in cpus:
                prev_value = prev_values[cpu]
                diff = cur_value - prev_value
                irq_total += diff
                line.append("%10d/s" % (diff / interval))
        if irq_total > 0 and (irq_total / interval) > 0:
            line.append("%10d/s (%s)" % (irq_total / interval, desc[irq]))
            print ' '.join(line)

def poll(irqs, cpus, interval):
    """Update the map compare against the previous
    """
    (prev_map, desc) = get_irq_map(irqs)
    names = []
    for (cpu_id, cpu) in enumerate(get_cpu_names()):
        if len(cpus) == 0 or cpu_id in cpus:
            names.append('%10s' % cpu)

    print "IRQ %s      Total" % ' '.join(names)
    while True:
        time.sleep(interval)
        (irq_map, desc) = get_irq_map(irqs)
        show_update(cpus, prev_map, irq_map, desc, interval)
        prev_map = irq_map

def jot(descr):
    """
    srange('0-5,7,20-', 32) []
    """
    final = []
    for given in descr.split(','):
        if '-' in given:
            (vmin, vmax) = given.split('-')
            final.extend(range(int(vmin), int(vmax) + 1))
        else:
            final.append(int(given))

    return final

def main():
    """Entry
    """
    if '-h' in sys.argv:
        print >> sys.stdout, "Usage: %s [cpu_range]" % (sys.argv[0],)
        sys.exit(2)

    irqs = None

    try:
        #include_cpus = jot(sys.argv[1:])
        cpus = jot(sys.argv[1])
    except IndexError:
        cpus = []

    try:
        poll(irqs, cpus, INTERVAL)
    except KeyboardInterrupt:
        sys.exit(0)

if __name__ == '__main__':
    main()
