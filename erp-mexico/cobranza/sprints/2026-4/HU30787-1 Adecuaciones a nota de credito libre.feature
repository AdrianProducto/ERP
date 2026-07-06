Feature: Adecuaciones a nota de crédito libre
  Como usuario del módulo de Cobranza
  Quiero que la nota de crédito libre cambie de nombre a nota de crédito PEMEX
  Para que haga sentido con la operación para facturas pemex

  Scenario: Cambio de nombre a botón nota de crédito libre
    Given el usuario cuenta con los permisos correspondientes
    And accede al modulo de Cobranza
    And accede al listado de Notas de crédito
    When despliega las opciones del boton "Agregar"
    Then debe mostrar las siguientes:
      | opciones              |
      | Nota de crédito       |
      | Nota de crédito PEMEX |

  Scenario: Cambio de nombre a proceso nota de crédito libre
    Given el usuario cuenta con los permisos correspondientes
    And accede al modulo de Cobranza
    And se encuentra en el listado de Notas de crédito
    When selecciona el proceso agregar Nota de crédito PEMEX
    Then debe mostrar en el titulo de la ventana "Agregando Nota de Crédito PEMEX"

  Scenario: Actualización en derechos de usuario
      Given el usuario se encuentra asignando derechos a un usuario del sistema
      And accede al modulo de Cobranza
      When selecciona el proceso Notas de Crédito
      Then debe mostrarse el proceso "Nota de crédito PEMEX" en lugar de "Nota de crédito libre"

  Scenario: Actualización en bitácora de procesos
      Given el usuario se encuentra consultando la bitacora de procesos
      And accede al proceso de Cobranza
      When selecciona el proceso Notas de Crédito
      Then debe mostrarse el proceso "Nota de crédito PEMEX" en lugar de "Nota de crédito libre"
  
  Scenario: Ocultar parámetro de configuración
      Given que el usuario accede a los Parametros generales de Cobranza
      When busca el parámetro "Configurar conceptos equivalentes para nota de crédito libre"
      Then el parámetro no debe estar disponible para visualización ni edición

    Scenario: Desactivación automática del parámetro
      Given que existen clientes con el parámetro "Configurar conceptos equivalentes para nota de crédito libre" activo
      When se implementa el cambio
      Then el sistema debe desactivar automáticamente el parámetro
      And no debe afectar otros parámetros ni configuraciones del cliente







