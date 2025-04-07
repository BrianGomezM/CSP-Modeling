include "globals.mzn";
include "kakuro_prueba_6.dzn";

% ========================
% 📥 Parámetros de entrada (se cargarán desde .dzn)
% ========================
int: filas;
int: columnas;

enum TipoCelda = {NEGRA, BLANCA, SUMA_H, SUMA_V, SUMA_HV};

% Estructuras del tablero (definidas en .dzn)
array[1..filas, 1..columnas] of TipoCelda: tipo_celda;
array[1..filas, 1..columnas] of int: pistas_h;  % Sumas horizontales
array[1..filas, 1..columnas] of int: pistas_v;  % Sumas verticales

% ========================
% 🔢 Variables de decisión
% ========================
array[1..filas, 1..columnas] of var 0..9: tablero;

% ========================
% 🔍 Funciones auxiliares mejoradas
% ========================
function array[int] of var int: segmento_horizontal(int: fila, int: col) =
    let {
        int: fin = min([c | c in col..columnas where tipo_celda[fila,c] != BLANCA] ++ [columnas+1])
    } in [tablero[fila,k] | k in col..fin-1 where tipo_celda[fila,k] == BLANCA];

function array[int] of var int: segmento_vertical(int: fila, int: col) =
    let {
        int: fin = min([f | f in fila..filas where tipo_celda[f,col] != BLANCA] ++ [filas+1])
    } in [tablero[k,col] | k in fila..fin-1 where tipo_celda[k,col] == BLANCA];

% ========================
% 🔗 Restricciones principales
% ========================
% 1. Valores válidos en celdas
constraint forall(i in 1..filas, j in 1..columnas)(
    if tipo_celda[i,j] == BLANCA then 
        tablero[i,j] >= 1 /\ tablero[i,j] <= 9 
    else 
        tablero[i,j] == 0 
    endif
);

% Para segmentos de longitud N, la suma mínima es T(N) = N*(N+1)/2
% y la suma máxima es 45 - T(9-N)



% 2. Restricciones para sumas horizontales
constraint forall(i in 1..filas, j in 1..columnas where tipo_celda[i,j] == SUMA_H \/ tipo_celda[i,j] == SUMA_HV)(
    let {
        array[int] of var int: seg = segmento_horizontal(i,j+1),
        int: suma = pistas_h[i,j]
    } in
    if length(seg) > 0 then
        sum(seg) == suma /\
        alldifferent(seg)
    else true endif
);

% 3. Restricciones para sumas verticales
constraint forall(i in 1..filas, j in 1..columnas where tipo_celda[i,j] == SUMA_V \/ tipo_celda[i,j] == SUMA_HV)(
    let {
        array[int] of var int: seg = segmento_vertical(i+1,j),
        int: suma = pistas_v[i,j]
    } in
    if length(seg) > 0 then
        sum(seg) == suma /\
        alldifferent(seg)
    else true endif
);

% 4. Restricción adicional para celdas SUMA_HV
constraint forall(i in 1..filas, j in 1..columnas where tipo_celda[i,j] == SUMA_HV)(
    pistas_h[i,j] != 0 /\ pistas_v[i,j] != 0
);



% ========================
% 🎯 Estrategia de búsqueda mejorada
% ========================
solve :: int_search(
    [tablero[i,j] | i in 1..filas, j in 1..columnas where tipo_celda[i,j] == BLANCA]
   ,smallest, indomain_split, complete) satisfy;

% ========================
% 📤 Formato de salida mejorado
% ========================
output [
    if j == 1 then "\n" else "" endif ++
    if tipo_celda[i,j] == NEGRA then "X\t"
    elseif tipo_celda[i,j] == SUMA_H then show(pistas_h[i,j]) ++ "H\t"
    elseif tipo_celda[i,j] == SUMA_V then show(pistas_v[i,j]) ++ "V\t"
    elseif tipo_celda[i,j] == SUMA_HV then show(pistas_h[i,j]) ++ "H/" ++ show(pistas_v[i,j]) ++ "V\t"
    else show(tablero[i,j]) ++ "\t"
    endif 
    | i in 1..filas, j in 1..columnas
];