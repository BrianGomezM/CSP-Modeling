include "globals.mzn";

enum nombres;
enum apellidos;
enum genero_musicales;
set of int: personas = 1..3;

% Parámetros del problema
array[personas] of nombres: nombres_posibles;
array[personas] of apellidos: apellidos_posibles;
array[personas] of genero_musicales: musicas_posibles;
set of int: edades;

% Parámetros para relaciones
nombres: nombre_mayor;
apellidos: apellido_clasico;
nombres: nombre_edad_fija;
int: edad_fija;
apellidos: apellido_excluido;
nombres: nombre_no_jazz;
apellidos: apellido_no_pop;
genero_musicales: musica_clasica;
genero_musicales: musica_pop;
genero_musicales: musica_jazz;

% ----------------------------
% 🔢 Variables de decisión
% ----------------------------
array[personas] of var edades: edad;
array[personas] of var nombres: nombre;
array[personas] of var apellidos: apellido;
array[personas] of var genero_musicales: genero;

% ----------------------------
% 🏗️ Restricciones estructurales (optimizadas)
% ----------------------------
constraint 
    all_different(edad) /\
    all_different([enum2int(nombre[i]) | i in personas]) /\
    all_different([enum2int(apellido[i]) | i in personas]) /\
    all_different([enum2int(genero[i]) | i in personas]);

% ----------------------------
% 📌 Restricciones parametrizadas (mejoradas)
% ----------------------------
% 1. [nombre_mayor] es más viejo que [apellido_clasico] (personas distintas)
constraint 
    exists(p1, p2 in personas where p1 != p2)(
        nombre[p1] = nombre_mayor /\
        apellido[p2] = apellido_clasico /\
        edad[p1] > edad[p2] /\
        genero[p2] = musica_clasica
    );

% 2. Fan de [musica_pop] no tiene edad mínima y no es [apellido_no_pop]
constraint 
    forall(p in personas)(
        (genero[p] = musica_pop) -> 
        (apellido[p] != apellido_no_pop /\ edad[p] != min(edades))
    );

% 3. [nombre_edad_fija] tiene [edad_fija] y no es [apellido_excluido]
constraint 
    edad_fija in edades /\
    exists(p in personas)(
        nombre[p] = nombre_edad_fija /\
        apellido[p] != apellido_excluido /\
        edad[p] = edad_fija
    );

% 4. [nombre_no_jazz] no escucha [musica_jazz]
constraint 
    forall(p in personas)(
        (nombre[p] = nombre_no_jazz) -> (genero[p] != musica_jazz)
    );

% ----------------------------
% 🔥 Restricciones redundantes (eliminadas/modificadas)
% ----------------------------
% Solo mantenemos esta porque agrega información nueva:
constraint 
    forall(p in personas)(
        (nombre[p] = nombre_mayor) -> (edad[p] != min(edades))
    );

% ----------------------------
% ⚖️ Rompimiento de simetrías (alternativo)
% ----------------------------
% Ordenamos por edad para reducir soluciones equivalentes
constraint 
    forall(i in 1..2)(edad[i] <= edad[i+1]);

% ----------------------------
% 🎯 Estrategia de búsqueda optimizada
% ----------------------------
solve :: int_search(
    edad ++ [enum2int(nombre[i]) | i in personas] ++ 
    [enum2int(apellido[i]) | i in personas] ++ 
    [enum2int(genero[i]) | i in personas],
    first_fail,
    indomain_median,
    complete
) satisfy;




% ----------------------------
% 📤 Salida mejorada con debug
% ----------------------------
% ----------------------------
% 📤 Salida mejorada
% ----------------------------
output [
  "Nombre: " ++ show(nombre[i]) ++ ", Apellido: " ++ show(apellido[i]) ++ 
  ", Edad: " ++ show(edad[i]) ++ ", Musica: " ++ show(genero[i]) ++ "\n"
  | i in personas
] ++ ["----------\n"];