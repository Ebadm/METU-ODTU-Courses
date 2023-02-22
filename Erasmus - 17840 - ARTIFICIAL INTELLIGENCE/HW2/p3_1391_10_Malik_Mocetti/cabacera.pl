write_log(S) :- open('error_logs.txt', append, Out), write(Out, S), write(Out, '\n'), close(Out).

/***************
* EJERCICIO 2. sum_pot_prod/4
*
*	ENTRADA:
*		X: Vector de entrada de numeros de valor real.
*		Y: Vector de entrada de numeros de valor real.
*		Potencia: Numero de valor entero, potencia.
*	SALIDA:
*		Resultado: Numero de valor real resultado de la operacion sum_pot_prod.
*
*
* P02 (*): Sum of the products powered to a number.
*
% sum_pot_prod(X, Y, Potencia, Resultado) :- X is the first List, Y is the second List
% 	  Potencia is the power to each element's addition with
% 	  Resultado Stores the Result
*
****************/
sum_pot_prod(_, _, Potencia, _) :- Potencia &lt; 0, !, print('ERROR 2.1 Potencia.'), fail.
sum_pot_prod([], [], _, Resultado) :- Resultado is 0.
sum_pot_prod([], [_|_], _, _) :- !, print('ERROR 2.2 Longitud.'), fail.
sum_pot_prod([_|_], [], _, _) :- !, print('ERROR 2.2 Longitud.'), fail.
sum_pot_prod([X|Xs], [Y|Ys], Potencia, Resultado) :-
    sum_pot_prod(Xs, Ys, Potencia, TempRes),
    Resultado is (X*Y)**Potencia + TempRes.

/***************
* EJERCICIO 3. segundo_penultimo/3
*
*       ENTRADA:
*               L: Lista de entrada de numeros de valor real.
*       SALIDA:
*               X : Numero de valor real. Segundo elemento.
*		Y : Numero de valor real. Penultimo elemento.
*
*
* P03 (*): Second and penultimate.
*
* segundo_penultimo(L, X, Y) :- L is the list, 
* 	  X is the second element, Y is the penultimate element
*
****************/
second([_, Second| _], Second).

penultimate([Y,_],Y).
penultimate([_,X|Xs],Y) :- penultimate([X|Xs],Y).

segundo_penultimo([_], _, _):- !, print('ERROR 2.1 Potencia.'), fail.
segundo_penultimo(L, X, Y):- 
    second(L,X),
    penultimate(L,Y).

/***************
* EJERCICIO 4. sublista/5
*
*       ENTRADA:
*		L: Lista de entrada de cadenas de texto.
*		Menor: Numero de valor entero, indice inferior.
*		Mayor: Numero de valor entero, indice superior.
*		E: Elemento, cadena de texto.
*       SALIDA:
*		Sublista: Sublista de salida de cadenas de texto.
*
*
* P04 (**): Sublist that contains an element
*
* sublista(L, Menor, Mayor, E, Sublista) :- Sublista is the list of the elements of L between
*    index Menor and index Mayor (both included) which contains E.
*    (list,integer,integer,char,list) (?,+,+,?,?)
*
****************/
memberCheck([H|_], H).
memberCheck([_|T], H) :- memberCheck(T, H).

get_sublist([X|_],1,1,_,[X]).
get_sublist([X|Xs],1,K,E,[X|Ys]) :- K &gt; 1, 
   K1 is K - 1, get_sublist(Xs,1,K1,E,Ys).
get_sublist([_|Xs],I,K,E,Ys) :- I &gt; 1, 
   I1 is I - 1, K1 is K - 1, get_sublist(Xs,I1,K1,E,Ys).

sublista(L, Menor, Mayor, _, _):-
    length(L,Ln),
    (Menor &gt; Mayor ; Ln &lt; Mayor),
    !, print('ERROR 4.2 Indices.'), fail.
sublista(L, Menor, Mayor, E, Sublista):- 
    get_sublist(L, Menor, Mayor, E, Sublista),
    memberCheck(Sublista, E).
sublista(L, Menor, Mayor, E, Sublista):- 
    get_sublist(L, Menor, Mayor, E, Sublista),
    !,
    not(memberCheck(Sublista, E)),
    print('ERROR 4.1 Elemento.'), fail.

