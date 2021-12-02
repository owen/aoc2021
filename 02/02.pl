:- use_module(library(csv)).
:- use_module(library(clpfd)).

load_data(Rows) :-
    retractall(move(_,_)),
    csv_read_file("input.txt", Rows, [functor(move), arity(2), separator(0' )]).

eval_moves([], Aim, Depth, Horizontal, Result) :-
    Result is Horizontal * Depth.

eval_moves([move(down, X)|Tail], Aim, Depth, Horizontal, Result) :-
    AimN is Aim + X,
    eval_moves(Tail, AimN, Depth, Horizontal, Result).

eval_moves([move(up, X)|Tail], Aim, Depth, Horizontal, Result) :-
    AimN is Aim - X,
    eval_moves(Tail, AimN, Depth, Horizontal, Result).

eval_moves([move(forward, X)|Tail], Aim, Depth, Horizontal, Result) :-
    HorizN is Horizontal + X,
    DepthN is (Aim * X) + Depth,
    eval_moves(Tail, Aim, DepthN, HorizN, Result).

go(Vert, Horiz, Mult) :-
    load_data(R),
    eval_moves(R, 0, 0, 0, Result). 
