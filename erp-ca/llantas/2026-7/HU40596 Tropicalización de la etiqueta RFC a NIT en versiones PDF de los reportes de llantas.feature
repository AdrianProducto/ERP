Feature: Cambio de etiquete RFC a NIT en PDF de reportes de Llantas

    Yo como usuario del modulo de llantas 
    requiero que se haga el ajuste dentro de los PDFs de los reportes de llantas 
    para que los usuarios del ERP guatemala puedan ver el identificador fiscal correcto. 

Scenario Outline: Cambio de RFC a NIT en reportes de Llantas 
    Given dado que el usuario entra a una base de datos de guatemala
    When el usuario exporte el <Reporte> a PDF
    And el usuario abra el archivo pdf generado 
    Then se debe visualizar la etiquete NIT en vez de RFC en el encabezado del reporte.
  
    Example: 
    | Reporte                            |
    | Reporte de llantas instaladas      |
    | Llantas Enviadas a Recubrimiento   |
    | Auxiliar de Llantas                |
    | Existencia de llantas por artículo |

Scenario: Aplicación de sengundo plano del reporte "Auxiliar de Llantas"
    Given que el usuario se encuentra dentro de una base de datos de guatemala
    And se aplicaron cambios en la etiqueta RFC a NIT en el reporte
    And el reporte se genera en 2do plano 
    When el usuario descarga el archivo generado en 2do plano 
    And abre el archivo PDF 
    Then se debe visualizar la etiqueta NIT en vez de RFC en el archivo generado. 

Scenario Outline: El reporte es visible en base de datos de guatemala
    Given los <Reportes> ya se encuentran tropicalizados 
    When el usuario entre a la base de datos de guatemala 
    Then en el listado de reportes de llantas seran visbles estos reportes

    Example: 
    | Reportes                           |
    | Reporte de llantas instaladas      |
    | Llantas Enviadas a Recubrimiento   |
    | Auxiliar de Llantas                |
    | Existencia de llantas por artículo |

Scenario Outline: Mantener compartamiento actual de los reportes en bases de datos de México
    Given que el usuario accede a una base de datos de México
    And ingresa al listado de reportes de llantas 
    And genera los <Reportes>
    And los exporta a PDF
    When abra el archivo generado 
    Then estos reportes deben conservar la etiqueta RFC.
    Example:
    | Reportes                           |
    | Reporte de llantas instaladas      |
    | Llantas Enviadas a Recubrimiento   |
    | Auxiliar de Llantas                |
    | Existencia de llantas por artículo |