#!/usr/bin/python
import pandocfilters as pf
import json
import sys
from commonfilters import *

incolumns = False
inblock = False
columns = 1
colwidthleft = 1.0
colleft = 1
marginnote = ''

def structure_para(v, f, m):
    global marginnote
    if not len(marginnote) == 0:
        note = [li('\\m{%s}' % marginnote)]
        marginnote = ''
        return pf.Para(note + v)

def structure_header(v, f, m):
    global marginnote
    if v[0] == 5:
        marginnote = pf.stringify(v[2])
        return []

# Supported syntax:
#   ##### header5: margin note

def filter_structure(k, v, f, m):
    if k == 'Para':
        return structure_para(v, f, m)
    if k == 'Header':
        return structure_header(v, f, m)

# Supported syntax:
#   [ipe]: start a new in-paragraph enumeration, use \item for the individual items
#   [/ipe]: end an in-paragraph enumeration

def filter_paraenum(k, v, f, m):
    if k == 'Str':
        value = v
        if value.startswith('[') and value.endswith(']'):
            content = value[1:-1]
            if content == 'ipe':
                return li('\\begin{inparaenum}[(1)]')
            elif content == '/ipe':
                return li('\\end{inparaenum}')

if __name__ == '__main__':
    doc = json.loads(sys.stdin.read())
    if len(sys.argv) > 1:
        format = sys.argv[1]
    else:
        format = ''
    doc = pf.walk(doc, filter_structure, format, doc[0]['unMeta'])
    doc = pf.walk(doc, filter_paraenum, format, doc[0]['unMeta'])
    doc = pf.walk(doc, ImageWalker().filter, format, doc[0]['unMeta'])
    json.dump(doc, sys.stdout)
