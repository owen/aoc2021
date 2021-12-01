:- use_module(library(lists)).
:- use_module(library(readutil)).

is_blank(I) :- "" = I.

stream_lines(In, Lines) :-
    read_string(In, _, Str),
    split_string(Str, "\n", "", LinesWithBlanks),
    exclude(is_blank, LinesWithBlanks, LinesS),
    maplist(number_string, Lines, LinesS).

text_to_list(File, Lines) :-
    setup_call_cleanup(
	open(File, read, In),
	stream_lines(In, Lines),
	close(In)).  
zip3(A,B,C,R) :- zip3(A,B,C,[],R).
zip3([], [], [], R, R) :- !.

zip3(_, _, [], R, R) :- !.
zip3(_, [], _, R, R) :- !.
zip3([], _, _, R, R) :- !.

zip3([A|As], [B|Bs], [C|Cs], Iter, Rest) :-
    append(Iter, [[A, B, C]], IterA),
    zip3(As, Bs, Cs, IterA, Rest).

gen_list_measures(Measures) :-
    %%%
    % Create THREE sliding lists using the input.
    %
    % n n 1 2 3 4 5
    % n 1 2 3 4 5
    % 1 2 3 4 5
    % Then slice off the nils for our windows.
    text_to_list("input.txt", PreA),
    text_to_list("input.txt", PreB),
    text_to_list("input.txt", C),
    append([nil, nil], PreA, A),
    append([nil], PreB, B),
    zip3(A,B,C, Measures).

sliding_sum(Input, Output) :-
    exclude(has_nil, Input, Output).    

has_nil([A|[B|[C]]]) :- A == nil; B == nil; C == nil.
sum3(Out, [A|[B|[C]]]) :- (A + B + C) = Out.
increasing_window([A|B]) :- B=[C|_], C > A.

sum_windows([], Result, Result) :- !.
sum_windows([_], Result, Result) :- !.
sum_windows([A|As], Iter, Result) :-
    As=[B|_],
    ((A < B) ->
	 IterN is Iter + 1;
     IterN is Iter),
    sum_windows(As, IterN, Result).
sum_windows(List, Result) :- sum_windows(List, 0, Result).

count_solutions(Result) :-
    gen_list_measures(M),
    sliding_sum(M, O),
    maplist(sum3, Rv, O),
    sum_windows(Rv, Result).
