Modelamiento e Implementación de CSPs
Descripción
Este repositorio contiene la solución del Taller 1 de Modelamiento e Implementación de CSPs (Programación por Restricciones), de la Escuela de Ingeniería de Sistemas y Computación.
El objetivo es modelar diferentes problemas como CSP (Constraint Satisfaction Problems), implementarlos en MiniZinc y analizar las estrategias de búsqueda utilizadas.
Contenido
Este repositorio incluye la resolución de los siguientes problemas:
Sudoku (sudoku.mzn): Modelado del Sudoku como un CSP, implementación en MiniZinc con diferentes estrategias de búsqueda y evaluación de su eficiencia.
Kakuro (kakuro.mzn): Modelado del Kakuro como un CSP, especificando variables, dominios y restricciones, con diferentes implementaciones y estrategias de distribución.
Secuencia Mágica (secuencia.mzn): Generación de secuencias mágicas en MiniZinc, con restricciones redundantes para optimizar el árbol de búsqueda.
Acertijo Lógico (acertijo.mzn): Modelado de un problema de lógica en MiniZinc para deducir la relación entre tres amigos, su edad y su música favorita.
Ubicación de Personas en una Reunión (ubicacion.mzn): Cálculo del orden en una fila según restricciones de proximidad, separación y distancia.
Requisitos
Para ejecutar los modelos es necesario contar con:
MiniZinc instalado.
Un entorno de desarrollo compatible con MiniZinc.
Uso
Para ejecutar cada modelo, abrir MiniZinc y cargar el archivo correspondiente. Luego, ejecutar el modelo para ver los resultados.
Ejemplo de ejecución:
minizinc sudoku.mzn
