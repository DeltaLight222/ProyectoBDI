# Tema 1 — Manejo de transacciones y transacciones anidadas en SQL

#Introducción teórica	

## Transacciones en bases de datos

Una transacción es una unidad lógica de trabajo o procesamiento (ejecución de un programa que
incluye operaciones de acceso a la base de datos).
Una transacción es una secuencia de operaciones que llevan la base de datos desde un estado de
consistencia 1 a otro estado de consistencia, por esto suele decirse también que la transacción es una
unidad lógica de integridad.
Cuando múltiples transacciones son introducidas en el sistema por varios usuarios, es necesario
evitar que interfieran entre ellas de forma tal que provoquen que la BD quede en un estado no con-
sistente; desde este punto de vista, podemos ver una transacción como una unidad lógica de con-
currencia
Cuando ocurre un fallo que provoca la caída del sistema, en el momento en el que había varias
transacciones en curso de ejecución, muy probablemente dejará erróneos los datos en la BD (estado
inconsistente); en estas circunstancias, se debe garantizar que la BD pueda ser recuperada a un
estado en el cual su contenido sea consistente, por esto una transacción es considerada también
una unidad lógica de recuperación.
La idea clave es que una transacción debe ser atómica, es decir, las operaciones que la componen
deben ser ejecutadas en su totalidad o no ser ejecutadas en absoluto.


## Propiedades ACID de una transacción

1. Atomicidad
Todas las operaciones de la transacción son ejecutadas por completo, o no se ejecuta ninguna
de ellas (si se ejecuta la transacción, se hace hasta el final).
2. Consistencia
Una transacción T transforma un estado consistente de la base de datos en otro estado consis-
tente, aunque T no tiene por qué preservar la consistencia en todos los puntos intermedios de
su ejecución. Un ejemplo es el de la transferencia de una cantidad de dinero entre dos cuentas
bancarias.
3. Aislamiento (Isolation)
Una transacción está aislada del resto de transacciones.
Aunque existan muchas transacciones ejecutándose a la vez, cualquier modificación de datos
que realice T está oculta para el resto de transacciones hasta que T sea confirmada (realiza
COMMIT).
Es decir, para cualesquiera T1 y T2, se cumple que
- T1 ve las actualizaciones de T2 después de que T2 realice COMMIT, o bien
- T2 ve las modificaciones de T1, después de que T1 haga un COMMIT
Pero nunca se cumplen ambas cosas al mismo tiempo.
Nota: esta propiedad puede no imponerse de forma estricta2 ; de hecho, suelen definirse niveles
de aislamiento de las transacciones.
4. Durabilidad
Una vez que se confirma una transacción, sus actualizaciones sobreviven cualquier fallo del
sistema. Las modificaciones ya no se pierden, aunque el sistema falle justo después de realizar
dicha confirmación.

### Transacciones explicitas e implícitas
Una sentencia de definición o manipulación de datos ejecutada de forma interactiva (por ejemplo
utilizar el SQL*Plus de Oracle para realizar una consulta) puede suponer el inicio de una transac-
ción. Asimismo, la ejecución de una sentencia SQL por parte de un programa que no tiene ya una
transacción en progreso, supone la iniciación de una transacción.
Toda transacción finaliza con una operación de commit (confirmar) o bien con una operación de
rollback (anular, abortar o revertir).
Tanto una operación como la otra puede ser de tipo explícito (si la propia transacción (su código)
contiene una sentencia COMMIT o ROLLBACK) o implícito (si dicha operación es realizada por el
sistema de forma automática, por ejemplo tras detectar una terminación normal (éxito) o anormal
(fallo) de la transacción).
Por defecto, una vez finalizada una transacción, si todas sus operaciones se han realizado con éxi-
to, se realiza un COMMIT implícito de dicha transacción; y si alguna de ellas tuvo problemas, se
lleva a cabo un ROLLBACK implícito de la transacción (es decir, se deshacen todas las operaciones
que había realizado hasta el momento del fallo).

## Operaciones de una transacción
Para fines de recuperación es necesario saber cuándo se inicia,
termina y confirma o aborta una transacción. Así, el gestor de concurrencia del SGBD
debe controlar las operaciones:

