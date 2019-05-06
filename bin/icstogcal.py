#!/usr/bin/env python
"""
icstogcal.py

import vcalendar files to google calendar

"""
import sys
import vobject

def import_files(files):
    for fileName in files:
        inStream = open(fileName, "r")
        for vobj in vobject.readComponents(inStream):
            print vobj

def main():
    files = sys.argv[1:]

    if len(files) == 0:
        print "Usage: %s <files>" % (sys.argv[0])
        exit(-1)

    import_files(files)

if __name__ == '__main__':
    main()
