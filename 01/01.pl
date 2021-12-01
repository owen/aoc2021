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
zip(A,B,R) :- zip(A,B,[],R).
zip([], [], R, R) :- !.
zip(_, [], R, R) :- !.
zip([], _, R, R) :- !.
zip([A|As], [B|Bs], Iter, Rest) :-
    append(Iter, [[A, B]], IterA),
    zip(As, Bs, IterA, Rest).

gen_list_measures(Measures) :-
    %%%
    % Create two lists using the input.
    %
    % Cheat a bit and append inf/0 to the head of the
    % prev_measure list - this gets us the following:
    %
    % Cur:  [a   b c d e  ]
    % Prev: [Inf a b c d e]
    %
    % which means our first search is always N/A :)
    text_to_list("input.txt", PrePrev),
    text_to_list("input.txt", Current),
    append([inf], PrePrev, Previous),
    zip(Previous, Current, Measures).

increasing_depth([Prev|[Cur]]) :- (Cur > Prev).


count_solutions(Result) :-
    gen_list_measures(M), include(increasing_depth, M, Res), length(Res, Result).
