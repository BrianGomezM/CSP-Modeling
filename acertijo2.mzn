include "globals.mzn"; % Importamos las restricciones globales

% ----------------------------
% 📥 Parámetros de entrada
% ----------------------------
% Definimos los posibles valores para nombres, apellidos y géneros musicales.
enum Nombre = {Juan, Oscar, Dario};
enum Apellido = {Lopez, Garcia, Gonzalez};
enum Musica = {Clasica, Pop, Jazz};

set of int: Personas = 1..3; % Conjunto de personas (índices)

% ----------------------------
% 🔢 Variables de decisión
% ----------------------------
array[Personas] of var 24..26: edad;      % Edad de cada persona (valores enteros entre 24 y 26)
array[Personas] of var Nombre: nombre;   % Nombre de cada persona
array[Personas] of var Apellido: apellido; % Apellido de cada persona
array[Personas] of var Musica: genero;   % Género musical preferido de cada persona

% ----------------------------
% 🔍 Restricciones de unicidad
% ----------------------------
% Cada persona debe tener un nombre, un apellido, una edad y un género musical único.
constraint all_different(nombre);
constraint all_different(apellido);
constraint all_different(genero);
constraint all_different(edad);

% ----------------------------
% 📌 Restricciones lineales y enteras
% ----------------------------
% 1. Juan es más viejo que González, quien escucha música clásica.
constraint
    forall(i in Personas, j in Personas) (
        if nombre[i] == Juan /\ apellido[j] == Gonzalez then edad[i] > edad[j] endif
    ) /\
    forall(j in Personas) (if apellido[j] == Gonzalez then genero[j] == Clasica endif);

% 2. El fan de la música pop, que no es García, no tiene 24 años.
constraint
    forall(i in Personas) (
        if genero[i] == Pop then apellido[i] != Garcia /\ edad[i] != 24 endif
    );

% 3. Oscar, quien no es López, tiene 25 años.
constraint
    forall(i in Personas) (
        if nombre[i] == Oscar then apellido[i] != Lopez /\ edad[i] == 25 endif
    );

% 4. La música favorita de Darío no es el jazz.
constraint
    forall(i in Personas) (
        if nombre[i] == Dario then genero[i] != Jazz endif
    );
      

% ----------------------------
% 🔄 Restricciones redundantes (para mejorar eficiencia)
% ----------------------------
% Si González tiene música clásica, no puede ser el que escucha pop o jazz.
constraint
    forall(i in Personas) (
        if apellido[i] == Gonzalez then genero[i] = Clasica endif
    );

% ----------------------------
% 🔗 Restricciones de simetría
% ----------------------------
% Fijamos a Juan en la primera posición para reducir el espacio de búsqueda.
constraint nombre[1] = Juan;

% ----------------------------
% 🎯 Función objetivo
% ----------------------------
% Este es un problema de satisfacción de restricciones (CSP), por lo que solo buscamos cumplir las restricciones.
solve satisfy;

% ----------------------------
% 📤 Formato de salida
% ----------------------------
output [
  "Nombre: " ++ show(nombre[i]) ++ ", Apellido: " ++ show(apellido[i]) ++ 
  ", Edad: " ++ show(edad[i]) ++ ", Música: " ++ show(genero[i]) ++ "\n"
  | i in Personas
];
