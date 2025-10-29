# Tema 2 — Procedimientos y funciones almacenadas
El uso de procedimientos almacenados es esecial para desarrollar, administrar y manipular eficientemente datos dentro de una base de datos. Nos permite automatizar y simplificar operaciones recurrentes y complejas, optimizando el rendimiento del sistema y mejorando la capacidad de mantenimiento de las interacciones con la base de datos.

### Procedimientos
Los procedimientos almacenados son conjuntos de instrucciones que se ejecutan en el servidor y pueden realizar tareas variadas, como modificar o eliminar datos.

Un procedimiento se declara con `CREATE PROCEDURE` seguido del nombre del procedimiento, este permite invocar el procedimiento en otros contextos. 
- Pueden tener parámetros de entrada y salida (`IN` y `OUT`), permitiendo enviar valores hacia y desde el procedimiento.
- En el cuerpo, los procedimientos pueden ejecutar una amplia gama de operaciones, incluidas consultas de modificación de datos (`INSERT`, `UPDATE`, `DELETE`).
- Generalmente, la devolucion de valores se hace a través de parámetros de salida y no con una instrucción RETURN como en las funciones. Los procedimientos no tienen un tipo de retorno fijo.
- Los procedimientos pueden contener estructuras de control como `IF`, `WHILE` y `TRYCATCH`.

### Funciones
A diferencia de los procedimientos, las funciones almacenadas están diseñadas principalmente para realizar cálculos o retornar un solo valor. Estas se pueden utilizar dentro de sentencias SQL.

Una función se declara con `CREATE FUNCTION` seguido de un nombre único, este permite invocar a la función desde otras partes del sistema o dentro de consultas.
- Pueden recibir parámetros de entrada, los cuales permiten realizar operaciones en base a los valores proporcionados. Los `parámetros` se declaran junto con su `tipo de dato`.
- Debe definir el tipo de dato que devolverá. Toda función DEBE `retornar` un valor.
- El cuerpo contiene las instrucciones que se ejecutarán cuando se invoque la función. Se pueden incluir operaciones de cálculo, manipulación de cadenas, acceso a tablas, etc.
- Deben devolver un valor mediante la instrucción `RETURN`.
- Las funciones suelen estar más limitadas que los procedimientos. Por ejemplo, no pueden modificar los datos de las tablas y están diseñadas para ser utilizadas en consultas (`SELECT`), lo que les permite retornar valores específicos que pueden integrarse en otras operaciones SQL.

Los procedimientos y funciones almacenadas son herramientas clave para implementar operaciones CRUD de manera segura y controlada. Su implementación permite definir reglas y automatizar procesos a la hora de manipular datos, manteniendo un mejor control sobre la integridad de los mismos.

# Desarrollo del TEMA 2

Tareas: 
Realizar al menos tres procedimientos almacenados que permitan: Insertar, Modificar y borrar registros de alguna de las tablas del proyecto.

Insertar un lote de datos en las tablas mencionadas (guardar el script) con sentencias insert y otro lote invocando a los procedimientos creados.

Realizar  update y delete sobre  algunos de los registros insertados  en esas tablas invocando a los procedimientos. 

Desarrollar al menos tres funciones almacenadas. Por ej: calcular la edad, 

Comparar la eficiencia de las operaciones directas versus el uso de procedimientos y funciones

# Conclusión
Los procedimientos y funciones en SQL resultan útiles para modularizar y optimizar tareas, reduce el código repetido, mejora la legibilidad y facilita el mantenimiento del codigo y la base de datos. Con esto no solo minimizamos las llamadas necesarias, también garantizamos una mayor consistencia en las transacciones.

Aunque las consultas directas pueden ser prácticas y rápidas para tareas puntuales, los procedimientos y funciones almacenadas son una buena practica en aplicaciones de alta carga o donde la eficiencia, el control del estado y uso de los datos, y la modularidad sean prioridad.

