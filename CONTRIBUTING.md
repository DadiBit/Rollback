# Contributing Guidelines

This is a document that includes standards and guidelines on how to contribute to the project.

## Versioning

> Based on: _[Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html)_

Augmented Backus-Naur form:
```abnf
version = version-core [ "-" pre-release ]  ; the actual version

version-core = major "." minor "." patch
major = absolute-number
minor = absolute-number
patch = absolute-number

pre-release = name [ "." id ]
name = 1*lower-alpha                        ; a lowercase string
id = absolute-number

absolute-number = "0" / positive-number     ; "0" or any positive number
positive-number = positive-digit *DIGIT     ; digits sequence not starting with "0"

lower-alpha = %x61-7A                       ; lowercase letter (a-z)
positive-digit = %x31-39                    ; a non-zero digit (1-9)
```

Regex (JavaScript):
```javascript
version = /^((0|[1-9][0-9]*)\.){2}(0|[1-9][0-9]*)(-[a-z]+(\.(0|[1-9][0-9]*))?)?$/

// or with named grouping:
version = /^(?<major>0|[1-9][0-9]*)\.(?<minor>0|[1-9][0-9]*)\.(?<patch>0|[1-9][0-9]*)(-(?<name>[a-z]*)(\.(?<id>0|[1-9][0-9]*))?)?$/

// Please note that:
version_core = /((0|[1-9][0-9]*)\.){2}(0|[1-9][0-9]*)/
pre_release = /(-[a-z]+(\.(0|[1-9][0-9]*))?)?/
absolute_number = /(0|[1-9][0-9]*)/
```

### Pre-release names

Commonly used names (in order of importance):

| Name | Definition
| - | - |
| alpha | New features could still be added; existing ones may change
| beta | Focus on testing and bug fixes; existing features may receive small changes
| rc | The software should work, but it may still receive a few bug fixes

### Precedence

`0.1.0` < `0.1.1-alpha.0` < `0.1.1-alpha.8` < `0.1.1-beta` < `0.1.1-beta.1` < `0.1.1-rc` < `0.1.1` < `0.2.0` < `1.0.0`

Please note that during the initial development stage the major version must remain `0`: the first release should be `0.1.0`.

## Commits

> Based on: _[Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)_

Augmented Backus-Naur form:
```abnf
commit-msg = head                           ; WHAT, HOW
             [ 2CRLF body ]                 ; WHAT, WHY
             [ 2CRLF *footer ]              ; WHO, ...
             ; no final empty new-line

head = type [ "(" scope ")" ]               ; WHAT is this commit (eg: fix(ui))
       [ "!" ] ":" SP description           ; HOW/WHAT does the commit change
type = 1*lower-alpha                        ; only letters
scope = 1*( lower-alpha / "-" )             ; use "-" instead of spaces
description = text

body = text *( 2CRLF text )                 ; at least one line
       ; WHY and WHAT does the commit change

footer = token ":" SP value CRLF            ; extra information
         ; WHO reviewed the code, references, ...
token = 1*VCHAR                             ; spaces are not allowed
value = text

text = 1*(VCHAR / SP)                       ; non-CTL characters
lower-alpha = %x61-7A                       ; lowercase letter (a-z)
```

Recommendation: limit the `head` length to 50 characters and the rest of the message to 80.

### Types

> Based on: _[angular/CONTRIBUTING.md](https://github.com/angular/angular/blob/main/CONTRIBUTING.md#-commit-message-format)_

Commonly used types:

| Type | Definition | Examples
| - | - | - |
| fix | Fix a bug | Any unintended behavior (tests included)
| feat | Introduce a new feature, or enhance existing features | 
| refactor | A code change different from `fix` and `feat` | Internal renaming, structural changes
| build | Change build/test system | `release` workflow, test suit
| test | Change test cases | 
| chore | Change configuration files | `.gitignore`, editor config
| docs | Change documentation only | README, code of conduct, contributing guidelines, in-code docs, license, wiki, and issue templates
| perf | Performance enhancement | 
| style | Formatting | Tabs, new-lines, spaces, indentation

## Emojis

Using unicode emojis is discouraged, as it can lead to a broken content view: GitHub emoji codes are recommended.
