% Modelamiento e Implementación de CSPs
% Taller 1 - Secuencia Mágica
% Este problema consiste en encontrar una secuencia de n números donde cada número i
% aparece exactamente S[i] veces en la secuencia.

% ============= DEFINICIÓN DE PARÁMETROS =============
int: n;  % Tamaño de la secuencia (se lee del archivo .dzn)
set of int: RANGO = 0..n-1;  % Define el rango de valores posibles en la secuencia
                            % Va de 0 a n-1 porque los números en la secuencia
                            % deben estar en este rango

% ============= DEFINICIÓN DE VARIABLES =============
% S[i] es un array donde cada posición i contiene cuántas veces aparece el número i
% Por ejemplo, si S[2] = 3, significa que el número 2 aparece 3 veces en la secuencia
% El dominio es 0..n-1 porque ningún número puede aparecer más veces que el tamaño de la secuencia
array[RANGO] of var 0..n-1: S;

% ============= RESTRICCIONES PRINCIPALES =============

% 1. Restricción fundamental de la secuencia mágica:
% Esta es la restricción que define qué es una secuencia mágica
% Para cada número i, contamos cuántas veces aparece en la secuencia (S[j] = i)
% y este conteo debe ser igual al valor almacenado en S[i]
constraint forall(i in RANGO)(
    % Implementación manual del conteo:
    % - Recorremos cada posición j en la secuencia
    % - Si S[j] = i, sumamos 1; si no, sumamos 0
    % - La suma total debe ser igual a S[i]
    sum(j in RANGO)(if S[j] = i then 1 else 0 endif) = S[i]
);

% ============= RESTRICCIONES REDUNDANTES =============
% Las siguientes dos restricciones son redundantes porque se pueden deducir
% de la restricción principal. Sin embargo, son muy útiles porque reducen
% considerablemente el tamaño del árbol de búsqueda:

% 1. Primera restricción redundante: x₀ + ... + xₙ₋₁ = n
% Esta restricción es redundante porque:
% - De la restricción principal sabemos que cada posición debe tener exactamente un número
% - Por lo tanto, la suma de todas las apariciones debe ser igual a n
% - Sin embargo, tenerla explícitamente ayuda al solver a podar ramas inválidas más rápido
constraint sum(i in RANGO)(S[i]) = n;

% 2. Segunda restricción redundante: (-1)x₀ + ... + (n-2)xₙ₋₁ = 0
% Esta restricción es redundante porque:
% - Se deduce de la propiedad fundamental de la secuencia mágica
% - Si cada número i aparece S[i] veces, esta suma ponderada debe ser 0
% - Ayuda al solver a identificar y eliminar combinaciones imposibles temprano
% - Reduce significativamente el espacio de búsqueda
constraint sum(i in RANGO)((i-1) * S[i]) = 0;

% 3. Restricción de valor máximo
% Ningún número puede aparecer más veces que el tamaño de la secuencia menos 1
constraint forall(i in RANGO)(
    S[i] <= n-1
);

% ============= ESTRATEGIA DE BÚSQUEDA =============
solve :: int_search(S, first_fail, indomain_min) satisfy;

% ============= FORMATO DE SALIDA =============
% Mostramos la solución en un formato legible y verificable
output [
    % 1. Mostrar la secuencia completa
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
    
    % 2. Verificación detallada de cada número
    "Verificacion:\n" ++
    concat(i in RANGO)(
        "El numero " ++ show(i) ++ " aparece " ++ 
        % Calculamos manualmente cuántas veces aparece cada número
        show(sum(j in RANGO)(if S[j] = i then 1 else 0 endif)) ++ 
        " veces (S[\(i)] = " ++ show(S[i]) ++ ")\n"
    ) ++
    
    % 3. Verificación de la suma total
    "\nSuma total de ocurrencias = " ++ show(sum(S)) ++ " (debe ser " ++ show(n) ++ ")\n"
];

