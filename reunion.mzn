include "alldifferent.mzn";

% ============= PARÁMETROS =============
int: n;
array[1..n] of string: personas;

array[int,1..2] of int: next;
array[int,1..2] of int: separate;
array[int,1..3] of int: distance;

% ============= VARIABLES =============
array[1..n] of var 1..n: posiciones;

% ============= RESTRICCIONES =============
constraint alldifferent(posiciones);

% Personas deben estar juntas (distancia = 1)
constraint forall(i in 1..length(next)) (
    abs(posiciones[next[i,1]] - posiciones[next[i,2]]) = 1
);

% Personas deben estar separadas (distancia > 1)
constraint forall(i in 1..length(separate)) (
    abs(posiciones[separate[i,1]] - posiciones[separate[i,2]]) > 1
);

% Personas con distancia máxima permitida
constraint forall(i in 1..length(distance)) (
    abs(posiciones[distance[i,1]] - posiciones[distance[i,2]]) - 1 <= distance[i,3]
);

% ============= SOLUCIÓN =============
solve :: int_search(posiciones, first_fail, indomain_min) satisfy;

% ============= SALIDA =============
output [
    "[" ++ 
    concat([ if p == 1 then "" else ", " endif ++ 
             personas[fix(posiciones[p])] 
           | p in 1..n ]) ++ 
    "]\n"
];