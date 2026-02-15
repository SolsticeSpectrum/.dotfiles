# Imports and Templates

## Import from File

```typst
// Import everything
#import "utils.typ": *

// Import specific items
#import "utils.typ": highlight, warning-box

// Import with alias
#import "utils.typ": highlight as hl
```

## Create Reusable Module (utils.typ)

```typst
// utils.typ
#let highlight(content) = {
  block(fill: rgb("#fff3cd"), inset: 10pt, radius: 4pt)[#content]
}

#let warning-box(content) = {
  block(fill: rgb("#f8d7da"), inset: 10pt, radius: 4pt)[
    *Warning:* #content
  ]
}

#let info-box(content) = {
  block(fill: rgb("#e7f3ff"), inset: 10pt, radius: 4pt)[
    *Info:* #content
  ]
}
```

## Create Template File (template.typ)

```typst
// template.typ
#let report(
  title: "",
  subtitle: "",
  author: "",
  date: datetime.today(),
  body,
) = {
  set document(title: title, author: author)
  set page(paper: "a4", margin: 2cm)
  set text(font: "New Computer Modern", size: 11pt)
  set heading(numbering: "1.")

  // Title page
  align(center)[
    #v(3cm)
    #text(size: 28pt, weight: "bold")[#title]
    #v(0.5cm)
    #text(size: 16pt)[#subtitle]
    #v(2cm)
    #text(size: 14pt)[#author]
    #v(0.5cm)
    #text(size: 12pt, fill: gray)[#date.display("[month repr:long] [day], [year]")]
  ]

  pagebreak()

  // Table of contents
  outline(title: "Contents", indent: auto)

  pagebreak()

  // Main content
  body
}
```

## Use Template

```typst
#import "template.typ": report

#show: report.with(
  title: "Annual Report",
  subtitle: "Financial Year 2025",
  author: "Finance Department",
)

= Executive Summary

Content here...

= Financial Results

More content...
```
