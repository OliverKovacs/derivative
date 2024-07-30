rule(+(X, 0), X).
rule(+(0, X), X).
rule(*(X, 1), X).
rule(*(1, X), X).
rule(*(_, 0), 0).
rule(*(0, _), 0).

rule(*(X, +(Y, Z)), +(*(X, Y), *(X, Z))).
rule(*(+(X, Y), Z), +(*(X, Z), *(Y, Z))).

% rule(+(X, Y), Z) :- integer(X), integer(Y), is(Z, +(X, Y)).

rule(*(X, *(Y, Z)), *(*(X, Y), Z)).
rule(*(*(X, Y), Z), *(*(X, Z), Y)) :- swap_terms(Y, Z).
rule(*(X, Y), *(Y, X)) :- swap_terms(X, Y).
rule(*(*(X, Y), Z), *(X, W)) :- integer(Y), integer(Z), is(W, *(Y, Z)).
rule(*(X, Y), Z) :- integer(X), integer(Y), is(Z, *(X, Y)).

rule(+(X, X), 2 * X).
rule(+(X, *(X, A)), Z * X) :- integer(A), is(Z, +(A, 1)).
rule(+(*(X, A), X), Z * X) :- integer(A), is(Z, +(A, 1)).
rule(+(*(X, A), *(X, B)), Z * X) :- integer(A), integer(B), is(Z, +(A, B)).

rule(d(X, X), 1).
rule(d(+(U, V), X), +(d(U, X), d(V, X))).
rule(d(*(U, V), X), +(*(d(U, X), V), *(U, d(V, X)))).
rule(d(/(1, V), X), -(/(d(V, X), *(V, V)))).
rule(d(U, X), 0) :- functor(U, _, 0), U \= X.

apply_step(X, X, _) :- functor(X, _, 0).
apply_step(X, Y, R) :- once(call(R, X, Z)), apply_step(Z, Y, R).
apply_step(X, Y, R) :- \+(call(R, X, _)), 
    functor(X, F, 1), functor(Y, F, 1),
    arg(1, X, X1), arg(1, Y, Y1), apply_step(X1, Y1, R).
apply_step(X, Y, R) :- \+(call(R, X, _)), 
    functor(X, F, 2), functor(Y, F, 2),
    arg(1, X, X1), arg(1, Y, Y1), apply_step(X1, Y1, R),
    arg(2, X, X2), arg(2, Y, Y2), apply_step(X2, Y2, R).

apply_rule(X, Y, R) :- apply_step(X, Y, R), apply_step(Y, Y, R).
apply_rule(X, Y, R) :- apply_step(X, Z, R), \+apply_step(Z, Z, R),
    apply_rule(Z, Y, R).

is_sorted(X) :- sort(X, X).

swap_terms(X, Y) :- integer(X), atom(Y).
swap_terms(X, Y) :- atom(X), atom(Y),
    atom_chars(X, XC), atom_chars(Y, YC),
    is_sorted([ YC, XC ]).
