:- use_module(library(csv)).
:- use_module(library(clpfd)).

load_data :-
    retractall(move(_,_)),
    csv_read_file("input.txt", Rows, [functor(move), arity(2), separator(0' )]),
    maplist(assert, Rows).

forward_count(X) :-
    bagof(X, move(forward, X), Forth),    
    foldl(plus, Forth, 0, X).

updown(X) :-
    bagof(A, move(up, A), UpS),
    bagof(B, move(down, B), DownS),
    foldl(plus, UpS, 0, Up),
    foldl(plus, DownS, 0, Down),
    X #= Down - Up.

go(Vert, Horiz, Mult) :-
    load_data,
    forward_count(Horiz),
    updown(Vert),
    Mult #= Horiz * Vert.
