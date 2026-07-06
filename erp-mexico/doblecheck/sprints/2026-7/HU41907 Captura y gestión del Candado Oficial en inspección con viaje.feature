@candadoOficial @HU-HU41907
# HU41907: Captura y gestión del Candado Oficial en inspección con viaje

Feature: Captura y gestión del Candado Oficial en inspección con viaje

Como usuario de DobleCheck,
Quiero capturar o visualizar el Candado Oficial al registrar una inspección con viaje asociado,
Para que el dato quede registrado en la inspección y sea visible en el PDF generado.

  Background:
    Given que el usuario ha iniciado sesión en DobleCheck
    And el usuario tiene un formulario de inspección asignado
    And el formulario requiere selección de viaje

  # ─────────────────────────────────────────────
  # AC-1: APERTURA DEL CAMPO AL SELECCIONAR VIAJE
  # ─────────────────────────────────────────────

  Scenario: El campo Candado Oficial se habilita al seleccionar un viaje
    Given que el usuario está en el formulario de nueva inspección
    And el campo "Candado Oficial" está oculto o deshabilitado
    When el usuario selecciona un viaje de la lista
    Then el campo "Candado Oficial" debe ser visible y editable

  Scenario: El campo Candado Oficial no se muestra si no hay viaje seleccionado
    Given que el usuario está en el formulario de nueva inspección
    And no hay ningún viaje seleccionado
    Then el campo "Candado Oficial" no debe ser visible

  # ─────────────────────────────────────────────
  # AC-2: PRECARGA DEL VALOR EXISTENTE
  # ─────────────────────────────────────────────

  Scenario: Se precarga el Candado Oficial si el viaje ya tiene uno registrado
    Given que el usuario selecciona el viaje con folio "VJ-2025-001"
    And ese viaje tiene "CandadoOficial" = "CO-45821" en el ERP
    When el campo "Candado Oficial" se habilita
    Then el campo debe mostrar automáticamente el valor "CO-45821"

  Scenario: El campo queda vacío si el viaje no tiene Candado Oficial registrado
    Given que el usuario selecciona el viaje con folio "VJ-2025-002"
    And ese viaje tiene "CandadoOficial" = null en el ERP
    When el campo "Candado Oficial" se habilita
    Then el campo debe estar vacío y disponible para captura

  # ─────────────────────────────────────────────
  # AC-3: MODIFICACIÓN DE VALOR EXISTENTE
  # ─────────────────────────────────────────────

  Scenario: El usuario modifica el Candado Oficial precargado
    Given que el campo "Candado Oficial" muestra el valor precargado "CO-45821"
    When el usuario borra el valor y escribe "CO-99999"
    And completa y envía la inspección
    Then la inspección se guarda con "CandadoOficial" = "CO-99999"
    And el PDF generado muestra "Candado Oficial: CO-99999"

  # ─────────────────────────────────────────────
  # AC-4: CAPTURA DE VALOR NUEVO
  # ─────────────────────────────────────────────

  Scenario: El usuario captura un Candado Oficial para un viaje sin valor previo
    Given que el campo "Candado Oficial" está vacío tras seleccionar el viaje
    When el usuario escribe "CO-12345" en el campo "Candado Oficial"
    And completa y envía la inspección
    Then la inspección se guarda con "CandadoOficial" = "CO-12345"
    And el PDF generado muestra "Candado Oficial: CO-12345"

  Scenario: La inspección se guarda aunque el Candado Oficial esté vacío
    Given que el campo "Candado Oficial" está vacío tras seleccionar el viaje
    And el usuario no captura ningún valor
    When el usuario completa y envía la inspección
    Then la inspección se guarda correctamente
    And el PDF no muestra la sección de "Candado Oficial"

  # ─────────────────────────────────────────────
  # AC-5: VALIDACIÓN DEL CAMPO
  # ─────────────────────────────────────────────

  Scenario: El campo Candado Oficial acepta hasta 60 caracteres
    Given que el campo "Candado Oficial" está habilitado
    When el usuario intenta ingresar un texto de 61 caracteres
    Then el sistema debe limitar la entrada a 60 caracteres

  Scenario: El campo Candado Oficial no acepta solo espacios en blanco
    Given que el campo "Candado Oficial" está habilitado
    When el usuario ingresa solo espacios en blanco
    And envía la inspección
    Then el sistema guarda el campo como vacío

  # ─────────────────────────────────────────────
  # AC-6: REFLEJO EN EL PDF
  # ─────────────────────────────────────────────

  Scenario: El PDF muestra el Candado Oficial cuando el tipo de movimiento es "Viaje"
    Given que la inspección tiene "tipoMovimiento" = "Viaje"
    And tiene "CandadoOficial" = "CO-55500"
    When se genera el PDF de la inspección
    Then el PDF debe contener la etiqueta "Candado Oficial"
    And debe mostrar el valor "CO-55500"

  Scenario: El PDF no muestra el Candado Oficial cuando el tipo de movimiento no es "Viaje"
    Given que la inspección tiene "tipoMovimiento" = "Transferencia"
    When se genera el PDF de la inspección
    Then el PDF no debe contener la sección "Candado Oficial"

  # ─────────────────────────────────────────────
  # AC-7: EDICIÓN DE INSPECCIÓN EXISTENTE
  # ─────────────────────────────────────────────

  Scenario: Al editar una inspección existente se muestra el Candado Oficial guardado
    Given que existe una inspección guardada con "CandadoOficial" = "CO-77700"
    When el usuario abre esa inspección en modo edición
    Then el campo "Candado Oficial" debe mostrar "CO-77700"

  Scenario: El usuario puede actualizar el Candado Oficial en una inspección ya creada
    Given que existe una inspección con "CandadoOficial" = "CO-77700"
    When el usuario cambia el valor a "CO-88800"
    And guarda los cambios
    Then la inspección queda con "CandadoOficial" = "CO-88800"
    And el PDF regenerado refleja "CO-88800"

