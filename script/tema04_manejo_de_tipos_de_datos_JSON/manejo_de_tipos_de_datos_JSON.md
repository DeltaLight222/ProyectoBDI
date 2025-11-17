
¿Qué es JSON?
JSON es un formato de texto ampliamente utilizado para el intercambio de datos en aplicaciones web y móviles. También se emplea para almacenar información no estructurada en archivos de registro y bases NoSQL como Azure Cosmos DB. Numerosos servicios REST devuelven o reciben datos en formato JSON; entre ellos, varios servicios de Azure, como Azure Search, Azure Storage y Azure Cosmos DB. Además, JSON es el formato principal para el intercambio de datos entre páginas web y servidores mediante llamadas AJAX.
Las funciones JSON incorporadas en SQL Server a partir de la versión 2016 permiten integrar conceptos NoSQL dentro de una base de datos relacional. Con estas funciones es posible combinar columnas tradicionales con columnas que almacenan documentos JSON, transformar JSON en estructuras relacionales y generar JSON a partir de datos relacionales.
Estructura de datos en formato JSON

JSON funciona mediante la representación de datos de forma jerárquica, utilizando pares clave-valor para almacenar información. Los datos JSON se colocan entre llaves ({}), y cada par clave-valor se separa con una coma (,). Por ejemplo, el siguiente JSON representa la información de contacto de una persona:
{
  "nombre": "María González",
  "edad": 28,
  "ciudad": "Buenos Aires",
  "telefono": "01145678932",
  "correo": "maria.gonzalez@ejemplo.com"
}


 En este caso, "nombre", "edad", "ciudad", "telefono" y "correo" son las claves, mientras que "María González", 28, "Buenos Aires", "01145678932" y “maria.gonzales@ejemplo.com” son los valores correspondientes.
Uso del formato JSON en SQL Server

SQL Server no tiene un tipo de dato exclusivo llamado JSON, pero permite almacenar JSON en columnas NVARCHAR y procesarlo mediante funciones nativas, algunas de estas funciones nativas son:
Crear objetos JSON
El JSON se guarda en columnas NVARCHAR:
CREATE TABLE Tabla (
    id INT IDENTITY PRIMARY KEY,
    json NVARCHAR(tamaño)
);


Validar JSON
SQL Server permite verificar si el contenido es un JSON válido:
SELECT ISJSON(json) AS EsValido
FROM Tabla;

Extraer valores
Devuelve un valor simple (texto, número, booleano) desde una ruta JSON. Si el valor es un objeto o arreglo, devuelve NULL.
SELECT JSON_VALUE(json, '$.nombre') AS Nombre
FROM Tabla;


Modificar contenido
Se usa para obtener porciones completas del JSON, como objetos anidados o arreglos. Devuelve un JSON válido.
SELECT JSON_QUERY(json, '$.direccion') AS DireccionCompleta
FROM Tabla;

Convertir arrays JSON en filas
Interpreta contenido JSON (arreglo u objeto) y lo convierte en una tabla de filas y columnas. Permite expandir arreglos y crear resultados tabulares.
SELECT *
FROM OPENJSON('[
  {"id":1, "nombre":"Juan"},
  {"id":2, "nombre":"Ana"}
]');


Actualizar valores o agregar propiedades
JSON_MODIFY ( Expresion, Ruta, Nuevo valor)

