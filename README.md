# pandoc-glossaries

This filter provides an easy syntax to use the `glossaries` package when writing
Markdown documents. This is basically a translation between the syntax detailed
hereinafter and the LaTeX syntax provided by the package.

## Syntax

The following syntax will be recognized in your document.

| Syntax       | Equivalence   | Description                       |
| ------------ | ------------- | --------------------------------- |
| `(?: foo)`   | `\gls{}`      | Expand entry                      |
| `(??: foo)`  | `\Gls{}`      | Expand capitalized                |
| `(?*: foo)`  | `\glspl{}`    | Expand to plural form             |
| `(??*: foo)` | `\Glspl{}`    | Expand to capitalized plural form |
| `(>: bar)`   | `\acrshort{}` | Expand acronym                    |
| `(>>: bar)`  | `\acrlong{}`  | Expand to acronym meaning         |
| `(>>>: bar)` | `\acrfull{}`  | Expand to acronym full form       |

> **Note:** The *space* is optional: both `(?: foo)` and `(?:foo)` will be
rendered the same way.

## Usage

Once you've [installed](#Installation) the filter in your environment, just run
your conversion like you would have with the `--lua-filter` option:

```bash
$ pandoc -s example.md -o example.pdf --lua-filter glossaries.lua
```

## Installation

Just download the Lua script and place it anywhere Pandoc can see it: either in
the current directory or your *data* folder.

```bash
$ pandoc --version | grep "directory:"
Default user data directory: .local/share/pandoc or .pandoc

$ mkdir -p .local/share/pandoc/filters

$ curl -Lo .local/share/pandoc/filters/glossaries.lua https://raw.githubusercontent.com/hippwn/pandoc-glossaries/master/glossaries.lua
```

## Credits

Syntax is inspired by the following works:
- [pandoc-ac](https://github.com/Enet4/pandoc-ac)
- [pandoc-gls](https://github.com/tomncooper/pandoc-gls)

