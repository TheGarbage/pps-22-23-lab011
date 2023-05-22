% search2(Elem, List)
% looks for two consecutive occurrences of Elem
search2(N, [N, N, _]) :- !.
search2(N, [X | Xs]) :- search2(N, Xs).



% search_two (Elem , List )
% looks for two occurrences of Elem with any element in between !
search_two(N, [N | T]) :- member(N, T), !.
search_two(N, [_ | T]) :- search_two(N, T).



% size (List , Size )
% Size will contain the number of elements in List
size(0, []).
size(N, [_ | T]) :- size(M, T), N is M + 1.



% sum(List , Sum )
sum([], 0).
sum([H | T], N) :- sum(T, M), N is H + M.



% max(List ,Max , Min )
% Max is the biggest element in List
% Min is the smallest element in List
% Suppose the list has at least one element
max_min([H | T], Max, Min) :- max_min(T, Max, H, Min, H).
max_min([], Max, Max, Min, Min).
max_min([H | T], Max, MaxTemp, Min, MinTemp) :- max_min(T, Max, H, Min, MinTemp), H > MaxTemp, !.
max_min([H | T], Max, MaxTemp, Min, MinTemp) :- max_min(T, Max, MaxTemp, Min, H), H < MinTemp, !.
max_min([H | T], Max, MaxTemp, Min, MinTemp) :- max_min(T, Max, MaxTemp, Min, MinTemp).



% sublist (List1 , List2 )
% List1 should contain elements all also in List2
% example : sublist ([1 ,2] ,[5 ,3 ,2 ,1]).
sublist([], List2).
sublist([H | T], X1) :- dropFirst(H, X1, X2), sublist(T, X2).



% dropAny (? Elem ,? List ,? OutList )
% dropAny(10,[10,20,10,30,10],L)
dropAny (X , [X | T], T).
dropAny (X , [H | Xs ], [H | L ]) :- dropAny (X , Xs , L ).

%dropFirst: drops only the first occurrence (showing no alternative results)
dropFirst(X, [X | T], T):- !.
dropFirst(X, [H | Xs], [H | L]) :- dropFirst(X, Xs, L).

%dropLast: drops only the last occurrence (showing no alternative results)
dropLast(X, [H | Xs], [H | L]) :- dropLast(X, Xs, L), !.
dropLast(X, [X | T], T).

%dropAll: drop all occurrences, returning a single list as a result
dropAll(N, [N | T], X) :- dropAll(N, T, X), !.
dropAll(N, [H | T1], [H | T2]) :- dropAll(N, T1, T2).
dropAll(X, [X | T], T).



% fromList (+ List ,- Graph )
fromList ([ _ ] ,[]) .
fromList ([ H1 , H2 |T ] ,[ e(H1 , H2 ) |L ]) :- fromList ([ H2 |T ],L).



% fromCircList (+ List ,- Graph )
%fromCircList([1,2,3],[e(1,2),e(2,3),e(3,1)]).
fromCircList([H1, H2 | T], [e(H1, H2) | L]) :- fromCircList([H2 | T], L, H1).
fromCircList([H2], [e(H2, H1)], H1).
fromCircList([H2, H3 | T], [e(H2, H3) | L], H1) :- fromCircList([H3 | T], L, H1).



% outDegree (+ Graph , +Node , -Deg )
% Deg is the number of edges leading into Node
% outDegree([e(1,2), e(1,3), e(3,2)], 2, 0).
% outDegree([e(1,2), e(1,3), e(3,2)], 3, 1).
% outDegree([e(1,2), e(1,3), e(3,2)], 1, 2).
outDegree([], _, 0).
outDegree([e(H1, H2) | T], H1, N) :- outDegree(T, H1, M), N is M + 1, !.
outDegree([e(H1, H2) | T], H3, N) :- outDegree(T, H3, N).



% dropNode (+ Graph , +Node , -OutGraph )
% drop all edges starting and leaving from a Node
% use dropAll defined in 1.1??
% dropNode([e(1,2),e(1,3),e(2,3)],1,[e(2,3)]).
dropNode(G, N, OG) :- dropAll(e(N, _), G, G2), dropAll(e(_, N), G3, OG).



% reaching (+ Graph , +Node , -List )
% all the nodes that can be reached in 1 step from Node
% possibly use findall , looking for e(Node ,_) combined
% with member (? Elem ,? List )
% reaching([e(1,2),e(1,3),e(2,3)],1,L).
% reaching([e(1,2),e(1,2),e(2,3)],1,L).
reaching(G, N, L) :- findall(X, member(e(N, X), G), L).



% nodes (+ Graph , -Nodes )
% create a list of all nodes (no duplicates ) in the graph ( inverse of fromList )
% nodes([e(1,2),e(2,3),e(3,4)],L).
% nodes([e(1,2),e(2,3)],L).
nodes([e(N1, N2)], [N1, N2]).
nodes([e(N1, N2), e(N2, N3) | T1], [N1, N2 | T2]) :- nodes([e(N2, N3) | T1], [N2 | T2]).



% anypath (+ Graph , +Node1 , +Node2 , -ListPath )
% a path from Node1 to Node2
% if there are many path , they are showed 1-by -1
% anypath([e(1,2),e(1,3),e(2,3)],1,3,L).
anypath(G, N1, N2, L) :- anypath(G, N1, N2, N1, L).
anypath(G, N1, N2, N3, [e(N3, N2)]):- member(e(N3, N2), G).
anypath(G, N1, N2, N3, [e(N3, N4), e(N4, N5) | N]) :- member(e(N3, N4), G), anypath(G, N1, N2, N4, [e(N4, N5) | N]).



% allreaching (+ Graph , +Node , -List )
% all the nodes that can be reached from Node
% Suppose the graph is NOT circular !
% Use findall and anyPath !
%allreaching([e(1,2),e(2,3),e(3,5)],1,[2,3,5]).
allreaching(G, N, L) :- findall(X, anypath(G, N, X, _), L).



% During last lesson we see how to generate a grid-like network. Adapt
% that code to create a graph for the predicates implemented so far.
interval (A , B , A ).
interval (A , B , X ):- A2 is A +1 , A2 < B , interval ( A2 , B , X).

neighbour (A , B , A , B2 ):- B2 is B +1.
neighbour (A , B , A , B2 ):- B2 is B -1.
neighbour (A , B , A2 , B):- A2 is A +1.
neighbour (A , B , A2 , B):- A2 is A -1.

gridlink(N , M , e(c(X, Y), c(X2, Y2))) :-
interval (0 , N , X ) ,
interval (0 , M , Y ) ,
neighbour (X , Y , X2 , Y2 ) ,
X2 >= 0, Y2 >= 0, X2 < N , Y2 < M.



% Try to generate all paths from a node to another, limiting the
% maximum number of hops
anypathgrid(D1, D2, N1, N2, L) :- findall(X, gridlink(D1, D2, X), G), anypath(G, N1, N2, L).