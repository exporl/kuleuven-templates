import pandocfilters as pf

def lb(s):
    return pf.RawBlock('latex', s)

def li(s):
    return pf.RawInline('latex', s)

def fig(name, props, anim):
    return li('\\includegraphics%s[%s]{%s}\n' %
            ('<' + anim + '>' if len(anim) > 0 else '', props, name))

def latexstringify(x):
    result = []
    def go(key, val, format, meta):
        if key == 'Str':
            result.append(val)
        elif key == 'Code':
            result.append(val[1])
        elif key == 'Math':
            result.append(val[1])
        elif key == 'LineBreak':
            result.append(" ")
        elif key == 'Space':
            result.append(" ")
        elif key == 'RawInline' and val[0] == 'tex':
            result.append(val[1])
    pf.walk(x, go, "", {})
    return ''.join(result)

# Supported syntax:
#   ![*<anim>{option}caption]({options}figure,{options}figure...): figures
#
#     *: starred figure environment (normally spans 2 columns)
#     <anim>: beamer animation specification
#     <option>: latex figure options
#
#     If multiple animation/option settings are defined next to the caption,
#     they get spread across the figures. Paragraphs that only consist of
#     figures with the same caption get collapsed into one float.
#
# Examples:
#   ![]{figure}: basic figure, no float
#   ![caption]{figure}: basic figure, put into a float
#   ![*caption]{figure}: basic figure, put into a column-spanning float
#   ![{options}caption]{figure}: basic figure in float, custom options
#   ![{options}caption]{figure1,figure2}: two figures in one float, custom options for all
#   ![{options1}{options2}caption]{figure1,figure2}: two figures in one float, custom options per figure
#   ![caption]{{options1}figure1,{options2}figure2}: two figures in one float, custom options per figure
#   ![<1><2>caption]{figure1,figure2}: two figures in one float, with animation
#   ![<1><2>caption]{figure1}![<1><2>caption]{figure2}: two figures with same caption in one paragraph get collapsed into one float

class Image:
    def __init__(self, v, f, m):
        self._figtype = 'figure'
        self._rawcaption = latexstringify(v[0])
        self._caption = ''
        self._captionanims = []
        self._captionoptions = []
        self._anims = []
        self._options = []
        self._filenames = []

        self._parse_caption(self._rawcaption)
        self._parse_filenames(v[1][0].replace('%20', ' '))

        self._anims = self._spread(self._captionanims, self._anims)
        self._options = self._spread(self._captionoptions, self._options)

    def render(self):
        result = []
        if len(self._caption) > 0:
            result.append(li('\\begin{%s}\\centering\n' % self._figtype))
        for i, f in enumerate(self._filenames):
            result.append(fig(f, self._options[i], self._anims[i]))
        if len(self._caption) > 0:
            result.extend([li('\\caption{'), li(self._caption), li('}\n')])
            result.append(li('\\end{%s}' % self._figtype))
        return result

    ''' Merge consecutive images with the same caption, recalculate anims and options '''
    def merge(self, others):
        if any(self._rawcaption != o._rawcaption for o in others):
            return False
        for o in others:
            self._anims.extend(o._anims)
            self._options.extend(o._options)
            self._filenames.extend(o._filenames)
        self._anims = self._spread(self._captionanims, self._anims)
        self._options = self._spread(self._captionoptions, self._options)
        return True

    @staticmethod
    def filter(k, v, f, m):
        if k == 'Image' and v[1][1] == 'fig:':
            return Image(v, f, m).render()
        if k == 'Para' and all(vv['t'] in ['Image', 'Space'] for vv in v):
            images = [Image(vv['c'], f, m) for vv in v if vv['t'] == 'Image']
            if len(images) > 1 and images[0].merge(images[1:]):
                return pf.Para(images[0].render())

    def _spread(self, tospread, pattern):
        if len(tospread) == 0:
            return pattern
        if len(tospread) == 1:
            return [tospread[0]] * len(pattern)
        return [tospread[i] if i < len(tospread) else p for i, p in enumerate(pattern)]

    def _parse_caption(self, v):
        pos = 0
        l = len(v)
        while pos < l:
            [pos] = self._parse_captionpart(v, pos, l)

    def _parse_captionpart(self, v, pos, l):
        if pos < l and v[pos] == '*':
            self._figtype = 'figure*'
            return [pos + 1]  # +1 because of *
        if pos < l and v[pos] == '<':
            [pos, anim] = self._parse_anim(v, pos + 1, l)  # +1 because of initial <
            self._captionanims.append(anim)
            return [pos]
        if pos < l and v[pos] == '{':
            [pos, option] = self._parse_option(v, pos + 1, l)  # +1 because of initial {
            self._captionoptions.append(option)
            return [pos]
        self._caption = v[pos:]
        return [l]

    def _parse_filenames(self, v):
        pos = 0
        l = len(v)
        while pos < l:
            [pos]  = self._parse_filename(v, pos, l)

    def _parse_filename(self, v, pos, l):
        if pos < l and v[pos] == '<':
            [pos, anim] = self._parse_anim(v, pos + 1, l)  # +1 because of initial <
        else:
            anim = ''
        if pos < l and v[pos] == '{':
            [pos, option] = self._parse_option(v, pos + 1, l)  # +1 because of initial {
        else:
            option = ''
        [pos, name] = self._parse_name(v, pos, l)
        self._anims.append(anim)
        self._options.append(option)
        self._filenames.append(name)
        return [pos + 1] # +1 because of comma between items

    def _parse_anim(self, v, pos, l):
        startpos = pos
        while pos < l and v[pos] != '>':
            pos = pos + 1
        return [pos + 1, v[startpos:pos]] # +1 because of closing >

    def _parse_option(self, v, pos, l):
        startpos = pos
        braces = 0
        while pos < l and (v[pos] != '}' or braces > 0):
            if v[pos] == '{':
                braces = braces + 1
            elif v[pos] == '}':
                braces = braces - 1
            pos = pos + 1
        return [pos + 1, v[startpos:pos]] # +1 because of closing }

    def _parse_name(self, v, pos, l):
        startpos = pos
        while pos < l and v[pos] != ',':
            pos = pos + 1
        return [pos, v[startpos:pos]]

