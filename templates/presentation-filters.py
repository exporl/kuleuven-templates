#!/usr/bin/python
import pandocfilters as pf
import json
import sys
from commonfilters import *

lastsection = ''
lastsubsection = ''

def afterframe(s):
    global lastsection, lastsubsection
    return [pf.Header(1, ('', ['unnumbered'], []), [pf.Str(lastsection)]),
            pf.Header(2, ('', ['unnumbered'], []), [pf.Str(lastsubsection)]),
            lb(s)]

class Columns:
    def __init__(self, result, columns = 1, main = False):
        self.valid = False
        self.reset(result, columns, main)

    def reset(self, result, columns, main = False):
        self.end(result)

        self.main = main
        self._columns = columns
        self._colwidthleft = 1.0
        self._colleft = columns
        self.valid = result != None

        self.begin(result)

    def begin(self, result):
        if not self.valid or result == None:
            return
        result.append(lb(r'\begin{columns}[T,onlytextwidth]'))

    def column(self, result, width = None):
        if not self.valid or result == None:
            return
        if not width:
            width = self._colwidthleft / self._colleft
        self._colwidthleft -= width
        self._colleft -= 1
        # 5mm between columns, no idea why the vskip is necessary
        result.append(lb(r'\column{(\linewidth-%fcm)*\real{%f}}\vskip-3pt' % (0.5 * (self._columns - 1), width)))

    def end(self, result):
        if not self.valid or result == None:
            return
        result.append(lb(r'\end{columns}'))
        self.valid = False

columns = []

# Supported syntax:
#   [columns=...]: start a new column set with the given number of columns
#   [column]: start a new column with equal width
#   [column=...]: start a new column with given fraction of the line width
#   [/columns]: end a column set
def structure_para(v, f, m):
    global columns
    value = pf.stringify(v)
    if value.startswith('[') and value.endswith(']'):
        content = value[1:-1]
        result = []
        if content == 'notoc':
            return afterframe('\\notoc')
        elif content == 'sectiontoc':
            return afterframe('\\sectiontoc')
        elif content == 'subsectiontoc':
            return afterframe('\\subsectiontoc')
        elif content == 'largefooter':
            return afterframe('\\largefooter')
        elif content == 'emptyfooter':
            return afterframe('\\emptyfooter')
        elif content == 'smallfooter':
            return afterframe('\\smallfooter')
        elif content == 'nofooter':
                return afterframe('\\nofooter')
        elif content == 'nosupertitle':
            return afterframe('\\nosupertitle')
        elif content == 'sectiontitle':
            return afterframe('\\sectiontitle')
        elif content == 'subsectiontitle':
            return afterframe('\\subsectiontitle')
        elif content == 'gridcanvas':
            return afterframe('\\gridcanvas')
        elif content == 'plaincanvas':
            return afterframe('\\plaincanvas')
        elif content.startswith('columns='):
            columns.append(Columns(result, int(content[8:])))
            return result
        elif content == '/columns':
            columns.pop().end(result)
            return result
        elif content == 'column' or content.startswith('column='):
            if content.startswith('column='):
                columns[-1].column(result, float(content[7:]))
            else:
                columns[-1].column(result)
            return result
        elif content.startswith('includeslides='):
            return afterframe('\includepdf[pages=-,fitpaper=false,frame=true,pagecommand={},scale=1]{%s}' % 
content[14:] )

def structure_header(v, f, m):
    global lastsection, lastsubsection
    if v[0] == 1:
        lastsection = pf.stringify(v[2])
        lastsubsection = ''
    elif v[0] == 2:
        lastsubsection = pf.stringify(v[2])

# Supported syntax:
#   [columns=...]: start a new column set with the given number of columns
#   [column]: start a new column with equal width
#   [column=...]: start a new column with given fraction of the line width
#   [/columns]: end a column set

def filter_structure(k, v, f, m):
    if k == 'Para':
        return structure_para(v, f, m)
    elif k == 'Header':
        return structure_header(v, f, m)

if __name__ == '__main__':
    doc = json.loads(sys.stdin.read())
    if len(sys.argv) > 1:
        format = sys.argv[1]
    else:
        format = ''
    doc = pf.walk(doc, filter_structure, format, doc[0]['unMeta'])
    doc = pf.walk(doc, ImageWalker().filter, format, doc[0]['unMeta'])
    json.dump(doc, sys.stdout)
