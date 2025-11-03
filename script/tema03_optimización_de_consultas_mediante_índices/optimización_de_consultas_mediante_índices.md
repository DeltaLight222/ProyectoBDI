# Tema 3 — Optimización de consultas a través de índices 

 

La optimización de consultas es fundamental para mejorar el rendimiento de las bases de datos. Los índices permiten acceder a los datos de manera más rápida y eficiente, evitando recorrer toda la tabla y acelerando las búsquedas. 

 

Un índice funciona de forma similar al índice de un libro: en lugar de revisar página por página, permite saltar directamente al punto donde se encuentran los datos buscados. Sin un índice, el motor realiza un *Table Scan*; con un índice, realiza un *Index Seek*, limitando la búsqueda a las filas relevantes. 

 

--- 

 

### Tipos de índices 

 

Existen distintos tipos de índices según su estructura y finalidad: 

 

- **Hash:** Optimizado para búsquedas exactas en memoria, utiliza una cantidad fija de memoria.   

- **Índice no agrupado optimizado para memoria:** Consume memoria según la cantidad de filas y el tamaño de las columnas clave.   

- **Clustered (agrupado):** Ordena y almacena físicamente las filas de la tabla según la clave del índice, ideal para búsquedas por rango o consultas frecuentes sobre columnas ordenadas.   

- **Nonclustered (no agrupado):** Estructura independiente de la tabla, útil para acceder rápidamente a columnas específicas sin reorganizar la tabla.   

- **Unique (único):** Garantiza que no existan valores duplicados, aplicable a índices agrupados o no agrupados.   

- **Columnstore (almacén de columnas):** Almacena los datos por columnas, mejorando la compresión y el rendimiento de consultas analíticas o de solo lectura.   

- **Índice con columnas incluidas:** Extiende un índice no agrupado incluyendo columnas adicionales para cubrir consultas sin acceder a la tabla base.   

- **Índice en columnas calculadas:** Basado en expresiones o cálculos sobre otras columnas.   

- **Filtered (filtrado):** Indexa solo una parte de la tabla definida por una condición, optimizando consultas sobre subconjuntos de datos.   

- **Spatial (espacial):** Optimiza operaciones sobre datos espaciales (coordenadas, polígonos, etc.).   

- **XML:** Facilita búsquedas dentro de documentos XML.   

- **Full-text:** Permite búsquedas complejas de texto en columnas con gran volumen de información. 

 

--- 

 

### Cuándo conviene crear un índice 

 

Los índices mejoran la lectura, pero aumentan el costo de escritura (*INSERT, UPDATE, DELETE*). Por lo tanto, deben aplicarse estratégicamente. 

 

Conviene crear un índice cuando: 

 

- La columna se usa frecuentemente en condiciones `WHERE`.   

- Se utiliza para ordenar resultados (`ORDER BY`).   

- Se realizan búsquedas por rangos (`BETWEEN, <, >`).   

- La tabla tiene gran volumen de datos y las consultas son recurrentes sobre ciertas columnas. 

 

No es recomendable en columnas con pocos valores distintos o en tablas pequeñas, ya que el mantenimiento puede superar los beneficios. 

 

--- 

 

### Desarrollo del tema 

 

**Tareas:** 

 

1. Cargar masivamente al menos un millón de registros en una tabla con campo fecha (sin índice) mediante un script automatizado.   

2. Realizar búsquedas por periodo y registrar el plan de ejecución y los tiempos de respuesta.   

3. Crear un índice agrupado sobre la columna fecha y repetir la búsqueda, registrando nuevamente plan de ejecución y tiempos.   

4. Borrar el índice creado.   

5. Crear otro índice agrupado sobre la columna fecha incluyendo columnas adicionales y repetir la búsqueda, registrando resultados.   

6. Expresar conclusiones en base a la información estudiada y las buenas prácticas de uso de índices. 

 

--- 

 

### Conclusión 

 

Los índices en bases de datos son esenciales para acelerar la recuperación de información y optimizar el rendimiento de las consultas. Permiten acceder más rápido a los datos y mejorar la eficiencia general del sistema.   

 

Aunque las consultas sin índices pueden ser suficientes en tareas simples o tablas pequeñas, la implementación adecuada de índices es una buena práctica en bases de datos con gran volumen de información, donde la velocidad de consulta, la eficiencia y el control sobre los datos son prioridad. 
