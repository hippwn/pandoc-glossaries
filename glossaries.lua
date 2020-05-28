--[[---------------------------------------------------------------------------
Pandoc LaTeX glossaries filter

Copyright 2020 hippwn -- see LICENCE for more informations.
]]-----------------------------------------------------------------------------


--[[---------------------------------------------------------------------------
This filter provides an easy syntax to use the package glossaries inside of
Markdown documents. 

Usage:
    $ pandoc -s example.md -o example.tex --lua-filter cleantable.lua

Translations:

| Syntax     | Equivalence   | Description                       |
| ---------- | ------------- | --------------------------------- |
| (?: foo)   | `\gls{}`      | Expand entry                      |
| (??: foo)  | `\Gls{}`      | Expand capitalized                |
| (?*: foo)  | `\glspl{}`    | Expand to plural form             |
| (??*: foo) | `\Glspl{}`    | Expand to capitalized plural form |
| (>: bar)   | `\acrshort{}` | Expand acronym                    |
| (>>: bar)  | `\acrlong{}`  | Expand to acronym meaning         |
| (>>>: bar) | `\acrfull{}`  | Expand to acronym full form       |

]]-----------------------------------------------------------------------------


-- Only run for LaTeX output
if FORMAT:match "latex" then

    local transform = false

    local tr = {}
    trs["?"]    = "gls"
    trs["??"]   = "Gls"
    trs["?*"]   = "glspl"
    trs["??*"]  = "Glspl"
    trs[">"]    = "acrshort"
    trs[">>"]   = "acrlong"
    trs[">>>"]  = "acrfull"

    function Str(el)
        if transform then return pandoc.RawInLine(
            'latex',
            el.text:gsub("(%S*)%(([?>*]+):%s?(%l+))(%S*)", function (a, b, c, d)
                    return string.format("%s\\%s{%s}%s", a, tr[b], c, d)
                end
            )
        )        
    end

    function Meta(m)
        if io.open(m.glossary) ~= nil then
            m["header-includes"] = [
                '\\usepackage[acronym,toc]{glossaries}',
                '\\makeglossaries',
                string.format('\\include{%s}', m.glossary)
            ]
            m["include-after"] = [
                '\\printglossary', 
                '\\printglossary[type=\\acronymtype]'
            ]
        end
    end

    return {
        { Meta  = Meta  },
        { Str   = Str   }
    }

end
