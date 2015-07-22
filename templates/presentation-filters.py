#!/usr/bin/python
import pandocfilters as pf
import json
import sys

lastsection = ''
lastsubsection = ''

def lb(s):
    return pf.RawBlock('latex', s)

def li(s):
    return pf.RawInline('latex', s)

def afterframe(s):
    global lastsection, lastsubsection
    return [pf.Header(1, ('', ['unnumbered'], []), [pf.Str(lastsection)]),
            pf.Header(2, ('', ['unnumbered'], []), [pf.Str(lastsubsection)]),
            lb(s)]

def fig(name, props):
    return li('    \\includegraphics[%s]{%s}\n' % (props, name))

def structure_para(v, f, m):
    value = pf.stringify(v)
    if value.startswith('[') and value.endswith(']'):
        content = value[1:-1]
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
        elif content == 'nosupertitle':
            return afterframe('\\nosupertitle')
        if content == 'sectiontitle':
            return afterframe('\\sectiontitle')
        elif content == 'subsectiontitle':
            return afterframe('\\subsectiontitle')

def structure_header(v, f, m):
    global lastsection, lastsubsection
    if v[0] == 1:
        lastsection = pf.stringify(v[2])
        lastsubsection = ''
    elif v[0] == 2:
        lastsubsection = pf.stringify(v[2])

def parse_figname(v, pos, l):
    startpos = pos
    while pos < l and v[pos] != ',' and v[pos] != '{':
        pos = pos + 1
    return [pos, v[startpos:pos]]

def parse_figprops(v, pos, l):
    startpos = pos
    braces = 0
    while pos < l and (v[pos] != '}' or braces > 0):
        if v[pos] == '{':
            braces = braces + 1
        elif v[pos] == '}':
            braces = braces - 1
        pos = pos + 1
    return [pos + 1, v[startpos:pos]] # closing }

def parse_figitem(v, pos, l):
    [pos, name] = parse_figname(v, pos, l)
    if pos < l and v[pos] == '{':
        [pos, prop] = parse_figprops(v, pos + 1, l)  # initial {
    else:
        prop = ''
    return [pos + 1, [name, prop]] # comma between items

def parse_figlist(v):
    result = []
    pos = 0
    l = len(v)
    while pos < l:
        [pos, item] = parse_figitem(v, pos, l)
        result.append(item)
    return result

def image_figure(v, f, m):
    figstart = [ li('\\begin{figure}\n'), ]
    figs = [ fig(*f) for f in parse_figlist(v[1][0].replace('%20', ' ')) ]
    caption = [ li('    \\caption{') ] + v[0] + [ li('}\n') ] if len(v[0]) > 0 else []
    figend = [ li('\\end{figure}') ]
    return figstart + figs + caption + figend

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
    json.dump(doc, sys.stdout)
