## Manipulacion de datos JSON 

JSON es un formato de texto ampliamente utilizado para el intercambio de datos en aplicaciones web y móviles. También se emplea para almacenar información no estructurada en archivos de registro y bases NoSQL 
como Azure Cosmos DB. Numerosos servicios REST devuelven o reciben datos en formato JSON; entre ellos, varios servicios de Azure, como Azure Search, Azure Storage y Azure Cosmos DB. Además, JSON es el formato
principal para el intercambio de datos entre páginas web y servidores mediante llamadas AJAX.
Las funciones JSON incorporadas en SQL Server a partir de la versión 2016 permiten integrar conceptos NoSQL dentro de una base de datos relacional. Con estas funciones es posible combinar columnas tradicionales
con columnas que almacenan documentos JSON, transformar JSON en estructuras relacionales y generar JSON a partir de datos relacionales.


JSON funciona mediante la representación de datos de forma jerárquica, utilizando pares clave-valor para almacenar información. 
Los datos JSON se colocan entre llaves ({}), y cada par clave-valor se separa con una coma (,). Por ejemplo, el siguiente JSON 
representa la información de contacto de una persona:
{
  "nombre": "María González",
  "edad": 28,
  "ciudad": "Buenos Aires",
  "telefono": "01145678932",
  "correo": "maria.gonzalez@ejemplo.com"
}

En este caso, "nombre", "edad", "ciudad", "telefono" y "correo" son las claves, mientras que "María González", 28, "Buenos Aires", 
"01145678932" y “maria.gonzales@ejemplo.com” son los valores correspondientes.



## Bibliografia

https://learn.microsoft.com/es-es/sql/relational-databases/json/json-data-sql-server?view=sql-server-ver17
https://learn.microsoft.com/es-es/sql/t-sql/functions/json-functions-transact-sql?view=sql-server-ver17
https://www.oracle.com/latam/database/what-is-json/