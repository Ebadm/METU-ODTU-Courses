:- module(main, [bigram/2, num_hobbies/2, sentence_match/2]).
:- [kb].

% DO NOT CHANGE THE UPPER CONTENT, WRITE YOUR CODE AFTER THIS LINE

wordcomb([X,Y|_], [X,Y]).
wordcomb([_|Tail], XY):- wordcomb(Tail,XY).

bigram(Word,ResultBigram) :- atom_chars(Word, WordList), 
    length(WordList,L), L > 1,
    wordcomb(WordList,Result_temp),
    atomic_list_concat(Result_temp,ResultBigram).
    
%-----------------------------------------------

replacemyelem(_, _, [], []).
replacemyelem(E, N, [E|T], [N|T1]) :- replacemyelem(E, N, T, T1).
replacemyelem(E, N, [H|T], [H|T1]) :- H \= E, replacemyelem(E, N, T, T1).


num_hobbies_helper([],Acc,Acc).
num_hobbies_helper([H|T],ResultList,Acc):- person(H, _ , Hob), 
    member(hobby(Hob,X),Acc),
    Y is X+1,
    replacemyelem(hobby(Hob,X),hobby(Hob,Y),Acc,NewAcc),
    num_hobbies_helper(T,ResultList,NewAcc).

num_hobbies_helper([H|T],ResultList,Acc):- person(H, _ , Hob), 
    not(member(hobby(Hob,_),Acc)),
    append(Acc,[hobby(Hob,1)],NewAcc),
    num_hobbies_helper(T,ResultList,NewAcc).


num_hobbies([],[]).
num_hobbies([H|T],ResultList):- num_hobbies_helper([H|T],ResultList,[]).



%--------------------------------------------


check_map([],_). 
check_map([HM|TM],[HUM|TUM]) :- member(HM,[HUM|TUM]),  check_map(TM,[HUM|TUM]).
check_map([HM|_],[HUM|TUM]) :- HM = map(X,_) , member(map(X,_),[HUM|TUM]) , ! , fail.
check_map([HM|TM],[HUM|TUM]) :- HM = map(X,_) , not(member(map(X,_),[HUM|TUM])) , check_map(TM,[HUM|TUM]).



sentence_match(WordList,ResultList) :- sentence_match_helper(WordList,[],ResultList,[]).


merge_map([],[],Acc,Acc).
merge_map([],Map2,R,Acc) :- append(Map2,Acc,NewAcc) , merge_map([],[],R,NewAcc), !. %imp for no replicates
merge_map([H|T],Map2,R,Acc) :- member(H,Map2), merge_map(T,Map2,R,Acc).
merge_map([H|T],Map2,R,Acc) :- not(member(H,Map2)), append(Acc,[H],NewAcc) ,merge_map(T,Map2,R,NewAcc).




sentence_match_helper([],RAcc,RAcc,_). 
sentence_match_helper([H|T],RAcc,ResultList,Map) :- 
    atom_chars(H, HLst),
    one_element_matcher(HLst,R,Updated_map),
    check_map(Map,Updated_map),
    atomic_list_concat(R, AR),
    (   RAcc == [] ; not(member(AR,RAcc))  ),
	append(RAcc,[AR],NewAcc),
    merge_map(Map,Updated_map,NewMap,[]),
    sentence_match_helper(T,NewAcc,ResultList,NewMap).
    

%merge the Maps


one_element_matcher([H|T],NewR,Updated_map) :- word(X) , atom_chars(X, XLst) ,
    elmnt_w_word_mapper([H|T],[],[],XLst,NewR,Updated_map).

elmnt_w_word_mapper([],ResultList,Mapping,[],ResultList,Mapping).
elmnt_w_word_mapper([H|T],ResultList,Mapping,[HX|TX],NewR,Updated_map) :-  member(map(H,Z),Mapping) , Z = HX ,  
    append(ResultList,[HX],NewResultList) , elmnt_w_word_mapper(T,NewResultList,Mapping,TX,NewR,Updated_map).

elmnt_w_word_mapper([H|T],ResultList,Mapping,[HX|TX],NewR,Updated_map) :- not(member(map(H,_),Mapping)) , 
    append(Mapping,[map(H,HX)],NewMapping) , elmnt_w_word_mapper([H|T],ResultList,NewMapping,[HX|TX],NewR,Updated_map). 