/***************
* EJERCICIO 5. espacio_lineal/4
*
*       ENTRADA:
*               Menor: Numero de valor entero, valor inferior del intervalo.
*               Mayor: Numero de valor entero, valor superior del intervalo.
*               Numero_elementos: Numero de valor entero, numero de valores de la rejilla.
*       SALIDA:
*               Rejilla: Vector de numeros de valor real resultante con la rejilla.
*
* P05 (**): Linear Space
*
* espacio_lineal(Menor, Mayor, Numero_elementos, Rejilla) :- generates the linear grid (list of equi-distant real numbers) Rejilla with the number of points Numero_elementos
*     of the interval given by [Menor, Mayor]
*    (integer,integer,integer,list) (+,+,+,?)
*
****************/
generate_step(_,_, _, 0, []).
generate_step(Menor,Mayor, Step, Numero_elementos, [Menor|Rejilla]):-
    Num is Numero_elementos-1,
    Val is Menor + Step,
    generate_step(Val, Mayor, Step, Num, Rejilla).

espacio_lineal(Menor, Mayor, _, _):-
    Menor &gt; Mayor, !, print('ERROR 5.1 Indices.'), fail.

espacio_lineal(Menor, Mayor, Numero_elementos, Rejilla):- 
    Num is (Numero_elementos-1),
    Step is (Mayor-Menor)/Num,
    generate_step(Menor, Mayor, Step, Numero_elementos, Rejilla).

/***************
* EJERCICIO 6. normalizar/2
*
*       ENTRADA:
*		Distribucion_sin_normalizar: Vector de numeros reales de entrada. Distribucion sin normalizar.
*       SALIDA:
*		Distribucion: Vector de numeros reales de salida. Distribucion normalizada.
*
* P06 (**):  Normalize probability distributions.
*
* normalizar(Distribucion_sin_normalizar, Distribucion) :- normalize the unnormalized univariate distribution Distribucion_sin_normalizar in the parameter
*	 Distribucion using the parameter z (sum of list)
*    (list,list) (?,?)
*
****************/
sum_list([], 0).
sum_list([H|T], Sum) :-
   sum_list(T, Rest),
   Sum is H + Rest.

normalize([],[],_).
normalize([H|_],_,_):-
   H &lt; 0, !, print('ERROR 6.1. Negativos.'), fail.

normalize([H|T],[N|L],Z):-
    N is H/Z,
    normalize(T, L, Z).

normalizar(Distribucion_sin_normalizar, Distribucion):- 
    sum_list(Distribucion_sin_normalizar,Z),
    normalize(Distribucion_sin_normalizar,Distribucion,Z).

/***************
* EJERCICIO 7. divergencia_kl/3
*
*       ENTRADA:
*		D1: Vector de numeros de valor real. Distribucion.
*		D2: Vector de numeros de valor real. Distribucion.
*       SALIDA:
*		KL: Numero de valor real. Divergencia KL.
*
* P07 (**): Kullback-Leibler divergence.
*
* divergencia_kl(D1, D2, KL) :- compute a notion of distance or a divergence (not exactly a distance) between two probability
*	 distributions.
*    (list,list,integer) (?,?,+)
*
****************/
distribution_check(D1, D2):- 
    sum_list(D1,S1),
    sum_list(D2,S2),
    S1 =:= 1, S2 =:= 1.

distribution_check(D1, D2):- 
    sum_list(D1,S1),
    sum_list(D2,S2),
   	(S1 &gt; 1 ; S1 &lt; 1 ; S2 &lt; 1 ; S2 &gt; 1),
    !, print('ERROR 7.2. Divergencia KL definida solo para distribuciones.'), fail.

divergencia_kl_help([], [], KL) :- KL is 0.
divergencia_kl_help([D1|_], [D2|_], _):- 
   (D1 =&lt; 0 ; D2 =&lt; 0), 
   !, print('ERROR 7.1. Divergencia KL no definida.'), fail.

divergencia_kl_help([D1|D1s], [D2|D2s], KL):- 
    divergencia_kl_help(D1s, D2s, RestKL),
    V is D1/D2,
    KL is (D1*log(V)) + RestKL.

