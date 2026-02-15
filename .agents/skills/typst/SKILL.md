---
name: typst
description: Use when creating professional PDF documents - reports, documentation, comparisons, analyses. Replaces Markdown/LaTeX for document output.
---

# Document Creation with Typst

## Overview

Typst is a modern markup language for creating professional PDF documents. Use it whenever document output is needed - reports, analyses, technical documentation, comparisons. For advanced features and detailed syntax, see reference.md.

## Quick Start

```bash
# Check if installed
typst --version

# If not installed (Arch Linux)
sudo pacman -S typst

# Compile document
typst compile document.typ

# Watch mode (auto-recompile on save)
typst watch document.typ
```

## Basic Document

```typst
#set document(title: "Report Title", author: "Author")
#set page(paper: "a4", margin: 2cm)
#set text(font: "New Computer Modern", size: 11pt)
#set heading(numbering: "1.")

= Executive Summary
Brief overview paragraph here.

= Section One
Regular paragraph text with *bold* and _italic_ formatting.

- Bullet point one
- Bullet point two
```

## Text Formatting

```typst
*bold text*
_italic text_
`inline code`
#text(fill: red)[colored text]
#text(weight: "bold", size: 14pt)[styled text]
#link("https://example.com")[link text]
```

## Headings

```typst
= Level 1 Heading
== Level 2 Heading
=== Level 3 Heading
```

## Lists

```typst
// Unordered
- Item one
- Item two
  - Nested item

// Ordered
+ First
+ Second
+ Third
```

## Tables

```typst
#table(
  columns: (1fr, 1fr, 1fr),
  inset: 10pt,
  [*Column 1*], [*Column 2*], [*Column 3*],
  [Row 1 A], [Row 1 B], [Row 1 C],
)
```

For styled tables, comparison tables, and advanced formatting, see `references/tables.md`.

## Highlighted Blocks

```typst
#block(fill: rgb("#e7f3ff"), inset: 15pt, radius: 6pt)[
  *Important:* Key information here.
]
```

For colored blocks (success/warning/error), see `references/page-setup.md`.

## Page Layout

```typst
#set document(title: "Title", author: "Author")
#set page(paper: "a4", margin: 2cm)
#set text(font: "New Computer Modern", size: 11pt)
#set heading(numbering: "1.")
```

For columns, headers, footers, and page numbers, see `references/page-setup.md`.

## Command Reference

| Command | Description |
|---------|-------------|
| `typst compile doc.typ` | Compile to PDF |
| `typst compile doc.typ out.pdf` | Compile with custom output name |
| `typst watch doc.typ` | Auto-recompile on changes |
| `typst fonts` | List available fonts |
| `typst --help` | Show help |

## Quick Reference

| Element | Syntax |
|---------|--------|
| Bold | `*text*` |
| Italic | `_text_` |
| Code | `` `code` `` |
| Heading 1 | `= Title` |
| Heading 2 | `== Title` |
| Bullet list | `- item` |
| Numbered list | `+ item` |
| Link | `#link("url")[text]` |
| Image | `#image("path.png")` |
| Color text | `#text(fill: red)[text]` |

## Deep-dive documentation

For detailed patterns and best practices, see:

| Reference | Description |
|-----------|-------------|
| [references/installation.md](references/installation.md) | Installation on all platforms, CLI options |
| [references/advanced-syntax.md](references/advanced-syntax.md) | Variables, functions, conditionals, loops |
| [references/tables.md](references/tables.md) | Cell spanning, alternating colors, hlines |
| [references/page-setup.md](references/page-setup.md) | Headers, footers, page numbers, columns |
| [references/typography.md](references/typography.md) | Fonts, paragraphs, heading styles |
| [references/images-figures.md](references/images-figures.md) | Figures, captions, code blocks, math |
| [references/modules-templates.md](references/modules-templates.md) | Imports, reusable modules, document templates |
| [references/troubleshooting.md](references/troubleshooting.md) | Common errors, performance, editor setup |

## Ready-to-use templates

Executable workflow scripts for common patterns:

| Template | Description |
|----------|-------------|
| [templates/compile_all.sh](templates/compile_all.sh) | Compile all .typ files in directory |
| [templates/check_install.sh](templates/check_install.sh) | Check installation and available fonts |

Usage:
```bash
./templates/compile_all.sh ./docs
./templates/check_install.sh
```
