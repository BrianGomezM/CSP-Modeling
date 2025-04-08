include "globals.mzn";

%Variables:
int: n;            
int: W;           
int: H;            
array[1..n] of int: sizes;  

%Variables de decisión
array[1..n] of var int: x;  
array[1..n] of var int: y;  

%Restricciones

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

% 4. Fijar primer cuadrado
constraint x[1] = 0 /\ y[1] = 0;

% Rompimiento de simetrías

% Ordenar posiciones para cuadrados iguales
constraint forall(i in 1..n-1 where sizes[i] == sizes[i+1])(
    x[i] <= x[i+1] /\ (x[i] == x[i+1] -> y[i] <= y[i+1])
);

%Estrategia de búsqueda
array[1..2*n] of var int: posiciones = 
    [x[i] | i in 1..n] ++ [y[i] | i in 1..n];

%Estrategia de búsqueda
solve :: int_search(
    posiciones,
    smallest,
    indomain_split,
    complete
) satisfy;



%Salida
output [
    "Cuadrado " ++ show(i) ++ " (" ++ show(sizes[i]) ++ "x" ++ show(sizes[i]) ++ "): " ++
    "(" ++ show(x[i]) ++ "," ++ show(y[i]) ++ ")-(" ++
    show(x[i]+sizes[i]) ++ "," ++ show(y[i]+sizes[i]) ++ ")\n"
    | i in 1..n
] ++ ["\nRectángulo completado: " ++ show(W) ++ "x" ++ show(H)];
