Feature: Cierre de periodos de nómina con recibos no calculados

  Como usuario de Nómina
  Quiero una utilería que permita marcar recibos no calculados como calculados
  Para poder cerrar el periodo de nómina sin la necesidad de hacerlo individualmente

  Background:
    Given que existen periodos de nómina con recibos asociados
    And algunos recibos pueden estar en estatus no calculado
    And el usuario accede a la utilería 'Cierre de periodos de nómina con recibos no calculados'

  Scenario: Visualización de filtros de la utilería
    Given que el usuario cuenta con derecho y accede a la utilería
    Then visualiza los filtros disponibles:
      | Tipo de periodo |
      | Ejercicio | 
      | Periodo |
    And visualiza el botón "Aceptar"

  Scenario: Confirmación antes de ejecutar el proceso
    Given que el usuario selecciona un Tipo de periodo y un Periodo
    When presiona el botón "Aceptar"
    Then se muestra el mensaje de confirmación:
      """
      ¿Deseas marcar todos los recibos del periodo como calculados?, esta acción no se puede deshacer.
      """

  Scenario: Ejecución del proceso masivo de cálculo de recibos
    Given que el usuario confirma la ejecución del proceso
    And existen recibos no calculados en el periodo seleccionado
    When se ejecuta el proceso
    Then todos los recibos no calculados se actualizan a estatus "Calculado"
    And los recibos previamente calculados no se modifican

  Scenario: Cierre automático del periodo
    Given que todos los recibos del periodo están en estatus "Calculado"
    When finaliza la actualización de recibos
    Then el periodo de nómina se marca como "Cerrado"
    And se registra la póliza correspondiente al periodo cerrado

  Scenario: Bloqueo por finiquitos pendientes
    Given que existen recibos de tipo finiquito no aplicados en el periodo seleccionado
    When el usuario intenta ejecutar el proceso
    Then no se permite cerrar el periodo
    And se muestra el mensaje:
      """
      Existen finiquitos pendientes de aplicar. Es necesario aplicar los finiquitos para cerrar el periodo.
      """

  Scenario: Ejecución completa del proceso desde el botón Aceptar
    Given que el usuario selecciona los filtros requeridos
    And no existen bloqueos por validaciones
    When presiona el botón "Aceptar" y confirma la acción
    Then se ejecuta en un solo flujo:
      | Marcado de recibos como calculados |
      | Cierre del periodo |
      | Bitacora de procesos | 
    And se muestran los siguientes mensajes en bitacora:
      | ENTRA PAGINA A CIERRE DE PERIODOS DE NÓMINA CON RECIBOS NO CALCULADOS |
      | SALIO SIN GRABAR PAGINA CIERRE DE PERIODOS DE NÓMINA CON RECIBOS NO CALCULADOS |
      | ACEPTO/GRABO PAGINA CIERRE DE PERIODOS DE NÓMINA CON RECIBOS NO CALCULADOS (TIPO PERIODO + PERIODO) |