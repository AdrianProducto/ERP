Feature: Liquidación masiva de trayectos

  Background:
    Given que el usuario cuenta con el derecho para ejecutar la liquidación masiva
    And no existe el parámetro "Liquidaciones masivas"

  Scenario: Aplicar filtros y tipo de liquidación
    Given el usuario ingresa a la utilería
    When aplica los filtros de búsqueda
    Then se asigna el tipo de liquidación seleccionado
    And se muestra por default el tipo configurado en parámetros "Tipo de liquidación por default"

  Scenario: Visualización de operadores y trayectos
    Given que se aplicaron los filtros
    Then se muestran únicamente operadores con trayectos dentro del rango
    And todos los trayectos aparecen seleccionados por default
    When el usuario desmarca trayectos
    Then solo los trayectos seleccionados serán liquidados

  Scenario: Confirmación de cierre de liquidaciones al ejecutar el proceso
    When se ejecuta el proceso
    Then el sistema muestra el mensaje "¿Desea cerrar las liquidaciones?"
    
    When el usuario selecciona "Sí"
    Then se cierran todas las liquidaciones válidas
    And las liquidaciones con importes negativos o cero permanecen abiertas
    And se muestra el mensaje "Existen trayectos que no fueron liquidados, favor de revisar bitácora del proceso"

    When el usuario selecciona "No"
    Then todas las liquidaciones se generan en estatus abiertas

  Scenario: Validación de importes negativos o cero
    Given una liquidación genera importes negativos o en cero
    Then la liquidación se genera pero permanece abierta
    And se registra en bitácora el mensaje "No se puede cerrar liquidación, ya que cuenta con importes negativos o en cero"

  Scenario: Ejecución del proceso de liquidación
    When el usuario ejecuta la utilería
    Then el sistema realiza las validaciones del proceso de liquidación
    And calcula automáticamente por trayecto:
      | Rendimiento |
      | Horómetro |
      | Odómetro |
      | KM reales |
      | Utilidad |
      | Productividad |

  Scenario: Manejo de anticipos y gastos
    Given existen anticipos y gastos en el trayecto
    Then se suman los anticipos
    And se suman los gastos
    And se calcula la diferencia entre anticipos y gastos
    And se registra como deducción con el concepto "Diferencia de gastos"

  Scenario: Manejo de gastos acumulados y crédito
    Then los gastos acumulados se procesan normalmente
    And la diferencia se envía a "Diferencia de gastos"
    And los gastos a crédito se mantienen informativos
    And no afectan anticipos
    And se consideran litros para rendimiento cuando aplique

  Scenario: Aplicación de descuentos
    Given múltiples trayectos en una liquidación
    Then los descuentos por liquidación se aplican una sola vez

  Scenario: Generación de bitácora
    When finaliza el proceso
    Then se genera una bitácora detallada en archivo Excel
    And incluye los trayectos liquidados y no liquidados
    And muestra el motivo en la columna "Detalle" en el caso de los no liquidados
    And contiene las columnas:
      | Operador |
      | Liquidación |
      | Viaje |
      | Carta Porte |
      | Cliente |
      | No. Viaje Cliente |
      | Trayecto |
      | Neto a pagar |
      | Detalle |

  Scenario: Comportamiento de la interfaz
    When el usuario actualiza los filtros
    Then la ventana mantiene su posición y tamaño