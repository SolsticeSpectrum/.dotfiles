# Page Setup

## Custom Page with Headers/Footers

```typst
#set page(
  paper: "a4",
  margin: (top: 3cm, bottom: 2.5cm, left: 2cm, right: 2cm),
  header: [
    #set text(size: 10pt)
    Document Title
    #h(1fr)
    #datetime.today().display("[month repr:long] [day], [year]")
  ],
  footer: [
    #set text(size: 10pt)
    Company Name
    #h(1fr)
    Page #counter(page).display()
  ],
)
```

## Page Numbering

```typst
// Simple page numbers
#set page(numbering: "1")

// Page X of Y
#set page(
  footer: align(center)[
    Page #counter(page).display() of #context counter(page).final().at(0)
  ]
)

// Roman numerals for front matter
#set page(numbering: "i")
// ... front matter ...

#counter(page).update(1)
#set page(numbering: "1")
// ... main content ...
```

## Multiple Columns

```typst
// Two columns for entire document
#set page(columns: 2)

// Or specific sections
#columns(2, gutter: 1cm)[
  Left column content here.

  #colbreak()

  Right column content here.
]
```
