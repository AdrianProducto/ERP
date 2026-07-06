Feature: Asignar Consumo de Combustible a Recorrido/Parada
  Como usuario del módulo de Transporte de Personal
  Quiero asignar un consumo importado a un recorrido/parada específico
  Para vincular el gasto de combustible a la ruta y operador correctos

  Background:
    Given el usuario está en la página de listado de consumos de combustible
    And el usuario tiene permiso para asignar recorridos
    And existe al menos un consumo pendiente de asignar en el listado

  @Asignacion @VentanaEmergente
  Scenario: La ventana emergente "Asignar Recorrido/Parada" muestra los datos del consumo y el selector de recorridos
    Given el usuario selecciona un consumo pendiente en el listado
    When el usuario hace clic en el botón "Asignar Recorrido"
    Then el sistema abre una ventana emergente titulada "Asignar Recorrido/Parada"
    And la ventana muestra los datos del consumo en modo solo lectura:
      | Campo                  |
      | Tarjeta de combustible |
      | Fecha y hora           |
      | Número de comprobante  |
      | Litros                 |
      | Odómetro               |
      | Subtotal               |
      | IVA                    |
      | Total                  |
      | Código de unidad       |
      | Descripción de unidad  |
      | Número de proveedor    |
      | Nombre de proveedor    |
    And la ventana muestra un selector de recorridos disponibles
    And la ventana muestra el botón "Aceptar" y el botón "Cancelar"
    And el selector de recorridos solo muestra recorridos activos, no cancelados, no finalizados y sin liquidación cerrada para la unidad del consumo

  @Asignacion @VentanaEmergente
  Scenario: Al seleccionar un recorrido en la ventana emergente se auto-carga el operador
    Given la ventana "Asignar Recorrido/Parada" está abierta mostrando un consumo pendiente
    When el usuario selecciona un recorrido en el selector
    Then el sistema auto-carga el número del operador del recorrido seleccionado
    And el sistema auto-carga el nombre del operador del recorrido seleccionado

  @Asignacion @HappyPath
  Scenario: Asignar consumo de combustible a un recorrido exitosamente desde la ventana emergente
    Given el consumo 1 está pendiente de asignar
    And la unidad 25 del consumo tiene un recorrido activo el 15/06/2026
    And el recorrido 100 existe para esa unidad y fecha
    And la liquidación del recorrido 100 no está cerrada
    When el usuario selecciona el consumo 1 en el listado y hace clic en "Asignar Recorrido"
    And en la ventana emergente el usuario selecciona el recorrido 100
    And el usuario hace clic en "Aceptar"
    Then la ventana emergente se cierra
    And el sistema asigna el recorrido 100 al consumo 1
    And el sistema registra la fecha y hora de asignación
    And el listado se actualiza mostrando el recorrido asignado
    And el sistema muestra el mensaje "Consumo asignado correctamente al recorrido"

  @Asignacion @Cancelacion
  Scenario: Cancelar la asignación desde la ventana emergente
    Given la ventana "Asignar Recorrido/Parada" está abierta
    When el usuario hace clic en "Cancelar"
    Then la ventana emergente se cierra sin realizar cambios
    And el consumo permanece sin asignar

  @Asignacion @Validacion
  Scenario: Advertir cuando los litros del consumo exceden los litros autorizados de la ruta
    Given el consumo 3 tiene 150 litros
    And la ruta del recorrido 300 tiene autorizados 120 litros
    And el consumo supera los litros autorizados
    When el usuario intenta asignar el consumo 3 al recorrido 300
    Then el sistema muestra la advertencia "Los litros del consumo (150) exceden los autorizados para la ruta (120)"
    And el sistema permite continuar con la asignación si el usuario lo confirma

  @Asignacion @Bitacora
  Scenario: Registrar en bitácora la asignación del consumo
    Given el consumo 7 está pendiente de asignar
    And el recorrido 700 es válido para asignación
    When el usuario asigna el consumo 7 al recorrido 700
    Then el sistema registra en la bitácora la acción de asignación