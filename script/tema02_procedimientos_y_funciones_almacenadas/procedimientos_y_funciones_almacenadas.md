# Tema 2 — Procedimientos y funciones almacenadas



## Procedimiento

Un procedimiento almacenado (stored procedure en inglés) es un programa (o procedimiento) almacenado físicamente en una base de datos. Su implementación varía de un gestor de bases de datos a otro. La ventaja 
de un procedimiento almacenado es que al ser ejecutado, en respuesta a una petición de usuario, es ejecutado directamente en el motor de bases de datos, el cual usualmente corre en un servidor separado. Como 
tal, posee acceso directo a los datos que necesita manipular y sólo necesita enviar sus resultados de regreso al usuario, deshaciéndose de la sobrecarga resultante de comunicar grandes cantidades de datos salientes 
y entrantes. 

 ## Ventajas de usar procedimientos almacenados

### Tráfico de red reducido entre el cliente y el servidor

 Los comandos de un procedimiento se ejecutan en un único lote de código. Esto puede
reducir significativamente el tráfico de red entre el servidor y el cliente porque
únicamente se envía a través de la red la llamada que va a ejecutar el procedimiento.

### Mayor seguridad

Los usuarios y aplicaciones pueden operar sobre los objetos de la base a través del procedimiento sin tener permisos directos. El procedimiento controla las operaciones y protege los objetos, evitando otorgar 
permisos en cada nivel y simplificando la seguridad.


### Reutilización del código

Las operaciones repetitivas pueden encapsularse en procedimientos, evitando escribir el mismo código, reduciendo inconsistencias y permitiendo que cualquier usuario autorizado ejecute esa lógica.

## Mantenimiento más sencillo

Al centralizar la lógica en procedimientos, los cambios se aplican solo en la base de datos. Las aplicaciones cliente no necesitan modificarse ni conocer cambios en diseños o procesos internos.

## Rendimiento mejorado

De forma predeterminada, un procedimiento se compila la primera vez que se ejecuta y
crea un plan de ejecución que vuelve a usarse en posteriores ejecuciones. Como el
procesador de consultas no tiene que crear un nuevo plan, normalmente necesita menos
tiempo para procesar el procedimiento.

### Sintaxis Básica de un Procedimiento Almacenado

### Definicion de un procedimiento (CREATE PROCEDURE)

CREATE PROCEDURE NombreDelProcedimiento
    @Parametro1 TipoDato,
    @Parametro2 TipoDato,
    @Resultado TipoDato OUTPUT
AS
BEGIN
    -- Instrucciones SQL (Se pone un ejemplo)
    SELECT * 
    FROM Tabla
    WHERE Columna1 = @Parametro1 
      AND Columna2 = @Parametro2;

    -- Asignación al parámetro de salida
    SET @Resultado = (SELECT COUNT(*) 
                      FROM Tabla
                      WHERE Columna1 = @Parametro1 
                        AND Columna2 = @Parametro2);
END;

-Pueden tener parámetros de entrada y salida (`IN` y `OUT`), permitiendo enviar valores hacia y desde el procedimiento.
- En el cuerpo, los procedimientos pueden ejecutar una amplia gama de operaciones, incluidas consultas de modificación de datos (`INSERT`, `UPDATE`, `DELETE`).
- Generalmente, la devolucion de valores se hace a través de parámetros de salida y no con una instrucción RETURN como en las funciones. Los procedimientos no tienen un tipo de retorno fijo.
- Los procedimientos pueden contener estructuras de control como `IF`, `WHILE` y `TRYCATCH`.

### Cambiar un procedimiento (ALTER PROCEDURE)
Se utiliza la instruccion ALTER PROCEDURE NombreProcedimiento para modificar un procedimiento almacenado existente. La sintaxis es similar a la de CREATE PROCEDURE, pero se utiliza ALTER en lugar de CREATE.

### Eliminar un procedimiento (DROP PROCEDURE)
Se utiliza la instruccion DROP PROCEDURE NombreProcedimiento para eliminar un procedimiento almacenado existente de la base de datos.

## Funciones Almacenadas
Una Función Almacenada es un bloque de código SQL precompilado y almacenado en el servidor de la base de datos, diseñado principalmente para el propósito de reutilización de código y la ejecución de tareas
específicas. Siempre acepta parámetros de entrada y está obligada a devolver un único valor (escalar o una tabla).

### Sintaxis Básica de una Función Almacenada

#### Definición de una Función Escalar

CREATE FUNCTION NombreDeLaFuncion
    (@Parametro1 TipoDato,
     @Parametro2 TipoDato)
RETURNS TipoDeRetorno -- Obligatorio: debe especificar el tipo de dato que devuelve (ej. INT, VARCHAR, DECIMAL)
AS
BEGIN
    DECLARE @Resultado TipoDeRetorno;

    -- Lógica de cálculo o consulta
    SET @Resultado = (
        SELECT COUNT(*)
        FROM Tabla
        WHERE Columna1 = @Parametro1
          AND Columna2 = @Parametro2
    );

    RETURN @Resultado; -- Obligatorio: debe finalizar con la sentencia RETURN
END;

#### Definición de una Función que Devuelve una Tabla

CREATE FUNCTION NombreDeFuncionTabla
    (@Parametro1 TipoDato)
RETURNS TABLE -- Indica que el resultado es una tabla
AS
RETURN
(
    -- La lógica debe ser una única sentencia SELECT
    SELECT ColumnaA, ColumnaB, ColumnaC
    FROM OtraTabla
    WHERE ColumnaFiltro = @Parametro1
);

### Cambiar una Función (ALTER FUNCTION)

Se utiliza la instrucción ALTER FUNCTION NombreDeLaFuncion para modificar una función almacenada existente. La sintaxis es la misma que la de CREATE FUNCTION, pero se utiliza ALTER en lugar de CREATE.

### Eliminar una Función (DROP FUNCTION)

 Se utiliza la instrucción DROP FUNCTION NombreDeLaFuncion para eliminar una función almacenada existente de la base de datos.

## Diferencia entre Procedimientos y Funciones Almacenadas

La distinción clave con los procedimientos almacenados radica en que la función no puede modificar objetos de la base de datos ni manejar transacciones, lo que limita su uso a operaciones de cálculo y recuperación
de datos. Además, su valor de retorno único permite que sea utilizada directamente dentro de expresiones SQL (como en SELECT o WHERE), algo que los procedimientos no pueden hacer al no devolver un valor simple, 
requiriendo una sentencia de ejecución (EXECUTE) separada.


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

##Bibliografía

https://www.udb.edu.sv/udb_files/recursos_guias/informatica-ingenieria/base-de-datos-i/2019/i/guia-10.pdf

https://www.scholarhat.com/tutorial/sqlserver/difference-between-stored-procedure-and-function-in-sql-server
https://www.mssqltips.com/sqlservertip/7437/sql-stored-procedures-views-functions-examples/