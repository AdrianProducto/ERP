Feature: Tropicalizacion del proceso "Prenomina" del modulo de nominas

    Yo como usuario del proceso de Prenomina del modulo de nominas
    Requiero que el proceso se encuentre adaptado al contexto del pais de guatemala 
    Para que el usuario se encuentre familiarizado con los registros que realizara

Background: 
    Given que el usuario se encuentra dentro de una base de datos del pais de guatemala
    And ingresa al proceso de prenomina del modulo de nominas

Scenario: Signo de quetzales en campo "SDI" de la informacion general
    When el usuario ingresa a la funcion "Recibo"
    And consulta el campo "SDI" de la seccion de informacion general del recibo
    Then el importe en moneda nacional del campo se visualizan con el signo de quetzales "Q"

Scenario: Signo de quetzales en campo "Sueldo Diario" de la informacion general
    When el usuario ingresa a la funcion "Recibo"
    And consulta el campo "Sueldo Diario" de la seccion de informacion general del recibo
    Then el importe en moneda nacional del campo se visualizan con el signo de quetzales "Q"

Scenario: Signo de quetzales en la columna "Importe Total" de la seccion "Percepciones"
    When el usuario ingresa a la funcion "Recibo"
    And consulta la columna "Importe Total" de la seccion "Percepciones" de la pestaña "Percepciones y Deducciones"
    Then los importes en moneda nacional de la columna se visualizan con el signo de quetzales "Q"

Scenario Outline: Signo de quetzales en campos de funciones de Percepciones
    When el usuario ingresa a la funcion "Recibo"
    And realice movimientos en la <Funcion> de la seccion percepciones de la pestaña "Percepciones y Deducciones"
    Then los <CamposImportes> muestran signo de quetzales al ingresar informacion

    Example:
    | Funcion   | CamposImportes |
    | Agregar   | Sueldo         |
    | Modificar | Gravado ISR    |
    |           | Exento ISR     |
    |           | Gravado IGSS   |
    |           | Exento IGSS    |

Scenario Outline: Cambio de etiqueta en campos referentes a IMSS
    When el usuario ingresa a la funcion "Recibo"
    And realice movimientos en la <Funcion> de la seccion percepciones de la pestaña "Percepciones y Deducciones"
    Then los <CamposIMSS> ahora se visualizan con la <NuevaEtiqueta>

    Example: 
    | Funcion   | CamposIMSS   | NuevaEtiqueta |
    | Agregar   | Gravado IMSS | Gravado IGSS  |
    | Modificar | Exento IMSS  | Exento IGSS   |

Scenario: Signo de quetzales en campo "Total percepciones"
    When el usuario ingresa a la funcion "Recibo"
    And consulta el campo "Total percepciones" 
    Then el importe en moneda nacional del campo se visualizan con el signo de quetzales "Q"

Scenario: Signo de quetzales en la columna "Importe Total" de la seccion "Deducciones"
    When el usuario ingresa a la funcion "Recibo"
    And consulta la columna "Importe Total" de la seccion "Deducciones" de la pestaña "Percepciones y Deducciones"
    Then los importes en moneda nacional de la columna se visualizan con el signo de quetzales "Q"

Scenario Outline: Signo de quetzales en campos de funciones de deducciones
    When el usuario ingresa a la funcion "Recibo"
    And realice movimientos en la <Funcion> de la seccion deducciones de la pestaña "Percepciones y Deducciones"
    Then los <CamposImportes> muestran signo de quetzales al ingresar informacion

    Example:
    | Funcion   | CamposImportes |
    | Agregar   | Importe Total  |
    | Modificar |                |

Scenario Outline: Cambio de etiqueta en campos referentes a IMSS
    When el usuario ingresa a la funcion "Recibo"
    And realice movimientos en la <Funcion> de la seccion deducciones de la pestaña "Percepciones y Deducciones"
    Then los <CamposIMSS> ahora se visualizan con la <NuevaEtiqueta>

    Example: 
    | Funcion   | CamposIMSS   | NuevaEtiqueta |
    | Agregar   | Gravado IMSS | Gravado IGSS  |
    | Modificar | Exento IMSS  | Exento IGSS   |

Scenario: Signo de quetzales en campo "Total deducciones"
    When el usuario ingresa a la funcion "Recibo"
    And consulta el campo "Total deducciones" 
    Then el importe en moneda nacional del campo se visualizan con el signo de quetzales "Q"

Scenario: Signo de quetzales en campo "Neto a Pagar"
    When el usuario ingresa a la funcion "Recibo"
    And consulta el campo "Neto a Pagar" 
    Then el importe en moneda nacional del campo se visualizan con el signo de quetzales "Q"

