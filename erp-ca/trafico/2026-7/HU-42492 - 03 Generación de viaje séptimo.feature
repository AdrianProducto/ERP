Feature: Generación de Viajes de Séptimo Día
  Como usuario de operaciones (tráfico)
  Quiero que al finalizar la semana se revise qué unidades cumplen la condición de trabajar de lunes a sábado
  Para que se genere automáticamente el cobro del séptimo día sin tener que calcularlo manualmente

  Background:
    Given existe al menos un cliente con el séptimo día ACTIVO y un importe configurado de $1,500.00
    And existe un concepto de facturación marcado como "séptimo día"
    And la semana actual comprende:
      | Día       | Fecha       |
      | Lunes     | 2026-06-08  |
      | Martes    | 2026-06-09  |
      | Miércoles | 2026-06-10  |
      | Jueves    | 2026-06-11  |
      | Viernes   | 2026-06-12  |
      | Sábado    | 2026-06-13  |

  # ─── CONDICIÓN CUMPLIDA ───

  Scenario: La unidad trabajó todos los días de la semana (lunes a sábado) — se genera el séptimo
    Given la unidad "ECO-001" tiene viajes registrados y NO anulados para cada día de la semana:
      | Día       | Fecha       | No. Viaje |
      | Lunes     | 2026-06-08  | V-001     |
      | Martes    | 2026-06-09  | V-002     |
      | Miércoles | 2026-06-10  | V-003     |
      | Jueves    | 2026-06-11  | V-004     |
      | Viernes   | 2026-06-12  | V-005     |
      | Sábado    | 2026-06-13  | V-006     |
    And todos los viajes pertenecen al mismo cliente que tiene activo el séptimo día
    When el usuario guarde el viaje del día sabado se debera ejecutar el proceso de "Generar séptimos de la semana"
    Then el sistema verifica que la unidad "ECO-001" tiene al menos un viaje NO anulado en cada día de lunes a sábado
    And el sistema genera un nuevo viaje que sera una copia identica al ultimo viaje registrado, con fecha del domingo 2026-06-14
    And el viaje generado contiene:
      | Dato                          | Valor                                    |
      | Cliente                       | El mismo cliente de los viajes           |
      | Observaciones                 | Viaje creado para cobro de séptimo día para unidad "ECO-001"|
      | Unidad                        | ECO-001                                  |
      | Fecha                         | Domingo 2026-06-14                       |
      | Concepto de facturación       | El concepto marcado como séptimo día     |
      | Importe                       | $1,500.00 (según configuración del cliente) |
      | Cantidad                      | 1                                        |
      | Estado                        | Pendiente de facturar                    |
    And el sistema muestra el mensaje "GM Transport", "Se generó el viaje de séptimo día [NÚMERO] para la unidad ECO-001 por $1,500.00"

  # ─── CONDICIÓN NO CUMPLIDA ───

  Scenario: La unidad NO trabajó el lunes (falta un día)
    Given la unidad "ECO-001" tiene viajes de martes a sábado, pero NO tiene ningún viaje el lunes
    When el sistema detecta que la unidad no trabajó el lunes
    Then el sistema NO genera ningún viaje de séptimo para "ECO-001"

  Scenario: La unidad trabajó todos los días pero uno de los viajes está anulado
    Given la unidad "ECO-001" tiene un viaje el miércoles, pero ese viaje está ANULADO
    And tiene viajes activos los demás días de la semana
    Then el sistema NO considera el viaje anulado del miércoles
    And al no tener un viaje activo el miércoles, el sistema NO genera el viaje de séptimo

  Scenario: El cliente no tiene activada la configuración de séptimo día
    Given la unidad "ECO-001" tiene viajes de lunes a sábado
    But el cliente asociado a esos viajes NO tiene activo el séptimo día
    Then el sistema detecta que el cliente no participa en el cálculo
    And el sistema NO genera el viaje de séptimo

  Scenario: No existe un concepto de facturación marcado como séptimo día
    Given la unidad "ECO-001" cumple la condición de lunes a sábado
    And el cliente tiene activo el séptimo día
    But ningún concepto de facturación está marcado como séptimo día
    Then el sistema NO genera el viaje de séptimo

  Scenario: Ya existe un viaje de séptimo generado previamente para esta unidad en la misma semana
    Given ya se generó un viaje de séptimo para "ECO-001" en la semana 24/2026
    Then el sistema detecta que ya existe un séptimo para "ECO-001" en esta semana
    And el sistema NO genera un viaje duplicado

  # ─── SIN RESULTADOS ───

  Scenario: Ninguna unidad cumple la condición en la semana
    Given ninguna unidad tiene viajes de lunes a sábado en la semana actual
    Then el sistema muestra el mensaje "GM Transport", "No se encontraron unidades que cumplan la condición para generar séptimos en la semana 24/2026"