divergencia_kl(D1, D2, KL):-
    distribution_check(D1,D2),
    divergencia_kl_help(D1, D2, KL).

/***************
* EJERCICIO 8. producto_kronecker/3
*
*       ENTRADA:
*		Matriz_A: Matriz de numeros de valor real.
*		Matriz_B: Matriz de numeros de valor real.
*       SALIDA:
*		Matriz_bloques: Matriz de bloques (matriz de matrices) de numeros reales.
*
* P08 (**): Block matrix given by the Kronecker product. 
*
* producto_kronecker(Matriz_A, Matriz_B, Matriz_bloques) :- the list Matriz_bloques is obtained from the matrix A &amp; B by
*    Kronecker product.
*    (list,list,list) (+,+,+)
*
* Note: flatten(+List1, -List2) is a predefined predicate
* multiplier(A,MatrixB,R): takes an element from matrix A and multiplies it to the blocks of B, resulting in the matrix R
* list_positive_check(Matriz_A, Matriz_B): Checks if both Matrix A &amp; B are positive after flattening them.
* inter_producto(Matriz_A, Matriz_B, Matriz_bloques): Multiplies each element of matrix A and calls multiplier on it,
* appending to the final resultant matrix.
*
****************/
empty_list([]).

list_positive_check(Matriz_A, Matriz_B):-
    flatten(Matriz_A,A),
    flatten(Matriz_B,B),
	maplist(&lt;(-1), A),
    maplist(&lt;(-1), B).

multiplier(_,[],[]).
multiplier(A,X,[R1]):- integer(X), R1 is A*X. 
multiplier(A,[H|T],R):-  multiplier(A,H,R1), multiplier(A,T,R2), empty_list(R2), append(R1,R2,R).
multiplier(A,[H|T],[R]):-  multiplier(A,H,R1), multiplier(A,T,R2), append(R1,R2,R).

inter_producto([], _, []).
inter_producto([H|T], Matriz_B, Matriz_bloques):-
        multiplier(H,Matriz_B,Res),
		inter_producto(T, Matriz_B, Acc),
     	append(Res,Acc,Matriz_bloques).

producto_kronecker(Matriz_A, Matriz_B, _):-
    not(list_positive_check(Matriz_A, Matriz_B)),
	!, print('ERROR 8.1. Elemento menor que cero.'), fail.

producto_kronecker(Matriz_A, Matriz_B, Matriz_bloques):-
    flatten(Matriz_A,A),
    inter_producto(A, Matriz_B, Matriz_bloques).

/***************
* EJERCICIO 9a. distancia_euclidea/3
*
*       ENTRADA:
*               X1: Vector de numeros de valor real. 
*               X2: Vector de numeros de valor real.
*       SALIDA:
*               D: Numero de valor real. Distancia euclidea.
*
* 9.1 Euclidean distance - distancia_euclidea/3
* distancia_euclidea(X1, X2, D):- takes two lists X1 &amp; X2 and provides the euclidean distance in D.
* (list,list,float) (?,?,+)
*
****************/
distancia_euclidea(X1, X2, D):-
	euclidean_acc(X1,X2,0,Dsq),
	D is sqrt(Dsq).

euclidean_acc([],[],Distance,Distance).
euclidean_acc([X1|List1],[X2|List2],Current,SquaredDistance) :-
	New is Current+(X1-X2)**2, % (X1-X2)**2 means X1-X2 squared
	euclidean_acc(List1,List2,New,SquaredDistance).

/***************
* EJERCICIO 9b. calcular_distancias/3
*
*       ENTRADA:
*               X_entrenamiento: Matriz de numeros de valor real donde cada fila es una instancia representada por un vector.
*               X_test: Matriz de numeros de valor real donde cada fila es una instancia representada por un vector. Instancias sin etiquetar.
*       SALIDA:
*               Matriz_resultados: Matriz de numeros de valor real donde cada fila es un vector con la distancia de un punto de test al conjunto de entrenamiento X_entrenamiento.
*
* 9.2 Computing distances between points - calcular_distancias/3
* calcular_distancias(X_entrenamiento, X_test, Matriz_resultados): provides distance of each X_test instance vs X_entrenamiento
* (list,list,list) (?,?,?)
*
****************/
distance_acc([], _, []).
distance_acc([X|Xs], T, [NewR|R]):-
    distancia_euclidea(X, T, NewR),
    distance_acc(Xs, T, R).
    
