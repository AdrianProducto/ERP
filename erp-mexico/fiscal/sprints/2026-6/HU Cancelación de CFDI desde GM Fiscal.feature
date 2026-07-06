# Característica
Feature: Cancelación de CFDI desde GM Fiscal
  Como usuario de GM Fiscal
  Quiero iniciar y monitorear la cancelación de un CFDI
  Para reflejar su estatus real y su impacto operativo dentro del ERP

  Background:
    Given que GM Fiscal puede consultar el estatus de cancelación con SAT o PAC
    And que el ERP contiene registros asociados al CFDI

  Scenario Outline: Sincronizar correctamente una cancelación confirmada
    Given que el CFDI <uuid_cfdi> fue enviado a cancelación
    And que el SAT o PAC responde con estatus <estatus_cancelacion>
    When el sistema sincroniza el resultado de la cancelación
    Then el CFDI queda con estatus <estatus_final> en GM Fiscal
    And el ERP refleja el impacto operativo correspondiente
    And se registran notificaciones del cambio de estatus

    Examples:
      | uuid_cfdi | estatus_cancelacion | estatus_final |
      | CFDI-001  | cancelado           | cancelado     |
      | CFDI-002  | cancelado con aceptación | cancelado |

  Scenario: Considerar CFDI sustituto cuando aplica una cancelación
    Given que el CFDI original fue cancelado por sustitución
    And que existe un CFDI sustituto válido
    When el sistema actualiza el estatus del CFDI cancelado
    Then relaciona el CFDI original con el CFDI sustituto
    And muestra la trazabilidad entre ambos documentos

  Scenario Outline: Mantener comportamiento controlado cuando la cancelación no está concluida
    Given que el CFDI presenta el estado <estado_cancelacion>
    When el sistema consulta el estatus de cancelación
    Then el CFDI no impacta aún al ERP como cancelado
    And muestra el mensaje <mensaje_esperado>

    Examples:
      | estado_cancelacion | mensaje_esperado                                            |
      | en proceso         | La cancelación sigue en proceso y aún no impacta al ERP     |
      | rechazada          | La cancelación fue rechazada por SAT o PAC                  |
      | fuera de ventana   | El CFDI no puede cancelarse dentro de la ventana operativa  |

  Scenario: Iniciar el proceso de cancelación desde GM Fiscal
    Given que el usuario tiene acceso a GM Fiscal
    And que el CFDI existe y está en estatus vigente
    When el usuario solicita cancelar el CFDI desde GM Fiscal
    Then el sistema envía la solicitud de cancelación al SAT o PAC
    And el CFDI queda en estado en proceso de cancelación
    And se registra la fecha y hora del inicio de la solicitud

  Scenario Outline: Validar ventana operativa antes de permitir la cancelación
    Given que el CFDI fue timbrado hace <tiempo_transcurrido>
    When el usuario solicita cancelar el CFDI
    Then el sistema responde con <resultado_validacion>
    And muestra el mensaje <mensaje_esperado>

    Examples:
      | tiempo_transcurrido | resultado_validacion | mensaje_esperado                                                    |
      | menos de 24 horas   | permitido            | La cancelación puede realizarse sin aceptación del receptor         |
      | entre 24 y 72 horas | permitido con aviso  | La cancelación requiere aceptación del receptor dentro del plazo    |
      | más de 72 horas     | bloqueado            | El CFDI no puede cancelarse fuera de la ventana operativa permitida |

  Scenario: Notificar al usuario cuando una factura cambia a estado cancelado
    Given que el sistema detecta que un CFDI cambió su estatus a cancelado en SAT
    When se registra el cambio de estatus
    Then el sistema genera una notificación al usuario responsable
    And muestra el CFDI actualizado con estatus cancelado en GM Fiscal

