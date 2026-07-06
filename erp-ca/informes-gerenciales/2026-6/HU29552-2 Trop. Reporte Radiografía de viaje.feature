Feature: Tropicalizacion del reporte "Radiografía de viaje" del modulo de informes gerenciales

    Yo como usuario del reporte Radiografía de viaje del modulo de informes gerenciales
    Requiero que el reporte se encuentre adaptada para el uso con moneda de quetzales
    Para que el reporte encaje con las actividades realizadas en el pais de guatemala.

Background:
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al reporte "Radiografía de viaje"

Scenario Outline: Signo de Quetzales en columnas con importes
    When el usuario genera el reporte
    And consulte las <ColumnasConImporte>
    Then las columnas muestran los importes de los registros realizados en moneda nacional con el signo de quetzales "Q"

    #La mayor parte de las columnas del reporte son dinamicas, es decir que el nombre de las columnas puede variar dependiendo los filtros seleccionados   
    Examples:
    | ColumnasConImporte |
    | Totales de periodo |
    | Enero 2026         |
    | Febrero 2026       |
    | Enero 2025         |

Scenario: Ajuste en las descripciones de las condiciones de viaje, Fila "Ingresos Generados"
    Given que el usuario ingresa a la seccion "Condiciones del reporte"
    And consulta la informacion de la fila "Ingresos Generados"
    Then la fila cuenta con la siguiente descripcion:
    "Son los subtotales de aquellos viajes/Trayectos, con fecha de salida en el mes seleccionado, que no estén cancelados y 
    que la unidad asignada a cada Trayecto, este marcada en el filtro de unidades, este reporte debe cuadrar con el reporte de salidas diarias con importe #3, 
    con los importes convertidos a quetzales."

Scenario: Ajuste en las descripciones de las condiciones de viaje, Fila "Gastos de viaje"
    Given que el usuario ingresa a la seccion "Condiciones del reporte"
    And consulta la informacion de la fila "Gastos de viaje"
    Then la fila cuenta con la siguiente descripcion:
    "Son la suma de todos los importes (sin iva) de los gastos de todos aquellos viajes/Trayectos, con fecha de salida en el mes seleccionado, que no estén cancelados y 
    que la unidad asignada a cada Trayecto, este marcada en el filtro de unidades, este reporte debe cuadrar con el reporte de gastos vs anticipos ordenado por viaje #26. 
    Generando el reporte #26 con el filtro de Fecha de salida del trayecto y convertido a quetzales."

Scenario: Ajuste en las descripciones de las condiciones de viaje, Fila "Gastos de Mantenimiento"
    Given que el usuario ingresa a la seccion "Condiciones del reporte"
    And consulta la informacion de la fila "Gastos de Mantenimiento"
    Then la fila cuenta con la siguiente descripcion:
    "Son los gastos que se documentaron en órdenes de reparación de las unidades marcadas en el filtros, tomando en cuenta como base de fechas las ordenes de servicio cerradas 
    con fecha del mes seleccionado, éste reporte debe cuadrar con el kardex de la unidad (Reporte de Servicio)#1 cuando se genere el reporte con el filtro de convertir a la 
    moneda quetzales y se seleccionen todos los servicios."

Scenario: Ajuste en las descripciones de las condiciones de viaje, Fila "Gastos de Combustible"
    Given que el usuario ingresa a la seccion "Condiciones del reporte"
    And consulta la informacion de la fila "Gastos de Combustible"
    Then la fila cuenta con la siguiente descripcion:
    "Son la suma de todos importes sin iva de los gastos tipo combustible, de los gastos de todos aquellos viajes/Trayectos, con fecha de salida en el mes seleccionado, 
    que no estén cancelados y que la unidad asignada a cada Trayecto, este marcada en el filtro de unidades, este reporte debe cuadrar con el reporte de gastos vs anticipos
     ordenado por viaje #26. Generando el reporte #26 con el filtro de Fecha de salida del trayecto y convertido a quetzales.

Scenario Outline: Aplicar ajustes en exportación a Excel
  Given que el usuario exporta el reporte "Radiografía de viaje" a Excel con la opcion "Exportar XLS"
  When abre el archivo generado
  Then los cambios solicitados en los escenarios anteriores son visibles en el formato excel
  And las <formulas> deben poder ejecutarse correctamente de forma directa en Excel.

    Examples:Formulas que el usuario podria aplicar en excel.
      | formulas    |
      | Autosuma    |
      | Multiplicar |
      | Promedio    |

Scenario: Aplicar ajustes de exportacion a PDF
    Given que el usuario exporta el reporte "Radiografía de viaje" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then los cambios solicitados en los escenarios anteriores son visibles en el formato PDF

Scenario: Cambiar etiqueta "RFC" a "NIT" en formato PDF
    Given que el usuario exporta el reporte "Radiografía de viaje" a PDF con la opcion "Imprimir PDF"
    When abre el archivo generado
    Then el reporte muestra ahora la etiqueta "NIT" en lugar de "RFC" en el encabezado del reporte en PDF

Scenario: Mantener comportamiento actual del reporte para bases de datos de México
  Given que el usuario accede al reporte "Radiografía de viaje" del módulo de informes gerenciales en una base de datos de México
  When genera el reporte
  Then el reporte no debe de presentar ningun cambio referente a la tropicalizacion
  And el proceso debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el reporte ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el reporte "Radiografía de viaje" en el listado de reportes del modulo de informes gerenciales.