Feature: Configuración del Concepto de Facturación como Séptimo Día
  Como administrador del catálogo de conceptos de facturación
  Quiero poder marcar un concepto como "concepto de séptimo día"
  Para que el sistema sepa qué concepto usar al generar los cobros automáticos

  Background:
    Given el usuario tiene permisos para modificar el catálogo de conceptos de facturación
    And la pantalla de alta o modificación de un concepto está abierta
    And La base de datos no esta configurada con el pais México o Estados Unidos.

  # ─── MARCADO DEL CONCEPTO ───

  Scenario: Marcar un concepto como séptimo día cuando ningún otro concepto lo está
    Given ningún otro concepto de facturación está marcado como séptimo día
    When el usuario marca la casilla "Concepto de séptimo día"
    And completa todos los campos obligatorios del concepto
    And guarda el concepto
    Then el concepto queda marcado como "séptimo día"
    And el sistema muestra el mensaje "Se agregó/modificó el concepto de facturación correctamente"

  Scenario: Marcar un concepto como séptimo día cuando YA EXISTE otro concepto marcado
    Given el concepto "FLETE ESPECIAL" ya está marcado como séptimo día
    When el usuario intenta marcar la casilla "Es concepto de séptimo día" en un concepto diferente
    And guarda el concepto
    Then el sistema muestra el mensaje "Ya existe el concepto [FLETE ESPECIAL] configurado como séptimo día. Solo un concepto puede tener esta configuración"
    And el concepto que se intentó marcar NO se guarda como séptimo día


  Scenario: Desmarcar un concepto que actualmente es el séptimo día
    Given el concepto actual está marcado como séptimo día
    When el usuario desmarca la casilla "Es concepto de séptimo día"
    And guarda los cambios
    Then el concepto deja de ser el concepto de séptimo día
    And a partir de ese momento, el sistema no generará cobros de séptimo hasta que se configure otro concepto

  # ─── VALIDACIONES ───

  Scenario: Marcar un concepto inactivo como séptimo día
    Given el concepto de facturación está marcado como "Inactivo"
    When el usuario intenta marcar la casilla "Es concepto de séptimo día"
    Then el sistema muestra el mensaje "No es posible marcar un concepto inactivo como séptimo día. Active el concepto primero"
    And la casilla no puede marcarse

  Scenario: Cancelar el marcado del concepto
    Given ningún concepto está marcado como séptimo día
    When el usuario marca la casilla "Es concepto de séptimo día"
    And cierra la pantalla sin guardar (cancela)
    Then ningún concepto queda marcado como séptimo día