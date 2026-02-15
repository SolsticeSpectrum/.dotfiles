# Troubleshooting

## Common Errors

### "unknown font family"
```bash
# List available fonts
typst fonts

# Use bundled font that always works
#set text(font: "New Computer Modern")
```

### "expected X, found Y"
- Check bracket/brace matching
- Verify function syntax
- Look for missing commas in arrays

### Special characters not working
```typst
// Escape special characters
\$ for dollar sign
\# for hash
\@ for at symbol
\* for asterisk
\_ for underscore
```

### Table alignment issues
```typst
// Explicitly set alignment
#table(
  columns: 3,
  align: (left, center, right),
  // ...
)
```

## Performance Tips

1. **Large documents**: Split into multiple files and use `#import`
2. **Many images**: Use appropriate resolution (150-300 DPI for print)
3. **Watch mode**: Use `typst watch` for iterative development
4. **Font loading**: Stick to bundled fonts for fastest compilation

## Editor Integration

**VS Code**
- Install "Typst LSP" extension
- Provides syntax highlighting, preview, error diagnostics

**Neovim**
```lua
require("mason-lspconfig").setup({
  ensure_installed = { "typst_lsp" }
})
```

**Other Editors**
- Sublime Text: Typst package
- Emacs: typst-mode
- IntelliJ: Typst plugin

## Bibliography and Citations

### Setup Bibliography
```typst
// At document end
#bibliography("refs.bib")

// Citation styles
#set bibliography(style: "ieee")
#set bibliography(style: "apa")
#set bibliography(style: "chicago-author-date")
```

### Citations
```typst
As shown by @smith2024.
Multiple citations @smith2024 @jones2023.
```

### BibTeX File (refs.bib)
```bibtex
@article{smith2024,
  author = {Smith, John},
  title = {A Great Paper},
  journal = {Journal of Examples},
  year = {2024},
}
```
