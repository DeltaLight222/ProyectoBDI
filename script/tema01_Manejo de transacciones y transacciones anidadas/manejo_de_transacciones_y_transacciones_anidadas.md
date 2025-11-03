# Manejo de transacciones y transacciones anidadas en SQL

 El manejo de transacciones es una parte esencial de los sistemas de bases de datos. Garantiza que las operaciones sobre los datos se ejecuten de forma segura, coherente y confiable, manteniendo la integridad de la información en todo momento.

 Una transacción es una unidad lógica de trabajo que agrupa varias operaciones (como INSERT, UPDATE, o DELETE). El principio fundamental es que todas estas operaciones deben ejecutarse en su totalidad (éxito) o no ejecutarse en absoluto (fallo/reversión). Esto asegura que la base de datos nunca quede en un estado intermedio o inconsistente.

 ## Propiedades ACID

 Tema 4 — Manejo de transacciones y transacciones anidadas en SQL

El manejo de transacciones es una parte esencial de los sistemas de bases de datos. Garantiza que las operaciones sobre los datos se ejecuten de forma segura, coherente y confiable, manteniendo la integridad de la información en todo momento.

Una transacción es una unidad lógica de trabajo que agrupa varias operaciones (como INSERT, UPDATE, o DELETE). El principio fundamental es que todas estas operaciones deben ejecutarse en su totalidad (éxito) o no ejecutarse en absoluto (fallo/reversión). Esto asegura que la base de datos nunca quede en un estado intermedio o inconsistente.

Propiedades ACID

El correcto funcionamiento de las transacciones se basa en las propiedades ACID:

    Atomicidad (Atomicity): Todas las operaciones dentro de la transacción se completan correctamente (COMMIT) o se deshacen por completo (ROLLBACK). Es un "todo o nada".

    Consistencia (Consistency): La base de datos pasa de un estado válido a otro estado válido, respetando todas las reglas, restricciones y triggers definidos.

    Aislamiento (Isolation): Las transacciones concurrentes (que se ejecutan al mismo tiempo) no interfieren entre sí. Para una transacción, pareciera que se está ejecutando sola.

    Durabilidad (Durability): Una vez que la transacción ha sido confirmada (COMMIT), los cambios persisten de forma permanente, incluso ante fallos del sistema, cortes de energía o reinicios.

## ROLLBACK

La instrucción ROLLBACK (o ROLLBACK TRANSACTION) es un comando de SQL que se utiliza para deshacer por completo todas las modificaciones de datos realizadas desde el inicio de la transacción más reciente, o desde el último COMMIT.

Su propósito principal es garantizar la propiedad de Atomicidad al revertir la base de datos a su último estado confirmado (committed state), eliminando así cualquier cambio "tentativo" o temporal provocado por las operaciones de la transacción actual. Esto es fundamental para mantener la integridad de los datos en caso de que ocurran errores (fallo de hardware, violación de una restricción, excepción en el código, etc.) o se decidan cancelar los cambios antes de su confirmación.

    Función: Deshace permanentemente todos los cambios dentro de una transacción activa.

    Mecanismo: Vuelve al estado de la base de datos que existía justo después de la última instrucción COMMIT o ROLLBACK ejecutada.

# Transacciones anidadas y SAVEPOINTs

## Transacciones Anidadas

Una transacción anidada se produce cuando se inicia una nueva transacción dentro de otra.

En sistemas como SQL Server o PostgreSQL, aunque es posible usar múltiples BEGIN TRANSACTION, a menudo la realidad es que todas dependen de la transacción más externa o principal:

    Solo el primer ROLLBACK revierte todo el bloque, independientemente del nivel de anidación.

    Solo el último COMMIT confirma los cambios de todo el bloque.

Esto permite realizar pruebas parciales dentro de un bloque más grande, o definir puntos de recuperación sin afectar la transacción completa si no es necesario revertir todo.

Puntos de Guardado (SAVEPOINT)

Cuando se desea revertir solo una parte de una transacción, sin cancelar todo el bloque de operaciones, se utilizan los SAVEPOINTS o puntos de guardado.

    Un SAVEPOINT marca un punto intermedio dentro de una transacción.

    Con la instrucción ROLLBACK TO SAVEPOINT NombrePunto, puedes "retroceder" hasta ese punto anterior, descartando solo las operaciones realizadas después del SAVEPOINT, mientras que las operaciones anteriores al punto permanecen activas en la transacción.

Esto es extremadamente útil en procedimientos complejos donde varias operaciones dependen de verificaciones intermedias.