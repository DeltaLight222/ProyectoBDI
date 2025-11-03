# Tema 1 — Manejo de transacciones y transacciones anidadas en SQL

El manejo de transacciones es una parte fundamental de los sistemas de bases de datos, ya que garantiza que las operaciones sobre los datos se realicen de forma segura, coherente y confiable. Su objetivo principal es mantener la integridad de la información en todo momento.

Una **transacción** es una unidad lógica de trabajo que agrupa varias operaciones (como `INSERT`, `UPDATE` o `DELETE`). El principio esencial es que todas estas operaciones deben ejecutarse **por completo** (éxito) o **no ejecutarse en absoluto** (fallo o reversión). De esta manera, se evita que la base de datos quede en un estado intermedio o inconsistente.

---

## Propiedades ACID

El correcto funcionamiento de las transacciones se basa en las propiedades **ACID**, que aseguran que las operaciones sean confiables y consistentes:

- **Atomicidad (Atomicity):** Todas las operaciones dentro de la transacción se completan correctamente (`COMMIT`) o se deshacen por completo (`ROLLBACK`). Es decir, se cumple el principio del “todo o nada”.
  
- **Consistencia (Consistency):** La base de datos pasa de un estado válido a otro, respetando todas las reglas, restricciones y disparadores (triggers) definidos.
  
- **Aislamiento (Isolation):** Las transacciones concurrentes (que se ejecutan al mismo tiempo) no interfieren entre sí. Cada transacción se comporta como si fuera la única en ejecución.
  
- **Durabilidad (Durability):** Una vez confirmada una transacción (`COMMIT`), los cambios se mantienen de forma permanente, incluso si ocurre un fallo del sistema, un corte de energía o un reinicio.


## ROLLBACK

La instrucción `ROLLBACK` (o `ROLLBACK TRANSACTION`) se utiliza para **deshacer** todas las modificaciones de datos realizadas desde el inicio de la transacción actual o desde el último `COMMIT`.

Su función es garantizar la **atomicidad**, devolviendo la base de datos a su último estado confirmado y eliminando cualquier cambio temporal realizado por la transacción en curso. Su mecanismo consiste en restaurar la base de datos al estado que tenía justo después del último `COMMIT` o `ROLLBACK` ejecutado.  
Esto resulta esencial cuando ocurre un error (por ejemplo, una violación de restricción o una excepción en el código) o cuando se decide cancelar los cambios antes de confirmarlos.

# Transacciones anidadas y SAVEPOINTs

## Transacciones anidadas

Una **transacción anidada** ocurre cuando se inicia una nueva transacción dentro de otra.

En sistemas como **SQL Server** o **PostgreSQL**, aunque es posible ejecutar múltiples `BEGIN TRANSACTION`, en la práctica todas dependen de la transacción principal o externa:

- Solo el primer `ROLLBACK` revierte todo el bloque, sin importar el nivel de anidación.  
- Solo el último `COMMIT` confirma los cambios de toda la transacción.

Esto permite realizar pruebas o validaciones parciales dentro de un bloque más grande, definiendo puntos de control sin necesidad de revertir toda la transacción si no es necesario.


## Puntos de guardado (SAVEPOINT)

Cuando se desea revertir solo una parte de una transacción sin cancelar todo el bloque de operaciones, se utilizan los **SAVEPOINTs** o **puntos de guardado**.

Un `SAVEPOINT` marca un punto intermedio dentro de una transacción, y su función es permitir que se reviertan únicamente las operaciones realizadas después de ese punto. Su mecanismo se basa en la instrucción `ROLLBACK TO SAVEPOINT nombre_punto`, que “retrocede” hasta el punto definido, descartando los cambios posteriores mientras mantiene los anteriores activos dentro de la transacción.

Esto resulta muy útil en procedimientos complejos, donde se ejecutan múltiples operaciones dependientes y se requiere controlar el flujo sin perder todo el progreso de la transacción principal.
