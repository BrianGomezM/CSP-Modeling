% Modelamiento e Implementación de CSPs
% Taller 1 - Sudoku
include "globals.mzn";

% Parámetros básicos del Sudoku
int: tamano_subcuadricula=3;  % cada subcuadrícula es 3x3
int: tamano_tablero = tamano_subcuadricula * tamano_subcuadricula;  % tablero 9x9

% Definición de rangos para las restricciones
set of int: rango_valores = 1..tamano_tablero;  % números del 1 al 9
set of int: rango_subcuadricula = 1..tamano_subcuadricula;  % para recorrer las subcuadrículas

% Matrices del Sudoku
array[1..tamano_tablero, 1..tamano_tablero] of 0..tamano_tablero: valores_iniciales; % números que ya están puestos
array[1..tamano_tablero, 1..tamano_tablero] of var rango_valores: solucion; % lo que vamos a resolver

% RESTRICCIONES DEL SUDOKU

% 1. Mantener los valores iniciales dados
% si hay un número en la posición inicial (>0), debe mantenerse en la solución
constraint forall(i,j in rango_valores)(
    if valores_iniciales[i,j] > 0 then 
        solucion[i,j] = valores_iniciales[i,j] 
    else 
        true 
    endif
);

% 2. Restricción de filas únicas
% cada fila debe tener números del 1 al 9 sin repetir
constraint forall(fila in rango_valores)(
    alldifferent([solucion[fila,columna] | columna in rango_valores])
);

% 3. Restricción de columnas únicas
% cada columna debe tener números del 1 al 9 sin repetir
constraint forall(columna in rango_valores)(
    alldifferent([solucion[fila,columna] | fila in rango_valores])
);

% 4. Restricción de subcuadrículas 3x3
% cada subcuadrícula debe tener números del 1 al 9 sin repetir
constraint forall(bloque_fila, bloque_columna in rango_subcuadricula)(
    alldifferent([
        solucion[
            (bloque_fila-1)*tamano_subcuadricula + i, 
            (bloque_columna-1)*tamano_subcuadricula + j
        ] 
        | i,j in 1..tamano_subcuadricula
    ])
);

% RESTRICCIONES REDUNDANTES
% 1. La suma de cada fila debe ser 45 (1+2+...+9)
constraint forall(fila in rango_valores)(
    sum([solucion[fila,columna] | columna in rango_valores]) = 45
);

% 2. La suma de cada columna debe ser 45 (1+2+...+9)
constraint forall(columna in rango_valores)(
    sum([solucion[fila,columna] | fila in rango_valores]) = 45
);

% 3. La suma de cada subcuadrícula debe ser 45 (1+2+...+9)
constraint forall(bloque_fila, bloque_columna in rango_subcuadricula)(
    sum([
        solucion[
            (bloque_fila-1)*tamano_subcuadricula + i, 
            (bloque_columna-1)*tamano_subcuadricula + j
        ] 
        | i,j in 1..tamano_subcuadricula
    ]) = 45
);

solve satisfy;
% solve :: int_search(
%    [solucion[i,j] | i,j in rango_valores],
%    first_fail,
%    indomain_min
% ) satisfy;
% solve :: int_search(
%    [solucion[i,j] | i,j in rango_valores],
%    input_order,
%    indomain_min
% ) satisfy;
% solve :: int_search(
%    [solucion[i,j] | i,j in rango_valores],
%    smallest,
%    indomain_median
% ) satisfy;


% Formato de salida para visualizar la solución
output [
    if i = 1 /\ j = 1 then " -----------------------\n" else "" endif ++
    if j = 1 then "| " else "" endif ++
    show(solucion[i,j]) ++ " " ++
    if j mod 3 = 0 /\ j < 9 then "| " else "" endif ++
    if j = 9 then 
        if i mod 3 = 0 /\ i < 9 then "|\n -----------------------\n" 
        else "|\n" endif
    else "" endif
    | i,j in rango_valores
] ++ [" -----------------------"];