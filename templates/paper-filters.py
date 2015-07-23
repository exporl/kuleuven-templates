#!/usr/bin/python
import pandocfilters as pf
import json
import sys

incolumns = False
inblock = False
columns = 1
colwidthleft = 1.0
colleft = 1
marginnote = ''

def lb(s):
    return pf.RawBlock('latex', s)

def li(s):
    return pf.RawInline('latex', s)

def fig(name, props):
    return li('    \\includegraphics[%s]{%s}\n' % (props, name))

def structure_para(v, f, m):
    global marginnote
    if not len(marginnote) == 0:
        note = [li(r'\m{%s}' % marginnote)]
        marginnote = ''
        return pf.Para(note + v)

def structure_header(v, f, m):
    global marginnote
    if v[0] == 5:
        marginnote = pf.stringify(v[2])
        return []

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
    if pf.stringify(v[0]).startswith('*'):
        figtype = 'figure*'
        v[0][0]['c'] = v[0][0]['c'][1:]
    else:
        figtype = 'figure'
    figstart = [ li('\\begin{%s}\n    \\centering\n' % figtype), ]
    figs = [ fig(*f) for f in parse_figlist(v[1][0].replace('%20', ' ')) ]
    caption = [ li('    \\caption{') ] + v[0] + [ li('}\n') ] if len(v[0]) > 0 else []
    figend = [ li('\\end{%s}' % figtype) ]
    return figstart + figs + caption + figend

# Supported syntax:
#   ##### header5: margin note

def filter_structure(k, v, f, m):
    if k == 'Para':
        return structure_para(v, f, m)
    if k == 'Header':
        return structure_header(v, f, m)

# Supported syntax:
#   ![*caption](figure{options},figure{options...): figure float

def filter_image(k, v, f, m):
    if k == 'Image' and v[1][1] == 'fig:':
        return image_figure(v, f, m)

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
    doc = pf.walk(doc, filter_image, format, doc[0]['unMeta'])
    doc = pf.walk(doc, filter_paraenum, format, doc[0]['unMeta'])
    json.dump(doc, sys.stdout)
