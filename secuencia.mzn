% Modelamiento e Implementación de CSPs
% Taller 1 - Secuencia Mágica

% DEFINICIÓN DE PARÁMETROS
int: n;  % Tamaño de la secuencia
set of int: RANGO = 0..n-1;  % Rango de valores posibles (0 hasta n-1)

% DEFINICIÓN DE VARIABLES
% S[i] representa cuántas veces aparece el número i en la secuencia
array[RANGO] of var 0..n-1: S;

% RESTRICCIONES PRINCIPALES

% 1. Restricción fundamental de secuencia mágica:
% Para cada número i, el valor en S[i] debe ser igual al número de veces que i aparece en S
% Implementación manual del count:
constraint forall(i in RANGO)(
    % Para cada número i, sumamos 1 por cada posición j donde aparece i
    sum(j in RANGO)(if S[j] = i then 1 else 0 endif) = S[i]
);

% RESTRICCIONES REDUNDANTES
% Estas restricciones son redundantes porque se deducen de la restricción fundamental,
% pero ayudan a reducir significativamente el tamaño del árbol de búsqueda

% 1. Primera restricción redundante: suma de todos los elementos
% x₀ + ... + xₙ₋₁ = n
constraint sum(i in RANGO)(S[i]) = n;

% 2. Segunda restricción redundante: suma ponderada
% (-1)x₀ + ... + (n-2)xₙ₋₁ = 0
constraint sum(i in RANGO)((i-1) * S[i]) = 0;

% 3. Restricción de valor máximo
% Ningún número puede aparecer más veces que el tamaño de la secuencia
constraint forall(i in RANGO)(
    S[i] <= n-1
);

% ESTRATEGIA DE BÚSQUEDA
% Implementación básica sin funciones predefinidas
solve satisfy;

% FORMATO DE SALIDA
output [
    "Secuencia Magica de longitud \(n):\n",
    "[ " ++ 
    concat(i in RANGO)(
        if i < n-1 then 
            show(S[i]) ++ ", "
        else 
            show(S[i])
        endif
    ) ++ 
    " ]\n\n",
    "Verificacion:\n" ++
    concat(i in RANGO)(
        "El numero " ++ show(i) ++ " aparece " ++ 
        show(sum(j in RANGO)(if S[j] = i then 1 else 0 endif)) ++ 
        " veces (S[\(i)] = " ++ show(S[i]) ++ ")\n"
    ) ++
    "\nSuma total de ocurrencias = " ++ show(sum(S)) ++ " (debe ser " ++ show(n) ++ ")\n"
];

