 @ConsultaEFOS
Feature: Consulta de contribuyentes EFOS en GM Fiscal

    Yo como usuario de GM Fiscal
    requiero consultar la lista de contribuyentes EFOS publicada por el SAT con filtros y exportación a Excel
    Para que pueda identificar emisores de facturas con operaciones simuladas y tomar decisiones fiscales informadas

    Background:
        Given que el usuario tiene sesión activa en GM Fiscal
        And se encuentra en la pantalla "Consulta EFOS"
        And la Bóveda Fiscal tiene disponible el catálogo EFOS con fecha de corte "07/05/2026"

    Scenario: Carga inicial de la pantalla sin filtros aplicados
        Given que no hay filtros activos
        When la pantalla termina de cargar
        Then el sistema muestra la tabla con los primeros 50 registros del catálogo EFOS
        And se muestra el texto "Última actualización: 07/05/2026" en la parte superior de la pantalla
        And se muestra el contador "X registros encontrados" con el total del catálogo
        And el botón "Limpiar filtros" no es visible
        And el botón "Exportar Excel" está habilitado

    Scenario: Filtrar por RFC exacto
        When el usuario escribe "AIM160526CH0" en el campo de filtro "RFC"
        Then la tabla muestra únicamente el registro con RFC "AIM160526CH0" y Nombre "ADMINISTRACION INTEGRAL MAYPE, S.A. DE C.V."
        And el contador muestra "1 registros encontrados"
        And el botón "Limpiar filtros" es visible

    Scenario: Filtrar por RFC parcial (empieza con)
        When el usuario escribe "AIM" en el campo de filtro "RFC"
        Then la tabla muestra únicamente los registros cuyo RFC comienza con "AIM"
        And el contador refleja el número de registros encontrados

    Scenario: Filtrar por Nombre (contiene)
        When el usuario escribe "COMERCIALIZADORA" en el campo de filtro "Nombre"
        Then la tabla muestra únicamente los registros cuyo nombre contiene el texto "COMERCIALIZADORA"
        And el contador refleja el número de registros encontrados

    Scenario Outline: Filtrar por Estado individual
        When el usuario selecciona "<estado>" en el filtro desplegable "Estado"
        Then la tabla muestra únicamente los registros con Estado "<estado>"
        And cada fila de la tabla muestra el badge de Estado con el color "<color>"

        Ejemplos:
        | estado       | color        |
        | Presunto     | amarillo     |
        | Definitivo   | rojo         |
        | Desvirtuado  | verde        |
        | Sentenciado  | rojo oscuro  |

    Scenario: Filtrar por Estado múltiple
        When el usuario selecciona "Presunto" y "Definitivo" en el filtro desplegable "Estado"
        Then la tabla muestra los registros con Estado "Presunto" y los registros con Estado "Definitivo"
        And no se muestran registros con Estado "Desvirtuado" ni "Sentenciado"

    Scenario: Filtrar por rango de fecha de publicación presunto
        When el usuario establece el filtro "Fecha pub. presunto" con fecha inicio "01/01/2026" y fecha fin "31/05/2026"
        Then la tabla muestra únicamente los registros cuya "Fecha pub. presunto" está dentro del rango "01/01/2026" – "31/05/2026"
        And el contador refleja el número de registros encontrados

    Scenario: Filtros combinados se aplican con lógica AND
        Given el usuario selecciona "Presunto" en el filtro "Estado"
        When el usuario escribe "COMERCIALIZADORA" en el filtro "Nombre"
        Then la tabla muestra únicamente los registros que tienen Estado "Presunto" Y cuyo nombre contiene "COMERCIALIZADORA"
        And no aparecen registros que cumplan solo una de las dos condiciones

    Scenario: Sin resultados con filtros aplicados
        When el usuario escribe "XRFCNOEXISTE999" en el campo de filtro "RFC"
        Then la tabla no muestra ningún registro
        And se muestra el mensaje "No se encontraron contribuyentes con los filtros aplicados."
        And el botón "Limpiar filtros" es visible
        And el botón "Exportar Excel" está deshabilitado

    Scenario: Limpiar filtros regresa al listado completo
        Given el usuario tiene activo el filtro "Estado" con valor "Definitivo"
        And la tabla muestra únicamente los registros con Estado "Definitivo"
        When el usuario hace clic en el botón "Limpiar filtros"
        Then todos los campos de filtro quedan vacíos o sin selección
        And la tabla vuelve a mostrar los primeros 10 registros del catálogo completo
        And el contador refleja el total del catálogo
        And el botón "Limpiar filtros" deja de ser visible

    Scenario: Exportar Excel con filtros activos
        Given el usuario tiene activo el filtro "Estado" con valor "Presunto"
        And la tabla muestra los registros con Estado "Presunto"
        When el usuario hace clic en el botón "Exportar Excel"
        Then el sistema genera y descarga un archivo Excel con todos los registros con Estado "Presunto" (no solo los de la página visible)
        And la primera fila del Excel muestra el encabezado con el resumen "Estado: Presunto"
        And la segunda fila contiene los títulos de columna: RFC, Nombre, Estado, Núm. y fecha oficio global, Fecha pub. presunto, Fecha oficio DOF, Fecha oficio desvirtuaron, Pub. SAT desvirtuado, Núm. fecha desvirtuado DOF, DOF desvirtuado, Núm. y fecha definitivo SAT, Fecha corte
        And las filas siguientes contienen los datos correspondientes
        And las celdas sin dato muestran el valor vacío

    Scenario: Exportar Excel sin filtros activos exporta el catálogo completo
        Given que no hay filtros activos
        When el usuario hace clic en el botón "Exportar Excel"
        Then el sistema genera y descarga un archivo Excel con todos los registros del catálogo EFOS
        And la primera fila del Excel muestra el encabezado "Catálogo EFOS completo – Última actualización: 07/05/2026"
        And el archivo contiene los mismos 12 títulos de columna a partir de la segunda fila

    Scenario: Paginación cuando el catálogo supera 10 registros
        Given que el catálogo EFOS tiene más de 10 registros
        When la pantalla termina de cargar
        Then la tabla muestra los primeros 10 registros
        And se muestran los controles de paginación con el número de páginas disponibles
        When el usuario navega a la página 2
        Then la tabla muestra los registros del 11 en adelante sin perder los filtros activos

    Scenario: Error de conexión con la Bóveda Fiscal al cargar la pantalla
        Given que la Bóveda Fiscal no está disponible al momento de entrar a la pantalla
        When la pantalla intenta cargar el catálogo EFOS
        Then la tabla no muestra registros
        And se muestra el mensaje "No fue posible cargar la información EFOS. Intente de nuevo."
        And se muestra el botón "Reintentar"
        When el usuario hace clic en "Reintentar"
        Then el sistema vuelve a intentar la consulta a la Bóveda Fiscal
