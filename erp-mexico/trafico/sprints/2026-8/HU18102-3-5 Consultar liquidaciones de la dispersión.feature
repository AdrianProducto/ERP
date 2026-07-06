Feature: Consultar liquidaciones de la dispersión
  Como usuario de tráfico
  Necesito poder consultar las liquidaciones relacionadas a una dispersión existentes
  Para poder determinar si es necesario agregar o eliminar liquidaciones

  Scenario: Mostrar liquidaciones relacionadas a la dispersión
    Given existen dispersiones registradas
    When el usuario solicita consultar las liquidaciones relacionados
    Then el sistema muestra a manera de consulta la información relacionada a la dispersión:
      | Descripción     |
      | Fecha           |
      | Banco           |
      | Cuenta Bancaria | 
    And enlista las liquidaciones relacionadas a la dispersion mostrando por cada una:
      | Folio         |
      | Operador      |
      | Fecha inicial |
      | Fecha final   |
      | Importe       |
      | Moneda        |
    And presenta la opcion de cerrar la consulta

  Scenario: Cerrar la consulta
    Given el usuario se encuentra consultando las liquidaciones de una dispersión
    And presiona el boton "Cerrar"
    Then cierra la consulta
    And regresa al listado de dispersiones 