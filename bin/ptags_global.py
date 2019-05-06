#! /usr/bin/env python

# ptags
#
# Create a tags file for Python programs, usable with GNU global.
# Tagged are:
# - functions (even inside other defs or classes)
# - classes
# - filenames
# Warns about files it cannot open.
# No warnings about duplicate tags.
#
# this is a modified version of the ptags.py script that comes with Python 2.5.1
# modified by: Alberto Griggio
#

import sys, re, os

#tags = []    # Modified global variable!

def main():
    args = sys.argv[1:]
    # quickly handle everything to gtags-parser if there is no python file on
    # input...
    if no_py_files(args):
        os.system('gtags-parser -dt %s' % ' '.join(args))
    else:
        for filename in args:
            if not treat_file(filename):
                os.system('gtags-parser -dt ' + filename)
##     if tags:
##         fp = sys.stdout #open('GTAGS', 'w')
##         #tags.sort()
##         for s in tags: fp.write(s)


def no_py_files(args):
    for arg in args:
        ext = os.path.splitext(arg)[1].lower()
        if ext in ('.py', '.pyw'):
            return False
    return True


expr = '^[ \t]*(def|class)[ \t]+([a-zA-Z0-9_]+)[ \t]*[:\(]'
matcher = re.compile(expr)

def treat_file(filename):
    ext = os.path.splitext(filename)[1].lower()
    if ext not in ('.py', '.pyw'):
        return False
    try:
        fp = open(filename, 'r')
    except:
        sys.stderr.write('Cannot open %s\n' % filename)
        return False
##     base = os.path.basename(filename)
##     if base[-3:] == '.py':
##         base = base[:-3]
##     s = base + '\t' + filename + '\t' + '1\n'
##     tags.append(s)
    lineno = 0
    write = sys.stdout.write
    while True:
        line = fp.readline()
        lineno += 1
        if not line:
            break
        m = matcher.match(line)
        if m:
            content = m.group(0)
            name = m.group(2)
            s = name + '\t' + str(lineno) + ' ' + filename + '\t' + line #+ '\n'
            #tags.append(s)
            write(s)
    return True

if __name__ == '__main__':
    main()
