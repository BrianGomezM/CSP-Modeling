% Modelamiento e Implementación de CSPs
% Taller 1 - Secuencia Mágica
include "globals.mzn";

% DEFINICIÓN DE PARÁMETROS
int: n;  % Tamaño de la secuencia
set of int: RANGO = 0..n-1;  % Rango de valores posibles (0 hasta n-1)

% DEFINICIÓN DE VARIABLES
% S[i] representa cuántas veces aparece el número i en la secuencia
% El dominio debe ser 0..n-1 porque ningún número puede aparecer más de n-1 veces
array[RANGO] of var 0..n-1: S;

% RESTRICCIONES PRINCIPALES

% 1. Restricción fundamental de secuencia mágica:
% Para cada número i, el valor en S[i] debe ser igual al número de veces que i aparece en S
constraint forall(i in RANGO)(
    count(S, i) = S[i]
);

% RESTRICCIONES REDUNDANTES
% Estas restricciones son redundantes porque se deducen de la restricción fundamental,
% pero ayudan a reducir significativamente el tamaño del árbol de búsqueda

% 1. Primera restricción redundante: suma de todos los elementos
% x₀ + ... + xₙ₋₁ = n
constraint sum(S) = n;

% 2. Segunda restricción redundante: suma ponderada
% (-1)x₀ + ... + (n-2)xₙ₋₁ = 0
constraint sum(i in RANGO) ((i-1) * S[i]) = 0;

% 3. Restricción de valor máximo
% Ningún número puede aparecer más veces que el tamaño de la secuencia
constraint forall(i in RANGO)(
    S[i] <= n-1
);

% ESTRATEGIA DE BÚSQUEDA
% Usamos una estrategia híbrida dependiendo del tamaño de n
solve :: 
    if n <= 4 then
        % Para casos pequeños, usamos una estrategia simple
        int_search(S, input_order, indomain_min)
    else
        % Para casos más grandes, usamos first_fail
        int_search(S, first_fail, indomain_min)
    endif
satisfy;

% FORMATO DE SALIDA
output [
    "Secuencia Magica de longitud \(n):\n",
    "[ " ++ 
    concat(i in RANGO) (
        if i < n-1 then 
            show(S[i]) ++ ", "
        else 
            show(S[i])
        endif
    ) ++ 
    " ]\n\n",
    "Verificacion:\n" ++
    concat(i in RANGO) (
        "El numero " ++ show(i) ++ " aparece " ++ show(count(S, i)) ++ 
        " veces (S[\(i)] = " ++ show(S[i]) ++ ")\n"
    ) ++
    "\nSuma total de ocurrencias = " ++ show(sum(S)) ++ " (debe ser " ++ show(n) ++ ")\n"
];

