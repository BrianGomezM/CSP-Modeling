include "globals.mzn";
include "rectangulo.dzn";

% =========================
% 📥 Parámetros de entrada
% =========================
int: n;            % Número de cuadrados
int: W;            % Ancho del rectángulo
int: H;            % Alto del rectángulo
array[1..n] of int: sizes;  % Lados de los cuadrados

% =========================
% 🔢 Variables de decisión (CORREGIDO)
% =========================
array[1..n] of var int: x;  % Coordenada X (dominio se define en restricciones)
array[1..n] of var int: y;  % Coordenada Y (dominio se define en restricciones)

% =========================
% 🔍 Restricciones principales
% =========================
% 1. Definir dominios y que los cuadrados quepan
constraint forall(i in 1..n) (
    x[i] >= 0 /\ x[i] <= W - sizes[i] /\
    y[i] >= 0 /\ y[i] <= H - sizes[i]
);

% 2. No solapamiento
constraint forall(i, j in 1..n where i < j) (
    (x[i] + sizes[i] <= x[j]) \/ 
    (x[j] + sizes[j] <= x[i]) \/ 
    (y[i] + sizes[i] <= y[j]) \/ 
    (y[j] + sizes[j] <= y[i])
);

% 3. Área total
constraint sum([sizes[i]*sizes[i] | i in 1..n]) = W*H;

% =========================
% 🔄 Optimizaciones
% =========================
% Fijar primer cuadrado
constraint x[1] = 0 /\ y[1] = 0;

% Ordenar cuadrados por tamaño descendente
constraint forall(i in 1..n-1)(sizes[i] >= sizes[i+1]);

% =========================
% 🔗 Romper simetrías
% =========================
% Ordenar posiciones para cuadrados iguales
constraint forall(i in 1..n-1 where sizes[i] == sizes[i+1])(
    x[i] <= x[i+1] /\ (x[i] == x[i+1] -> y[i] <= y[i+1])
);

% =========================
% 🎯 Estrategia de búsqueda
% =========================
array[1..2*n] of var int: posiciones = 
    [x[i] | i in 1..n] ++ [y[i] | i in 1..n];

solve :: int_search(
    posiciones,
    input_order,
    indomain_min,
    complete
) satisfy;

% =========================
% 📤 Salida corregida
% =========================
output [
    "Cuadrado " ++ show(i) ++ " (" ++ show(sizes[i]) ++ "x" ++ show(sizes[i]) ++ "): " ++
    "(" ++ show(x[i]) ++ "," ++ show(y[i]) ++ ")-(" ++
    show(x[i]+sizes[i]) ++ "," ++ show(y[i]+sizes[i]) ++ ")\n"
    | i in 1..n
] ++ ["\nRectángulo completado: " ++ show(W) ++ "x" ++ show(H)];