BEGIN_TRANSACTION: Indica el inicio de la transacción.

READ o WRITE: Son las operaciones de acceso a datos (lectura o modificación) que se ejecutan dentro de la transacción.

END_TRANSACTION: Señala el final de las operaciones de acceso. En este punto, el sistema verifica si los cambios pueden aplicarse de forma permanente o si deben desecharse.

COMMIT_TRANSACTION: Indica el éxito. Los cambios realizados por la transacción se almacenan de forma permanente en la base de datos.

ROLLBACK o ABORT: Indican un fallo. Se deshacen todos los cambios realizados para revertir la base de datos al estado anterior.

## Estados de una trasacción
Las operaciones mencionadas hacen que las transacciones pasen por una serie de estados,
denominados estados de una transacción, y que se ilustran en la figura:
(VER FIGURA)

Estado activa: Una transacción se inicia en el estado ACTIVA, donde realiza sus operaciones de LEER y ESCRIBIR.

Estado parcialmente confirmada: Al completar estas operaciones, pasa a PARCIALMENTE CONFIRMADA. En este estado, los subsistemas de Control de Concurrencia y de Recuperación realizan verificaciones para:

   1- Asegurar que no haya interferido con otras transacciones.

   2- Registrar los cambios en la bitácora (log) del sistema para garantizar la durabilidad.

Estado confirmada: Si ambas verificaciones son exitosas, la transacción pasa a CONFIRMADA y sus cambios se hacen permanentes.

Estado fallida: Si la transacción falla (por una verificación fallida o si se aborta mientras estaba ACTIVA), pasa al estado FALLIDA. En este punto, debe ser cancelada (anulada o revertida) para deshacer sus efectos.

Estado terminada: Finalmente, la transacción pasa a TERMINADA, abandonando el sistema. Las transacciones fallidas pueden ser reiniciadas por el sistema o por el usuario como transacciones nuevas.

## Operaciones de transacciones en SQL Server
BEGIN TRANSACTION: Esta instrucción se utiliza para marcar el punto de inicio de una transacción explícita en SQL Server.

COMMIT TRANSACTION: Esta instrucción se utiliza para confirmar (hacer permanentes) los cambios realizados durante la transacción actual.

ROLLBACK TRANSACTION: Esta instrucción se utiliza para deshacer (revertir) todos los cambios realizados durante la transacción actual.

SAVE TRANSACTION: Esta instrucción se utiliza para crear un punto de guardado dentro de una transacción, permitiendo deshacer cambios hasta ese punto específico sin afectar a toda la transacción.

## Transacciones anidadas
Podemos anidar varias transacciones. Cuando anidamos varias transacciones la instrucción COMMIT afectará a la última transacción abierta, pero ROLLBACK afectará a todas las transacciones abiertas.
Un hecho a tener en cuenta es que si hacemos ROLLBACK de la transacción superior se desharan también los cambios de todas las transacciones internas, aunque hayamos realizado COMMIT de ellas.
En SQL Server, las transacciones anidadas se gestionan con la variable @@TRANCOUNT (contador de transacciones).
 -BEGIN TRAN aumenta @@TRANCOUNT.
-COMMIT TRAN lo disminuye, pero los cambios solo se vuelven permanentes cuando @@TRANCOUNT llega a cero (la transacción más externa se confirma).
Si se ejecuta un ROLLBACK (en cualquier nivel de anidamiento):
-Se deshacen todos los cambios realizados desde la primera transacción externa.
-La variable @@TRANCOUNT se reinicia a cero.
Es decir, un rollback interno deshace toda la transacción principal, ignorando cualquier commit parcial que se haya realizado en los niveles inferiores.
Se pueden usar SAVEPOINTS para marcar puntos específicos dentro de una transacción anidada, permitiendo deshacer hasta esos puntos sin afectar a toda la transacción.


Bibliografía:

https://www.sqlservercentral.com/articles/explicit-transactions
https://w3.ual.es/~mtorres/BD/bdt6.pdf
https://www.grch.com.ar/docs/bd/apuntes/BDTema06.pdf
https://sqlearning.com/es/elementos-lenguaje/transacciones/