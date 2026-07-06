Feature: Consultar anticipos de la dispersión
  Como usuario de tráfico
  Necesito poder consultar los anticipos relacionados a una dispersión existentes
  Para poder determinar si es necesario agregar o eliminar anticipos

  Scenario: Mostrar anticipos relacionados a la dispersión
    Given existen dispersiones registradas
    When el usuario solicita consultar los anticipos relacionados
    Then el sistema muestra a manera de consulta la información relacionada a la dispersión:
      | Descripción     |
      | Fecha           |
      | Banco           |
      | Cuenta Bancaria | 
    And enlista los anticipos relacionados a la dispersion mostrando por cada uno:
      | Folio    |
      | Fecha    |
      | Operador |
      | Importe  |
      | Moneda   |
      | Concepto |
    And presenta las opciones:
      | Agregar anticipos   |
      | Desasociar anticipo |
      | Guardar cambios     |
      | Cancelar            |
  
  Scenario: Relacionar nuevos anticipos a la dispersión
    Given existen nuevos anticipos agregados a la dispersión
    When el usuario presiona el boton "Aceptar"
    Then el sistema crea la relación entre los nuevos anticipos con la dispersión actual
    And genera nuevamente el archivo de dispersión
    And realiza la descarga automática en el equipo del usuario

  Scenario: Desasociar anticipos de la dispersión
    Given existen anticipos eliminados temporalmente de la dispersión
    When el usuario presiona el boton "Aceptar"
    Then el sistema elimina la relación entre los dichos anticipos y la dispersión actual
    And genera nuevamente el archivo de dispersión
    And realiza la descarga automática en el equipo del usuario

  Scenario: Cancelar consulta
    Given el usuario se encuentra consultando los anticipos de una dispersión
    And presiona el boton "Cancelar"
    Then el sistema no realiza ningun cambio en la dispersion consultada
    And regresa al listado de dispersiones 