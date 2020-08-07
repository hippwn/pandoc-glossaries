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

| Syntax    | Equivalence   | Description                       |
| --------- | ------------- | --------------------------------- |
| (?:foo)   | `\gls{}`      | Expand entry                      |
| (?:Foo)   | `\Gls{}`      | Expand capitalized                |
| (?*:foo)  | `\glspl{}`    | Expand to plural form             |
| (?*:Foo)  | `\Glspl{}`    | Expand to capitalized plural form |
| (>:bar)   | `\acrshort{}` | Expand acronym                    |
| (>>:bar)  | `\acrlong{}`  | Expand to acronym meaning         |
| (>>>:bar) | `\acrfull{}`  | Expand to acronym full form       |

]]-----------------------------------------------------------------------------


-- Only run for LaTeX output
if FORMAT:match "latex" then

    local t = {}
    t["?"]    = "gls"
    t["?*"]   = "glspl"
    t[">"]    = "acrshort"
    t[">>"]   = "acrlong"
    t[">>>"]  = "acrfull"

    local tr = function (a, b, c, d)
        b = t[b]
        if c:gmatch('%u')() then
            b = (b:gsub("^%l", string.upper)) -- first letter to upper
        end
        return string.format("%s\\%s{%s}%s", a, b, c:lower(), d)
    end

    function Str(el)
        local str, s = el.text:gsub("(%S*)%(([?>*]+):(%a+)%)(%S*)", tr)
        if s ~= 0 then
            return pandoc.RawInline('latex', str)
        end
    end

    function Meta(m)
        if m.glossaries and type(m.glossaries.path) == 'table' and m.glossaries.path.t == 'MetaInlines' then
            local path = pandoc.utils.stringify(m.glossaries.path)
            if io.open(path) == nil then
                error(string.format("%s: no such file", path))
            end
        end
    end

    return {
        { Meta  = Meta },
        { Str   = Str   },
    }

end