Scenario: Signo de quetzales en la columna "Importe Total" de la seccion "Obligaciones"
    When el usuario ingresa a la funcion "Recibo"
    And consulta la columna "Importe Total" de la seccion "Obligaciones" de la pestaña "Obligaciones"
    Then los importes en moneda nacional de la columna se visualizan con el signo de quetzales "Q"

Scenario Outline: Signo de quetzales en campos de funciones de obligaciones
    When el usuario ingresa a la funcion "Recibo"
    And realice movimientos en la <Funcion> de la seccion obligaciones de la pestaña "Obligaciones"
    Then los <CamposImportes> muestran signo de quetzales al ingresar informacion

    Example:
    | Funcion   | CamposImportes |
    | Agregar   | Importe total  |
    | Modificar | Gravado ISR    |
    |           | Exento ISR     |
    |           | Gravado IGSS   |
    |           | Exento IGSS    |

Scenario Outline: Cambio de etiqueta en campos referentes a IMSS
    When el usuario ingresa a la funcion "Recibo"
    And realice movimientos en la <Funcion> de la seccion obligaciones de la pestaña "obligaciones"
    Then los <CamposIMSS> ahora se visualizan con la <NuevaEtiqueta>

    Example: 
    | Funcion   | CamposIMSS   | NuevaEtiqueta |
    | Agregar   | Gravado IMSS | Gravado IGSS  |
    | Modificar | Exento IMSS  | Exento IGSS   |

Scenario: Signo de quetzales en campo "Total Obligaciones"
    When el usuario ingresa a la funcion "Recibo"
    And consulta el campo "Total Obligaciones" 
    Then el importe en moneda nacional del campo se visualizan con el signo de quetzales "Q"

Scenario Outline: Signo de quetzales en columnas de la pestaña "Acumulados"
    When el usuario ingresa a la funcion "Recibo"
    And ingrese a la pesteña "Acumulados"
    And consulte las <ColumnasConImporte>
    Then los importes en moneda nacional se visualizan con el signo de quetzales "Q"

    Example: 
    | ColumnasConImporte               |
    | Acumulado del ejercicio anterior |
    | importe inicial del ejercicio    |
    | Importe                          |

Scenario Outline: Signo de quetzales en columnas de la pestaña "PDO Fijos"
    When el usuario ingresa a la funcion "Recibo"
    And ingrese a la pesteña "PDO Fijos"
    And consulte las <ColumnasConImporte>
    Then los importes en moneda nacional se visualizan con el signo de quetzales "Q"

    Example: 
    | ColumnasConImporte |
    | Monto limite       |
    | Monto acumulado    |

Scenario: ocultar pestaña "INFONAVIT"
    When el usuario ingresa a la funcion "Recibo"
    Then la pestaña "INFONAVIT" no es visible en la funcion para el usuario

Scenario: ocultar pestaña "FONACOT"
    When el usuario ingresa a la funcion "Recibo"
    Then la pestaña "FONACOT" no es visible en la funcion para el usuario

Scenario: Signo de quetzales en campo "Sueldo Diario"
    When el usuario ingresa a la funcion "Finiquito"
    And consulta el campo "Sueldo Diario" de la seccion de informacion general
    Then el importe en moneda nacional del campo se visualizan con el signo de quetzales "Q"

Scenario: Etiqueta de quetzales en campo "Cuenta Bancaria"
    When el usuario ingresa a la funcion "Pagar"
    And consulta el campo "Cuenta Bancaria" de la seccion de tipo de movimiento
    Then la etiqueta que se visualiza de lado derecho del campo es "Quetzales"

Scenario: Signo de quetzales en columna "Total Percepción"
    When el usuario ingresa a la funcion "Total Percepción"
    And consulta la columna "Total Percepción"
    Then el importe en moneda nacional del campo se visualizan con el signo de quetzales "Q"

Scenario: Mantener comportamiento actual del proceso para bases de datos de México
  Given que el usuario accede al proceso "prenomina" del módulo de nominas en una base de datos de México
  When consulte el proceso
  Then el Proceso no debe de presentar ningun cambio referente a la tropicalizacion
  And el Proceso  debe conservar su funcionamiento actual sin afectaciones

Scenario: El reporte es visible en base de datos de guatemala.
  Given que el Proceso ya se encuentra tropicalizado para el sistema de guatemala.
  When el usuario entre a una base de datos configurada con el pais de guatemala.
  Then el sistema debera de mostrar el Proceso "prenomina" en el listado de Procesos del modulo de nominas