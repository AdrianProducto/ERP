Feature: Generación automática de retención 0% para Guatemala

  Como usuario del sistema en bases de datos de Guatemala
  Quiero que exista una retención del 0% configurada por defecto
  Para facilitar la configuración inicial de impuestos en el sistema

  Background: 
    Given que se genera una nueva base de datos configurada para el país "Guatemala"
    
  Scenario: Crear retención 0% por defecto en el catálogo de impuestos
    When el sistema crea la configuración inicial del catálogo de impuestos
    Then deberá generarse automáticamente una retención con porcentaje "0%"
    And la retención deberá quedar registrada en el catálogo de impuestos

  Scenario: Visualizar la retención 0% en nuevas bases de datos
    When el usuario consulta el catálogo de impuestos
    Then deberá visualizar la retención del "0%" generada por defecto

  Scenario: Mostrar la retención 0% en el campo "Retención IVA" de parámetros generales
    Given que existe la retención del "0%" creada por defecto
    When el usuario ingresa al módulo de configuración en la sección de parámetros generales
    Then el campo "Retención IVA" deberá mostrar seleccionada la retención del "0%"

Scenario: Utilizar la retención 0% en la configuración de conceptos de facturación
    Given que existe una retención con porcentaje "0%" en el catálogo de impuestos
    When el usuario crea o edita un concepto de facturación
    Then el sistema deberá permitir seleccionar la retención del "0%" en la configuración del concepto
    And la retención deberá guardarse correctamente en el concepto de facturación