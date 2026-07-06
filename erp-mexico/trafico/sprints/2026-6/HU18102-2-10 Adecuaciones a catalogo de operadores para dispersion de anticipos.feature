Feature: Adecuar catálogo de operadores para dispersión de anticipos
  Como usuario de tráfico
  Necesito especificar informacion especifica para operadores
  Para que al momento de generar una dispersión por anticipo cuenten con la información necesaria
  
  Scenario: Adecuar campos en Información general del catalogo de operadores
    Given el usuario se encuenta agregando o editando la información de un operadores
    When vaya a la seccion Información bancaria de la pestaña Información general
    Then el sistema debe presentar la siguientes datos:
      | campo           | tipo adecuación                            | tipo     | permite          | max |
      | Cuenta CLABE    | Cambio de nombre a  Cuenta bancaria/CLABE  | Númerico | Números enteros  | 18  |
      | ID BANORTE      | Nuevo campo                                | Númerico | Letras y numeros | 13  |
   And el campo ID BANORTE debe tener un indicador 
   And al pasar el cursor sobre el muestra el siguiente mensaje:
   """
     Dato requerido para la generación de dispersión de anticipos para banco BANORTE
   """

   Scenario: Incluir datos modificados en Reporte detallado de operadores
     Given el usuario solicita Imprimir la información del catálogo de operadores
     When el sistema genera el Reporte
     Then incluye los datos:
       | Cuenta bancaria/CLABE |
       | ID BANORTE            |
    And los ubica despues de la columna banco

  Scenario: Incluir datos modificados al exportar a excel el Reporte detallado de operadores
     Given el usuario solicita exportar a Excel el reporte detallado de operadores
     When el sistema genera el Reporte
     Then incluye los datos:
       | Cuenta bancaria/CLABE |
       | ID BANORTE            |
    And los ubica despues de la columna banco

  Scenario: Incluir datos modificados al exportar a PDF el Reporte detallado de operadores
     Given el usuario solicita exportar a PDF el reporte detallado de operadores
     When el sistema genera el Reporte
     Then incluye los datos:
       | Cuenta bancaria/CLABE |
       | ID BANORTE            |
    And los ubica despues de la columna banco