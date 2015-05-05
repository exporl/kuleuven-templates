import pandocfilters as pf
import json
import sys

incolumns = False
inblock = False
columns = 1
colwidthleft = 1.0
colleft = 1

def lb(s):
    return pf.RawBlock('latex', s)

def li(s):
    return pf.RawInline('latex', s)

def fig(name, props):
    return li('    \\includegraphics[%s]{%s}\n' % (props, name))

# TODO: use f=latex/beamer to switch between slides or poster

def structure_para(v, f, m):
    global columns, colwidthleft, colleft, incolumns, inblock
    value = pf.stringify(v)
    if value.startswith('[') and value.endswith(']'):
        content = value[1:-1]
        result = []
        if content.startswith('columns='):
            columns = int(content[8:])
            colwidthleft = 1.0
            colleft = columns
            if inblock:
                result.append(lb(r'\end{block}'))
            inblock = False
            if incolumns:
                result.append(lb(r'\end{columns}'))
            incolumns = True
            result.append(lb(r'\begin{columns}'))
            return result
        elif content == 'column' or content.startswith('column='):
            if inblock:
                result.append(lb(r'\end{block}'))
            inblock = False
            if content.startswith('column='):
                width = float(content[7:])
            else:
                width = colwidthleft / colleft
            colwidthleft -= width
            colleft -= 1
            result.append(lb(r'\column{(\linewidth-%dcm)*\real{%f}}' % (columns - 1, width)))
            return result

def structure_header(v, f, m):
    global inblock
    result = []
    if v[0] == 1:
        if inblock:
            result.append(lb(r'\end{block}'))
        inblock = True
        result.append(lb(r'\begin{block}{%s}' % pf.stringify(v[2])))
        return result
    elif v[0] == 2:
        # second level ignored and removed on posters
        return []
    elif v[0] == 3:
        result.append(lb(r'\structure{%s}' % pf.stringify(v[2])))
        return result

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
#   [column=...]: start a new column with given fraction of the page width
#   # header1: start a new block
#   ## header1: ignored for compatibility with the presentation template
#   ### header3: start a new structural section (\structure)

def filter_structure(k, v, f, m):
    if k == 'Para':
        return structure_para(v, f, m)
    elif k == 'Header':
        return structure_header(v, f, m)

# Supported syntax:
#   ![caption](figure{options},figure{options...): figure float

def filter_image(k, v, f, m):
    if k == 'Image' and v[1][1] == 'fig:':
        return image_figure(v, f, m)

if __name__ == '__main__':
    doc = json.loads(sys.stdin.read())
    if len(sys.argv) > 1:
        format = sys.argv[1]
    else:
        format = ''
    doc = pf.walk(doc, filter_structure, format, doc[0]['unMeta'])
    doc = pf.walk(doc, filter_image, format, doc[0]['unMeta'])
    json.dump(doc, sys.stdout)
