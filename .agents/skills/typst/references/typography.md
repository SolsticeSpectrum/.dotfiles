# Typography

## Font Configuration

```typst
// Set main font
#set text(font: "New Computer Modern", size: 11pt)

// Set heading font
#show heading: set text(font: "Libertinus Serif")

// Available bundled fonts:
// - New Computer Modern (default, LaTeX-style)
// - Libertinus Serif
// - Libertinus Sans
// - DejaVu Sans
// - DejaVu Serif
// - DejaVu Sans Mono

// List system fonts: typst fonts
```

## Paragraph Styling

```typst
// Justified text with first-line indent
#set par(
  justify: true,
  first-line-indent: 1em,
  leading: 0.65em,  // line spacing
)

// No indent after headings
#show heading: it => {
  it
  par(text(size: 0pt, ""))  // Reset indent
}
```

## Heading Customization

```typst
// Numbered headings
#set heading(numbering: "1.1")

// Custom heading style
#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  v(1cm)
  text(size: 20pt, weight: "bold")[#it]
  v(0.5cm)
}

#show heading.where(level: 2): it => {
  v(0.5cm)
  text(size: 14pt, weight: "bold")[#it]
  v(0.3cm)
}
```