calcular_distancias(_, [], []).
calcular_distancias(X_entrenamiento, [T|Ts], [Res|R]):-
    distance_acc(X_entrenamiento, T, Res),
    calcular_distancias(X_entrenamiento, Ts, R).

/***************
* EJERCICIO 9c. predecir_etiquetas/4
*
*       ENTRADA:
*               Y_entrenamiento: Vector de valores alfanumericos de una distribucion categorica. Cada etiqueta corresponde a una instancia de X_entrenamiento.
*               K: Numero de valor entero.
*               Matriz_resultados: Matriz de numeros de valor real donde cada fila es un vector con la distancia de un punto de test al conjunto de entrenamiento X_entrenamiento.
*       SALIDA:
*               Y_test: Vector de valores alfanumericos de una distribucion categorica. Cada etiqueta corresponde a una instancia de X_test.
*
* 9.3 Predicting the labels of test points - predecir_etiquetas/4 
* predecir_etiquetas(Y_entrenamiento, K, Matriz_resultados,Y_test):  computes the predictions Y_test with respect 
* to the matrix of distances Matriz_resultados
* (list,int,list,list,) (?,?,?)
*
****************/
predecir_etiquetas(_, _, [],[]).
predecir_etiquetas(Y_entrenamiento, K, [M|Ms],[R|Rs]):-
    predecir_etiqueta(Y_entrenamiento, K, M, R),
    predecir_etiquetas(Y_entrenamiento, K, Ms,Rs), !.

/***************
* 9.3 Utilities
*
* EJERCICIO 9d. predecir_etiqueta/4
*
*       ENTRADA:
*               Y_entrenamiento: Vector de valores alfanumericos de una distribucion categorica. Cada etiqueta corresponde a una instancia de X_entrenamiento.
*               K: Numero de valor entero.
*               Vec_distancias: Vector de valores reales correspondiente a una fila de Matriz_resultados.
*       SALIDA:
*               Etiqueta: Elemento de valor alfanumerico.
*
* 9.3.1 Predicting the label of each test point -  predecir_etiqueta/4 
* predecir_etiqueta(Y_entrenamiento, K, Vec_distancias, Etiqueta) :   computes in Etiqueta the 
* most closest label according to Vec_distancias of each test set point
*
****************/
predecir_etiqueta(Y_entrenamiento, K, Vec_distancias, Etiqueta):-
    calcular_K_etiquetas_mas_relevantes(Y_entrenamiento, K, Vec_distancias, K_etiquetas),
    calcular_etiqueta_mas_relevante(K_etiquetas, Etiqueta).

/***************
* EJERCICIO 9e. calcular_K_etiquetas_mas_relevantes/4
*
*       ENTRADA:
*               Y_entrenamiento: Vector de valores alfanumericos de una distribucion categorica. Cada etiqueta corresponde a una instancia de X_entrenamiento.
*               K: Numero de valor entero.
*               Vec_distancias: Vector de valores reales correspondiente a una fila de Matriz_resultados.
*       SALIDA:
*		K_etiquetas: Vector de valores alfanumericos de una distribucion categorica.
*
* Computation of the most relevant labels. calcular_K_etiquetas_mas_relevantes/4
* calcular_K_etiquetas_mas_relevantes(Y_entrenamiento, K, Vec_distancias, K_etiquetas)
*
****************/
element_at(X,[X|_],1).
element_at(X,[_|L],K) :- K &gt; 1, K1 is K - 1, element_at(X,L,K1).

indexOf([Element|_], Element, 1):- !.
indexOf([_|Tail], Element, Index):-
  indexOf(Tail, Element, Index1),
  !,
  Index is Index1+1.

del([X|XS], CNT, [X|RES]) :- 
    NEXT is CNT - 1,
    del(XS, NEXT, RES).
del([_|XS], 1, XS).

