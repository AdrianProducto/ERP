# Característica
# HU35524 - Código de unidad en registro de falla
@ReporteFalla
Feature: Mostrar código y nombre de unidad al seleccionarla en el registro de falla

  Como operador de la App Móvil "Mis Viajes"
  Quiero ver el código concatenado con el nombre de la unidad al seleccionarla en el reporte de falla
  Para identificar con precisión la unidad reportada

  # Nota técnica: el código de unidad se obtiene de SELECT Codigo FROM CatUnidades

  # Antecedentes
  # HU35524
  Background:
    # Dado
    Given que el operador está en el paso "Selección de Unidad" del registro de falla

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  # HU35524
  @happy_path
  Scenario: La unidad tiene código asignado y se muestra concatenado al seleccionarla
    # Dado
    Given que la unidad cuenta con CodigoUnidadCamion y nombre registrados
    # Cuando
    When el operador selecciona la unidad desde el buscador
    # Entonces
    Then los resultados del buscador muestran el código y el nombre concatenados
    # Y
    And al confirmar la selección el mensaje inferior muestra "Unidad seleccionada: [CÓDIGO] – [NOMBRE]"
      """
      Ejemplo: "Unidad seleccionada: REM-001 – REMOLQUE LUIS"
      """

  # HU35524
  @validacion
  Scenario: La unidad no tiene código registrado
    # Dado
    Given que la unidad no cuenta con un valor en CodigoUnidadCamion
    # Cuando
    When el operador selecciona esa unidad desde el buscador
    # Entonces
    Then el mensaje inferior muestra "Unidad seleccionada: [NOMBRE]"
    # Y
    And no debe mostrar guiones ni espacios vacíos donde iría el código
