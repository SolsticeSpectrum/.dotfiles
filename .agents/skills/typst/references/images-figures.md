# Images and Figures

## Basic Image

```typst
#image("path/to/image.png")
#image("image.png", width: 50%)
#image("image.png", height: 5cm)
```

## Figure with Caption

```typst
#figure(
  image("chart.png", width: 80%),
  caption: [Sales data for Q1 2026],
)

// Reference figure
See @fig-sales for details.

#figure(
  image("chart.png", width: 80%),
  caption: [Sales data],
) <fig-sales>
```

## Side-by-side Images

```typst
#grid(
  columns: 2,
  gutter: 1cm,
  figure(image("img1.png"), caption: [First image]),
  figure(image("img2.png"), caption: [Second image]),
)
```

## Code Blocks

```typst
// Inline code
Use the `print()` function.

// Code block with language highlighting
\`\`\`python
def hello():
    print("Hello, World!")
\`\`\`

// Styled code block
#show raw.where(block: true): it => {
  block(
    fill: rgb("#f5f5f5"),
    inset: 10pt,
    radius: 4pt,
  )[#it]
}
```

## Mathematical Notation

```typst
// Inline math
The formula $x = (-b plus.minus sqrt(b^2 - 4 a c)) / (2 a)$ solves quadratic equations.

// Display math
$ sum_(i=1)^n i = (n(n+1))/2 $

$ integral_0^infinity e^(-x^2) dif x = sqrt(pi)/2 $
```
