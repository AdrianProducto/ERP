# Característica
Feature: Detección automática de pagos
  Como usuario de GM Fiscal
  Quiero identificar CFDI de tipo Pago y relacionarlos con las facturas correspondientes
  Para reflejar correctamente pagos completos o parciales dentro del ERP

  Background:
    Given que GM Fiscal puede interpretar CFDI de tipo Pago
    And que el ERP contiene facturas previamente registradas

  Scenario Outline: Detectar y aplicar automáticamente un CFDI de pago
    Given que existe un CFDI de pago con UUID <uuid_pago>
    And que el CFDI referencia a la factura <uuid_factura>
    And que el monto aplicado corresponde a un pago <tipo_pago>
    When el sistema procesa el CFDI de pago
    Then la factura <uuid_factura> queda marcada como <estatus_factura>
    And el UUID del pago queda relacionado a la factura
    And se conserva trazabilidad entre ambos CFDI

    Examples:
      | uuid_pago  | uuid_factura | tipo_pago | estatus_factura   |
      | PAGO-001   | FAC-001      | total     | pagada            |
      | PAGO-002   | FAC-002      | parcial   | parcialmente pagada |

  Scenario Outline: Mostrar validación controlada cuando el pago no puede aplicarse
    Given que el CFDI de pago presenta la condición <condicion_error>
    When el sistema intenta procesar el pago
    Then el sistema no aplica el pago en ERP
    And muestra el mensaje <mensaje_esperado>

    Examples:
      | condicion_error                     | mensaje_esperado                                           |
      | no existe factura relacionada       | No se encontró la factura relacionada para el CFDI de pago |
      | monto inconsistente                 | El monto del pago no coincide con la factura relacionada   |
      | UUID de pago ya aplicado            | El CFDI de pago ya fue procesado previamente               |
      | XML de pago inválido                | No fue posible interpretar las relaciones del CFDI de pago |
