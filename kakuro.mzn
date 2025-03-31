include "globals.mzn";
include "kakuro.dzn";
% ========================
% 📥 Parámetros de entrada
% ========================
int: filas;
int: columnas;

enum TipoCelda = {NEGRA, BLANCA, SUMA_H, SUMA_V};

% Estructura del tablero
array[1..filas, 1..columnas] of TipoCelda: tipo_celda;

% Valores de las pistas
array[1..filas, 1..columnas] of int: pistas;

% ========================
% 🔢 Variables de decisión
% ========================
array[1..filas, 1..columnas] of var 0..9: tablero;

% ========================
% 🔍 Funciones auxiliares
% ========================
function array[int] of var int: segmento_horizontal(int: fila, int: col) =
    let {
        int: inicio = min([c | c in col..columnas where tipo_celda[fila,c] == BLANCA]),
        int: fin = max([c | c in inicio..columnas where tipo_celda[fila,c] == BLANCA])
    } in [tablero[fila,k] | k in inicio..fin];

function array[int] of var int: segmento_vertical(int: fila, int: col) =
    let {
        int: inicio = min([f | f in fila..filas where tipo_celda[f,col] == BLANCA]),
        int: fin = max([f | f in inicio..filas where tipo_celda[f,col] == BLANCA])
    } in [tablero[k,col] | k in inicio..fin];

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

% 2. Restricciones para sumas horizontales
constraint forall(i in 1..filas)(
    forall(j in 1..columnas where tipo_celda[i,j] == SUMA_H)(
        let {
            array[int] of var int: seg = segmento_horizontal(i,j+1)
        } in
        sum(seg) == pistas[i,j] /\ 
        alldifferent(seg)
    )
);

% 3. Restricciones para sumas verticales
constraint forall(j in 1..columnas)(
    forall(i in 1..filas where tipo_celda[i,j] == SUMA_V)(
        let {
            array[int] of var int: seg = segmento_vertical(i+1,j)
        } in
        sum(seg) == pistas[i,j] /\ 
        alldifferent(seg)
    )
);

% ========================
% 🔄 Restricciones redundantes
% ========================
% Verificar que todas las celdas blancas están en algún segmento
constraint forall(i in 1..filas, j in 1..columnas where tipo_celda[i,j] == BLANCA)(
    exists(h in 1..j-1)(tipo_celda[i,h] == SUMA_H) \/
    exists(v in 1..i-1)(tipo_celda[v,j] == SUMA_V)
);

% ========================
% 🎯 Estrategia de búsqueda
% ========================
solve :: int_search(
    [tablero[i,j] | i in 1..filas, j in 1..columnas where tipo_celda[i,j] == BLANCA],
    input_order,
    indomain_min,
    complete
) satisfy;

% ========================
% 📤 Formato de salida simplificado
% ========================
output [
    if j == 1 then "\n" else "" endif ++
    if tipo_celda[i,j] == NEGRA then "X\t"
    elseif tipo_celda[i,j] == SUMA_H then show(pistas[i,j]) ++ "H\t"
    elseif tipo_celda[i,j] == SUMA_V then show(pistas[i,j]) ++ "V\t"
    else show(tablero[i,j]) ++ "\t"
    endif 
    | i in 1..filas, j in 1..columnas
];