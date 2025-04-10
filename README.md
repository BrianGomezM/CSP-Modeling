Taller1-PPR-2024/
│
├── README.txt
├── Taller 1.pdf
├── modelos/
│   ├── sudoku.mzn
│   ├── kakuro.mzn
│   ├── secuencia.mzn
│   ├── acertijo.mzn
│   ├── reunion.mzn
│   └── rectangulo.mzn
├── datos_prueba/
│   ├── sudoku/
│   │   ├── sudoku_prueba1.dzn
│   │   └── sudoku_prueba2.dzn
│   ├── kakuro/
│   │   ├── kakuro_prueba_1.dzn
│   │   └── kakuro_prueba_2.dzn
│   │   ├── kakuro_prueba_3.dzn
│   │   └── kakuro_prueba_4.dzn
│   │   ├── kakuro_prueba_5.dzn
│   │   └── kakuro_prueba_6.dzn
│   ├── secuencia/
│   │   ├── rectangulo_prueba1.dzn
│   │   ├── rectangulo_prueba2.dzn
│   │   └── rectangulo_prueba6.dzn
│   ├── acertijo/
│   │   ├── acertijo_prueba_1.dzn
│   │   ├── acertijo_prueba_2.dzn
│   │   └── acertijo_prueba_3.dzn
│   │   ├── acertijo_prueba_4.dzn
│   │   ├── acertijo_prueba_5.dzn
│   │   └── acertijo_prueba_6.dzn
│   ├── reunion/
│   │   ├── rectangulo_prueba1.dzn
│   │   ├── rectangulo_prueba2.dzn
│   │   └── rectangulo_prueba6.dzn
│   ├── rectangulo/
│   │   ├── rectangulo_prueba_1.dzn
│   │   ├── rectangulo_prueba_2.dzn
│   │   └── rectangulo_prueba_3.dzn
│   │   ├── rectangulo_prueba_4.dzn
│   │   ├── rectangulo_prueba_5.dzn
│   │   └── rectangulo_prueba_6.dzn
└── resultados/
    ├── estadisticas_sudoku.csv
    ├── estadisticas_kakuro.csv


Taller 1 - Programación por Restricciones (2024)

## Integrantes:
- Brayan Gómez Muñoz - 2310016
- Juan José Moreno Jaramillo - 2310038

## Descripción:
Implementación en MiniZinc de los problemas CSP propuestos:
1. Sudoku
2. Kakuro
3. Secuencia Mágica
4. Acertijo Lógico
5. Reunión de Personas
6. Construcción de Rectángulo


### Requisitos:
- MiniZinc 2.7.4 o superior
- Solvers compatibles: Gecode, CP-SAT, Chuffed, HiGHS, etc.

### Ejecución general:
Para cada problema, ejecutar desde la raíz del proyecto:
```bash
minizinc --solver <SOLVER> --statistics modelos/<problema>.mzn datos_prueba/<problema>/<prueba>.dzn

### Recomendaciones adicionales:
1. **Para el informe PDF:**
   - Se incluye capturas de las ejecuciones con estadísticas.
   - Ejemplo de tabla para comparar solvers:

   | Solver  | Tiempo (ms) | Fallos | Nodos | Problema       |
   |---------|-------------|--------|-------|----------------|
   | Gecode  | 197         | 2      | 9     | rectangulo_p2  |
   | CP-SAT  | 327         | 0      | -     | rectangulo_p2  |

https://drive.google.com/drive/folders/1U7z_MOCHUuSicydULrCFfWpwEjIOEC3m?usp=drive_link
