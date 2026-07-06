# Característica
Feature: Validar integración de Conciliación de Ingresos, Egresos, Pagos y Traslados con la Bóveda Fiscal
  Como usuario de GM Fiscal
  Quiero ejecutar la conciliación fiscal de Ingresos, Egresos, Pagos y Traslados usando la Bóveda Fiscal de Unikasoft
  Para asegurar que la consulta, visualización, filtros, totales y resultados funcionen correctamente en el front

  # Antecedentes
  Background:
    # Dado
    Given que GM Fiscal ya se encuentra integrado con la Bóveda Fiscal de Unikasoft
    # Y
    And que el usuario tiene permisos para consultar conciliaciones fiscales
    # Y
    And que existen datos fiscales disponibles en ERP y/o Bóveda para el periodo consultado

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  # Esquema del escenario
  Scenario Outline: Ejecutar exitosamente la conciliación fiscal por tipo de CFDI con datos válidos de la Bóveda
    # Dado
    Given que el tipo de conciliación es <tipo_conciliacion>
    # Y
    And que el periodo consultado es <periodo>
    # Y
    And que la respuesta de la Bóveda para el tipo CFDI es <respuesta_boveda>
    # Cuando
    When el usuario ejecuta la conciliación fiscal
    # Entonces
    Then el sistema muestra los registros de <tipo_conciliacion> obtenidos desde la Bóveda
    # Y
    And calcula correctamente los totales de la conciliación
    # Y
    And aplica correctamente los filtros por <filtro_aplicado>
    # Y
    And muestra el estatus de conciliación como <resultado_conciliacion>

    # Ejemplos
    Examples:
      | tipo_conciliacion | periodo   | respuesta_boveda | filtro_aplicado | resultado_conciliacion |
      | Ingresos          | 2026-03   | Válida           | RFC             | Coincidencias          |
      | Egresos           | 2026-03   | Válida           | UUID            | Diferencias            |
      | Pagos             | 2026-03   | Válida           | Estatus         | Coincidencias          |
      | Traslados         | 2026-03   | Válida           | Tipo CFDI       | No encontrados         |

  # ESCENARIO 2: LO QUE NO PASA (ERRORES Y VALIDACIONES / SEGURIDAD)

  # Esquema del escenario
  Scenario Outline: Mostrar mensajes controlados cuando la conciliación fiscal presenta errores o datos no válidos
    # Dado
    Given que el tipo de conciliación es <tipo_conciliacion>
    # Y
    And que la respuesta de la Bóveda para la consulta es <respuesta_boveda>
    # Cuando
    When el usuario ejecuta la conciliación fiscal
    # Entonces
    Then el sistema responde con <mensaje_esperado>
    # Y
    And no rompe la vista de conciliación
    # Y
    And registra la incidencia funcional como <tipo_incidencia>

    # Ejemplos
    Examples:
      | tipo_conciliacion | respuesta_boveda | mensaje_esperado                                 | tipo_incidencia      |
      | Ingresos          | Vacía            | No se encontraron CFDI para los filtros capturados | Sin información    |
      | Egresos           | Timeout          | Ocurrió un problema al consultar la Bóveda Fiscal | Comunicación       |
      | Pagos             | Inválida         | La información recibida de la Bóveda es inválida  | Mapeo de datos     |
      | Traslados         | Error 500        | No fue posible completar la conciliación fiscal   | Error de servicio  |

  Scenario: Validar la estructura funcional esperada de la conciliación fiscal en el front
    # Dado
    Given que el módulo de conciliación fiscal consume información de la Bóveda Fiscal
    # Cuando
    When se valida la estructura funcional de la pantalla y el resultado de conciliación
    # Entonces
    Then la estructura debe cumplir con la siguiente definición
      """
      Tipos de conciliación soportados:
      - Ingresos
      - Egresos
      - Pagos
      - Traslados

      Validaciones funcionales mínimas:
      - Consulta por periodo
      - Filtro por RFC
      - Filtro por UUID
      - Filtro por estatus
      - Filtro por tipo CFDI
      - Visualización de resultados
      - Totales correctos
      - Coincidencias, diferencias y no encontrados
      - Manejo de respuesta vacía
      - Manejo de timeout y errores del servicio
      """
      