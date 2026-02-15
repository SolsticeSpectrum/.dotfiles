# Advanced Typst Syntax

## Variables and Functions

```typst
// Define variable
#let company = "Acme Corp"
#let price = 99.99

// Use variable
Welcome to #company! Our price is \$#price.

// Define function
#let highlight(content) = {
  block(fill: rgb("#fff3cd"), inset: 10pt, radius: 4pt)[#content]
}

// Use function
#highlight[This is highlighted text.]
```

## Conditionals

```typst
#let show_advanced = true

#if show_advanced [
  = Advanced Section
  This section is only shown when show_advanced is true.
]

// Inline conditional
The status is #if status == "ok" [good] else [bad].
```

## Loops

```typst
// For loop
#for i in range(1, 6) [
  Item #i
]

// Loop over array
#let items = ("Apple", "Banana", "Cherry")
#for item in items [
  - #item
]

// Loop with index
#for (i, item) in items.enumerate() [
  #(i + 1). #item
]
```

## Arrays and Dictionaries

```typst
// Array
#let fruits = ("apple", "banana", "cherry")
First fruit: #fruits.at(0)
Length: #fruits.len()

// Dictionary
#let person = (
  name: "John",
  age: 30,
  city: "Prague"
)
Name: #person.name
Age: #person.age
```
