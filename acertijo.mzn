include "globals.mzn";

% ----------------------------
% 📊 Enumeraciones y conjuntos
% ----------------------------
enum NOMBRE = {Juan, Oscar, Dario};
enum APELLIDO = {Lopez, Garcia, Gonzalez};
enum MUSICA = {Clasica, Pop, Jazz};
set of int: PERSONAS = 1..3;

% ----------------------------
% 🔢 Variables de decisión
% ----------------------------
array[PERSONAS] of var NOMBRE: nombre;
array[PERSONAS] of var APELLIDO: apellido;
array[PERSONAS] of var 24..26: edad;
array[PERSONAS] of var MUSICA: genero;

% ----------------------------
% 🔍 Restricciones principales
% ----------------------------
% Unicidad de atributos
constraint all_different(nombre) /\ all_different(apellido) 
         /\ all_different(edad) /\ all_different(genero);

% 1. Juan > González en edad, y González ama clásica
constraint exists(i in PERSONAS, j in PERSONAS)(
    nombre[i] == Juan /\ apellido[j] == Gonzalez /\
    edad[i] > edad[j] /\ genero[j] == Clasica
);

% 2. Pop lover: no García y no 24 años
constraint forall(i in PERSONAS)(
    genero[i] == Pop -> (apellido[i] != Garcia /\ edad[i] != 24)
);

% 3. Oscar: no López y tiene 25 años
constraint exists(i in PERSONAS)(
    nombre[i] == Oscar /\ apellido[i] != Lopez /\ edad[i] == 25
);

% 4. Darío no escucha jazz
constraint forall(i in PERSONAS)(
    nombre[i] == Dario -> genero[i] != Jazz
);

% ----------------------------
% 🚀 Optimizaciones
% ----------------------------
% Restricción redundante: González solo puede escuchar clásica
constraint forall(i in PERSONAS)(
    apellido[i] == Gonzalez -> genero[i] == Clasica
);

% Fijar variables para romper simetrías
constraint nombre[1] == Juan;  % Juan siempre en primera posición
constraint edad[1] == 26;      % Juan es el mayor (por la restricción 1)

% ----------------------------
% 🔎 Estrategia de búsqueda simplificada
% ----------------------------
% Usamos solo las variables de edad para la búsqueda (puedes cambiarlo)
solve :: int_search(edad, input_order, indomain_min, complete)
satisfy;

% ----------------------------
% 📝 Salida formateada
% ----------------------------
output [
    "Persona " ++ show(i) ++ ":\n" ++
    "  Nombre:   " ++ show(nombre[i]) ++ "\n" ++
    "  Apellido: " ++ show(apellido[i]) ++ "\n" ++
    "  Edad:     " ++ show(edad[i]) ++ "\n" ++
    "  Música:   " ++ show(genero[i]) ++ "\n"
    | i in PERSONAS
];