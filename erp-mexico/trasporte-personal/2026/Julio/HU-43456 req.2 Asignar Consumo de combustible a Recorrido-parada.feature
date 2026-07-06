Feature: Importación de Consumos de Combustible para Transporte de Personal
  Como usuario administrador del módulo de Transporte de Personal 
  Quiero importar consumos de combustible desde archivo, asignarlos a recorridos y generar gastos
  Para poder controlar el gasto de combustible por unidad y vincularlo a las liquidaciones de operadores

@TPersonal @Combustible @Asignacion @HappyPath
  Scenario: Asignar consumo de combustible a un recorrido/parada
    Given el consumo IdConsumoCombustibleTPersonal = 1 está pendiente (IdRecorridoParada = NULL)
    And la unidad 25 del consumo tiene un recorrido activo el 15/06/2026
    And existe ProRecorridoParadas.IdRecorridoParada = 100 para esa unidad y fecha
    When el usuario selecciona el consumo 1 en PAGE_ProConsumosCombustibleTPersonalAsignar
    And el usuario selecciona el recorrido/parada 100
    And el usuario hace clic en BTN_Asignar
    Then el sistema actualiza IdRecorridoParada = 100 en ProConsumosCombustibleTPersonal
    And el sistema registra la fecha/hora de asignación
    And el sistema muestra "Consumo asignado correctamente al recorrido"

  @TPersonal @Combustible @Asignacion @Validation
  Scenario: Rechazar reasignación de consumo ya asignado
    Given el consumo 2 ya tiene IdRecorridoParada = 50
    When el usuario intenta asignarlo a otro recorrido
    Then el sistema muestra "El consumo ya está asignado al recorrido 50"
    And el sistema NO modifica el registro

  @TPersonal @Combustible @Asignacion @Validation
  Scenario: Validar que la unidad del consumo coincida con la unidad del recorrido
    Given el consumo 3 tiene IdUnidad = 25
    And el recorrido/parada 200 tiene IdUnidadCamion = 30
    When el usuario intenta asignar el consumo al recorrido/parada 200
    Then el sistema muestra "La unidad del consumo (25) no coincide con la unidad del recorrido (30)"
    And el sistema NO asigna el consumo