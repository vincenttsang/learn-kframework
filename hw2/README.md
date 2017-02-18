#Problem I:
Define the NB language in Quiz 1 (both syntax and semantics) using the K tool.
Make sure it gets stuck on "iszero false" and "if 0 then 0 else 0", but passes
"if true then 0 else iszero false".

#Problem II:
The current K LAMBDA semantics of `mu` (in Lesson 8) is based on
substitution, and then `letrec` is defined as a derived operation using
`mu`.  Give `mu` a different semantics, as a derived construct by
translation into other LAMBDA constructs, like we defined `letrec` in
Lesson 7.
