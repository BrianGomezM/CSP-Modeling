include "alldifferent.mzn";

% ============= PARÁMETROS =============
int: n;  % número de personas
array[1..n] of string: personas;

int: num_next;
array[1..num_next, 1..2] of int: next;

int: num_separate;
array[1..num_separate, 1..2] of int: separate;

int: num_distance;
array[1..num_distance, 1..3] of int: distance;

  % ============= VARIABLES =============
array[1..n] of var 1..n: posiciones;

% ============= RESTRICCIONES =============
constraint alldifferent(posiciones);

% Restricción de personas que deben estar juntas
constraint forall(i in 1..num_next)(
    abs(posiciones[next[i,1]] - posiciones[next[i,2]]) = 1
);

% Restricción de personas que deben estar separadas
constraint forall(i in 1..num_separate)(
    abs(posiciones[separate[i,1]] - posiciones[separate[i,2]]) > 1
);

% Restricción de distancia máxima entre personas
constraint forall(i in 1..num_distance)(
    abs(posiciones[distance[i,1]] - posiciones[distance[i,2]]) - 1 <= distance[i,3]
);

%Restricciones redundante (ejemplo: si A y B deben estar juntos, su rango está limitado)
constraint forall(i in 1..num_next)(
    posiciones[next[i,1]] >= 1 /\ posiciones[next[i,1]] <= n - 1 /\
    posiciones[next[i,2]] >= 2 /\ posiciones[next[i,2]] <= n
);

% ============= SOLUCIÓN =============
solve :: int_search(posiciones, first_fail, indomain_min) satisfy;

% ============= SALIDA =============
output [
    "[" ++
    concat([
        if i > 1 then ", " else "" endif ++
        personas[j]
        | i in 1..n, j in 1..n where fix(posiciones[j]) == i
    ]) ++
    "]\n"
];