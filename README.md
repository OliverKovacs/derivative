# derivative

Symbolic differentiation implemented in Prolog.
Heavily inspired by [Edmund Weitz's Video](https://www.youtube.com/watch?v=EyhL1DNrSME) showcasing a similar program in Lisp.

## Usage
```
prolog derivative.pl
?- apply_rule(d(x*x + 2*x + 5, x), Y, rule).
   Y = 2*x+2
```

## Todo

- Improve simplification.
