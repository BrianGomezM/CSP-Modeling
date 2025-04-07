include "alldifferent.mzn";

% Modelamiento e Implementación de CSPs
% Taller 1 - Ubicación de personas en una reunión

% ============= PARÁMETROS =============
int: n;  % Número de personas
array[1..n] of string: nombres;  % Nombres de las personas

% Arrays para las restricciones
% next: pares de personas que deben estar juntas
int: num_next;  % Número de restricciones next
array[1..num_next, 1..2] of 1..n: next;  % Pares de índices de personas

% separate: pares de personas que deben estar separadas
int: num_separate;  % Número de restricciones separate
array[1..num_separate, 1..2] of 1..n: separate;  % Pares de índices de personas

% distance: personas que deben estar separadas por una distancia máxima
int: num_distance;  % Número de restricciones distance
array[1..num_distance, 1..3] of int: distance;  % [persona1, persona2, distancia_maxima]

% ============= VARIABLES =============
% posiciones[i] = p significa que la persona i está en la posición p
array[1..n] of var 1..n: posiciones;

% ============= RESTRICCIONES =============

% 1. Todas las posiciones deben ser diferentes
constraint alldifferent(posiciones);

% 2. Restricciones next: personas que deben estar juntas
constraint forall(i in 1..num_next)(
    abs(posiciones[next[i,1]] - posiciones[next[i,2]]) = 1
);

% 3. Restricciones separate: personas que deben estar separadas
constraint forall(i in 1..num_separate)(
    abs(posiciones[separate[i,1]] - posiciones[separate[i,2]]) > 1
);

% 4. Restricciones distance: personas con distancia máxima
constraint forall(i in 1..num_distance)(
    abs(posiciones[distance[i,1]] - posiciones[distance[i,2]]) <= distance[i,3]
);

% ============= BÚSQUEDA =============
solve :: int_search(posiciones, first_fail, indomain_min) satisfy;

% ============= SALIDA =============
output [
    "Orden en la fila:\n",
    "[ " ++
    concat(p in 1..n)(
        if p > 1 then ", " else "" endif ++
        nombres[sum(i in 1..n)(i * (posiciones[i] = p))]
    ) ++
    " ]\n"
]; 