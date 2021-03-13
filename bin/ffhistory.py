#!/usr/bin/env python3

import sys
import os
import sqlite3

def main():
    fname = sys.argv[1]

    conn = sqlite3.connect(fname)
    cursor = conn.cursor()
    select_statement = "select moz_places.url, moz_places.visit_count from moz_places;"
    cursor.execute(select_statement)
    results = cursor.fetchall()

    for url, count in results:
        print(url)

if __name__ == "__main__":
    main()
