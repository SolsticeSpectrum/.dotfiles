# Advanced Tables

## Table with Horizontal Lines

```typst
#table(
  columns: (1fr, 1fr, 1fr),
  inset: 10pt,
  fill: (col, row) => if row == 0 { rgb("#f0f0f0") } else { white },
  [*Header 1*], [*Header 2*], [*Header 3*],
  table.hline(),
  [Data 1], [Data 2], [Data 3],
  [Data 4], [Data 5], [Data 6],
  table.hline(),
  [*Total*], [], [*\$100*],
)
```

## Table with Cell Spanning

```typst
#table(
  columns: 3,
  inset: 10pt,
  table.cell(colspan: 3, fill: rgb("#f0f0f0"))[*Full Width Header*],
  [A], [B], [C],
  table.cell(rowspan: 2)[Merged], [D], [E],
  [F], [G],
)
```

## Alternating Row Colors

```typst
#table(
  columns: (1fr, 1fr, 1fr),
  inset: 10pt,
  fill: (col, row) => {
    if row == 0 { rgb("#333333") }
    else if calc.odd(row) { rgb("#f5f5f5") }
    else { white }
  },
  table.header(
    text(fill: white)[*Col 1*],
    text(fill: white)[*Col 2*],
    text(fill: white)[*Col 3*],
  ),
  [Row 1], [Data], [Data],
  [Row 2], [Data], [Data],
  [Row 3], [Data], [Data],
)
```

## Table with Custom Alignment

```typst
#table(
  columns: (auto, 1fr, auto),
  inset: 10pt,
  align: (left, center, right),
  [*Left*], [*Center*], [*Right*],
  [Text], [Text], [\$100.00],
  [More], [More], [\$250.50],
)
```