calcular_K_etiquetas_mas_relevantes(_, 0, _, []).
calcular_K_etiquetas_mas_relevantes(Y_entrenamiento, K, Vec_distancias, K_etiquetas):-
    min_list(Vec_distancias,E),
    indexOf(Vec_distancias,E,Index),
    element_at(R,Y_entrenamiento,Index),
    del(Vec_distancias,Index, V),
    del(Y_entrenamiento,Index, Y),
    K1 is K - 1,
    calcular_K_etiquetas_mas_relevantes(Y, K1, V, Res), !,
    append(Res,[R],K_etiquetas).

/***************
* EJERCICIO 9f. calcular_etiqueta_mas_relevante/2
*
*       ENTRADA:
*               K_etiquetas: Vector de valores alfanumericos de una distribucion categorica.
*       SALIDA:
*               Etiqueta: Elemento de valor alfanumerico.
*
*
*Computation of the most relevant label. calcular_etiqueta_mas_relevante/2 
*calcular_etiqueta_mas_relevante(K_etiquetas, Etiqueta)
*
****************/
calcular_etiqueta_mas_relevante(K_etiquetas, Etiqueta):- 
  sort(K_etiquetas, Uniq),                  % sort removing duplicate elements
  findall([Freq, X], (
      member(X, Uniq),              		% for each unique element X
      include(=(X), K_etiquetas, XX),      
      length(XX, Freq)              		% count how many times appears in List
  ), Freqs),
  sort(Freqs, SFreqs),              		% sort (by frequency)
  last(SFreqs, [Freq, Etiqueta]). 			% last pair is the most common

/***************
* EJERCICIO 9g. k_vecinos_proximos/5
*
*       ENTRADA:
*		X_entrenamiento: Matriz de numeros de valor real donde cada fila es una instancia representada por un vector.
*		Y_entrenamiento: Vector de valores alfanumericos de una distribucion categorica. Cada etiqueta corresponde a una instancia de X_entrenamiento.
*		K: Numero de valor entero.
*		X_test: Matriz de numeros de valor real donde cada fila es una instancia representada por un vector. Instancias sin etiquetar.
*       SALIDA:
*		Y_test: Vector de valores alfanumericos de una distribucion categorica. Cada etiqueta corresponde a una instancia de X_test.
*
* 9.4 Joining the predicates - k_vecinos_proximos/5
* k_vecinos_proximos(X_entrenamiento, Y_entrenamiento,K, X_test, Y_test):  computes the predictions Y_test with respect 
* to the matrix of distances Matriz_resultados
* (list,int,list,list,) (?,?,?)
*
****************/
k_vecinos_proximos(X_entrenamiento, Y_entrenamiento,K, X_test, Y_test):- 
    calcular_distancias(X_entrenamiento, X_test, D),
    predecir_etiquetas(Y_entrenamiento, K, D,Y_test), !.

/***************
* EJERCICIO 9h. clasifica_patrones/4
*
*       ENTRADA:
*		F: Fichero con los patrones a clasificar, disponible en Moodle (iris_patrones.csv).
*		G: Fichero con las etiquetas de los patrones a clasificar, disponible en Moodle (iris_etiquetas.csv).
*		K: Numero de vecinos a considerar (valor entero).
*       SALIDA:
*		tasa_aciertos: Tasa de acierto promediada sobre las iteraciones leave-one-out
*
****************/

llenar_matriz([],_):-!.
llenar_matriz([M|N],[S|O]):-
	M=..L,
        L = [_|S],
        llenar_matriz(N,O).

leer_datos(F,G,M_Instancias,L_Etiquetas) :-
    /**Empiezo leyendo instancias y se convierte en una matriz compatible para KNN**/
    csv_read_file(F, Instancias),
    maplist(assertz,Instancias),
    llenar_matriz(Instancias, M_Instancias),
    /**Luego leo etiquetas que las tengo en una sola fila en un CSV y las pongo como lista para KNN**/
    csv_read_file(G,Etiquetas),
    maplist(assertz,Etiquetas),
    Etiquetas=[Sub1|_],
    Sub1=..Sub2,
    Sub2 = [_|L_Etiquetas],
    !.
    
clasifica_patrones(F,G,K,Tasa_aciertos) :- print('Error. Este ejercicio no esta implementado todavia.'), !, fail.
clasifica_iris(K, Tasa_aciertos) :- clasifica_patrones('iris_patrones.csv','iris_etiquetas.csv',K,Tasa_aciertos).
