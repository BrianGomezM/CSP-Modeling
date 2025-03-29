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
% Estas restricciones se pueden deducir de la restricción principal,
% pero ayudan al solver a encontrar la solución más rápidamente
% reduciendo el espacio de búsqueda

% 1. Primera restricción redundante: suma total
% La suma de todos los valores en S debe ser igual a n
% ¿Por qué? Porque cada posición en la secuencia debe contener exactamente un número
constraint sum(i in RANGO)(S[i]) = n;

% 2. Segunda restricción redundante: suma ponderada
% Esta restricción establece una relación entre las posiciones y frecuencias
% Ayuda a podar el árbol de búsqueda eliminando combinaciones imposibles
constraint sum(i in RANGO)((i-1) * S[i]) = 0;

% 3. Restricción de valor máximo
% Ningún número puede aparecer más veces que el tamaño de la secuencia
% Esta es una cota superior natural del problema
constraint forall(i in RANGO)(
    S[i] <= n-1
);

% ============= ESTRATEGIA DE BÚSQUEDA =============
% Usamos la estrategia más básica sin funciones predefinidas
% El solver decidirá la mejor manera de buscar la solución
solve satisfy;

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

