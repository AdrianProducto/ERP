Feature: Asignar automáticamente Clave SAT según configuración del convoy
  Como usuario de Trafico
  Necesito que el sistema determine automáticamente la Clave SAT del convoy
  Para asegurar la correcta generación del complemento Carta Porte sin errores de captura manual

  Background: 
    Given que el parámetro "Asignación automática de Clave SAT a unidades" se encuentra habilitado
    And el usuario esta registrando una Carta Porte

  Scenario Outline: Asignación correcta de Clave SAT según la matriz de configuración vehicular
    Given que el convoy está conformado por una unidad tipo "<tipo_unidad>"
    And el Remolque 1 "<tiene_remolque1>"
    And el Dolly "<tiene_dolly>"
    And el Remolque 2 "<tiene_remolque2>"
    And la sumatoria total de ejes del convoy es "<total_ejes>"
    And la sumatoria total de llantas del convoy es "<total_llantas>"
    When el sistema calcula la configuración vehicular del convoy
    Then debe asignar la Clave SAT "<clave_sat>"
    And debe mostrar dicha clave en el campo Clave SAT del proceso Asignar Operador/Camión
    And debe mostrar la descripción correspondiente en el campo Autotransporte Federal

    Example: 
      | tipo_unidad          | tiene_remolque1 | tiene_dolly | tiene_remolque2 | total_ejes | total_llantas | clave_sat |
      | VEHICULO UNITARIO    | No asignado     | No asignado | No asignado     | 2          | 4              | VL       |
      | VEHICULO UNITARIO    | No asignado     | No asignado | No asignado     | 2          | 6              | C2       |
      | VEHICULO UNITARIO    | No asignado     | No asignado | No asignado     | 3          | 8              | C3       |
      | VEHICULO UNITARIO    | No asignado     | No asignado | No asignado     | 3          | 10             | C3       |
      | VEHICULO UNITARIO    | Asignado        | Asignado    | No asignado     | 4          | 14             | C2R2     |
      | VEHICULO UNITARIO    | Asignado        | Asignado    | No asignado     | 5          | 18             | C3R2     |
      | VEHICULO UNITARIO    | Asignado        | Asignado    | No asignado     | 6          | 22             | C3R3     |
      | TRACTOCAMION         | Asignado        | No asignado | No asignado     | 3          | 10             | T2S1     |
      | TRACTOCAMION         | Asignado        | No asignado | No asignado     | 4          | 14             | T2S2     |
      | TRACTOCAMION         | Asignado        | No asignado | No asignado     | 5          | 18             | T2S3     |
      | TRACTOCAMION         | Asignado        | No asignado | No asignado     | 4          | 14             | T3S1     |
      | TRACTOCAMION         | Asignado        | No asignado | No asignado     | 5          | 18             | T3S2     |
      | TRACTOCAMION         | Asignado        | No asignado | No asignado     | 6          | 22             | T3S3     |
      | TRACTOCAMION         | Asignado        | Asignado    | Asignado        | 5          | 18             | T2S1R2   |
      | TRACTOCAMION         | Asignado        | Asignado    | Asignado        | 6          | 22             | T2S2R2   |
      | TRACTOCAMION         | Asignado        | Asignado    | Asignado        | 6          | 22             | T2S1R3   |
      | TRACTOCAMION         | Asignado        | Asignado    | Asignado        | 6          | 22             | T3S1R2   |
      | TRACTOCAMION         | Asignado        | Asignado    | Asignado        | 7          | 26             | T3S1R3   |
      | TRACTOCAMION         | Asignado        | Asignado    | Asignado        | 7          | 26             | T3S2R2   |
      | TRACTOCAMION         | Asignado        | Asignado    | Asignado        | 8          | 30             | T3S2R3   |
      | TRACTOCAMION         | Asignado        | Asignado    | Asignado        | 9          | 34             | T3S2R4   |
      | TRACTOCAMION         | Asignado        | Asignado    | Asignado        | 6          | 22             | T2S2S2   |
      | TRACTOCAMION         | Asignado        | Asignado    | Asignado        | 7          | 26             | T3S2S2   |
      | TRACTOCAMION         | Asignado        | Asignado    | Asignado        | 8          | 30             | T3S3S2   |

  Scenario: Configuración del convoy sin coincidencia en la matriz
    Given que el convoy está conformado por una combinación de ejes y llantas que no coincide con ninguna fila de la matriz de configuración vehicular
    When el sistema calcula la configuración vehicular del convoy
    Then debe asignar como Clave SAT la clave configurada en el catálogo de Tipos de Unidad correspondiente a la unidad asignada al trayecto
    And debe mostrar dicha clave en el campo Clave SAT del proceso Asignar Operador/Camión
    And debe mostrar ambos campos a manera de consulta

  Scenario: Generación del complemento Carta Porte con la clave determinada automáticamente
    Given que el sistema ha determinado automáticamente la Clave SAT "T3S2R4" para el convoy
    When se genera el complemento Carta Porte
    Then el atributo ConfigVehicular debe tomar el valor "T3S2R4"

  Scenario: Mostrar indicador visual informativo en el campo Clave SAT
    Given que el usuario esta en el proceso de Asignar Operador/Camión
    When posiciona el cursor sobre el indicador visual del campo Clave SAT
    Then el sistema debe mostrar el siguiente mensaje informativo:
      """
      Importante: La asignación automática de la clave SAT se realiza con base en la información registrada de las unidades. Cualquier inconsistencia en los siguientes datos puede provocar una asignación incorrecta:
      - Número de ejes.
      - Número de llantas.
      - Configuración de unidades y remolques.
      """