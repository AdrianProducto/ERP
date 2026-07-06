Feature: Asignar operación bancaria
  Como usuario de tráfico 
  Necesito poder asignar la operación bancaria correspondiente a cada anticipo una vez que se proceso el archivo en el portal BANORTE
  Para mantener la trazabilidad de la información

  Scenario: Solicitar información para asignar operación bancaria
    Given existen dispersiones registradas pendientes de asignar operación bancaria
    When el usuario solicita asignar operación bancaria
    Then el sistema presenta la cuenta bancaria seleccionada al realizar la dispersióna en el campo "Cuenta Bancaria" modo de consulta
    And presenta la opción "TRANSFERENCIA" en el campo "Tipo de movimiento" a modo consulta
    And el sistema solicita la siguiente información:
      | Campo                  | Tipo     | Obligatorio | Permitidos                                            | Máx | Default      |
      | Fecha                  | Fecha    | Sí          | Fecha menor o igual a la actual en formato DD/MM/AAAA |     | fecha_actual |
      | Fecha de cobro         | Fecha    | Sí          | En formato DD/MM/AAAA                                 |     | fecha_actual |
      | No. Operacion bancaria | Númerico | Sí          | Unicamente números enteros                            | 20  |              |
      | T. Cambio              | Númerico | Sí          | Numeros con hasta 6 decimales                         |     | TC_actual    |
    And presenta un listado de los anticipos a afectar:
      | Folio    |
      | Fecha    |
      | Operador |
      | Importe  |
      | Moneda   |
      | Concepto |
    And presenta el total de anticipos a afectar
    And presenta el total de la operación que representa la sumatoria del importe de todos los anticipos incluidos
    And presenta las siguientes opciones:
      | Aceptar  |
      | Cancelar |
    
  Scenario: Validar de fecha de la asignacion de operación bancaria
    Given el usuario captura la fecha
    When el campo pierde el foco
    Then el sistema determina que la fecha capturada es mayor a la fecha actual
    And el sistema muestra el mensaje:
    """
      La fecha no puede ser mayor a la fecha actual
    """
    And marca en rojo el campo

  Scenario: Validar captura de datos obligatorios
    Given el usuario capturo la información requerida
    And presiona el boton "Aceptar"
    When el sistema detecta que no se capturaron campos obligatorios
    Then presenta el mensaje:
    """
      Completa todos los campos requeridos antes de continuar
    """
    And el sistema marca en rojo los campos obligatorios por capturar 
    And no genera realiza la asignación de operación bancaria

  Scenario: Asignar número de operacion bancaria masivo
    Given el usuario solicita realizar la asignación de operación bancaria
    When el sitema determina que se encuentra activo el paramentro "Generar póliza/movimiento bancario al asignar op.masiva en anticipos" del modulo de tráfico
    Then asigna como número de operación bancaria el "No. Operacion bancaria" especificado al realizar la asignación de operación

  Scenario: Asignar número de operacion bancaria por anticipo
    Given el usuario solicita realizar la asignación de operación bancaria
    When el sitema determina que se encuentra inactivo el paramentro "Generar póliza/movimiento bancario al asignar op.masiva en anticipos" del modulo de tráfico
    Then asigna el número correspondiente de operación bancaria a cada anticipo iniciando con el número capturado e incrementando en 1

  Scenario: Generar movimiento bancario masivo
    Given el usuario solicita realizar la asignación de operación bancaria
    When el sitema determina que se encuentra activo el paramentro "Generar póliza/movimiento bancario al asignar op.masiva en anticipos" del modulo de tráfico
    Then genera un unico movimiento bancario para todos los anticipos incluidos
    And como "Cuenta bancaria" toma la cuenta bancaria seleccionada la realizar la dispersión
    And como "Número de movimiento" asigna de forma automática el siguiente consecutivo disponible
    And como "Tipo de cambio" toma el tipo de cambio especificado al realizar la asignación de la operación
    And como "Concepto" toma el valor "RETIRO POR TRANSFERENCIA"
    And como "Fecha" toma la fecha especificada al realizar la asignación de la operación
    And como "Fecha de cobro" toma la fecha de cobro especificada al realizar la asignación de la operación
    And como "Beneficiario" debe asignar el valor "OPERADOR GLOBAL"
    And conforma el dato "Referencia" de la siguiente estructura:
    """
      DISPERSIÓN MASIVA DE ANTICIPOS, REF: <Número de operación bancaria capturada>
    """
    And asigna el dato "Referencia" a cada anticipo afectado
    And como "Importe" toma la sumatoria de importes de los anticipos afectados
    And el sistema elimina la relaciín entre los anticipos y la dispersión
    And elimina la dispersión

  Scenario: Generar movimiento bancario por anticipo
    Given el usuario solicita realizar la asignación de operación bancaria
    When el sitema determina que se encuentra inactivo el paramentro "Generar póliza/movimiento bancario al asignar op.masiva en anticipos" del modulo de tráfico
    Then genera un movimiento bancario por cada anticipo incluido
    And como "Cuenta bancaria" toma la cuenta bancaria seleccionada la realizar la dispersión
    And como "Número de movimiento" asigna de forma automática el siguiente consecutivo disponible
    And como "Tipo de cambio" toma el tipo de cambio especificado al realizar la asignación de la operación
    And como "Concepto" toma el valor "RETIRO POR TRANSFERENCIA"
    And como "Fecha" toma la fecha especificada al realizar la asignación de la operación
    And como "Fecha de cobro" toma la fecha de cobro especificada al realizar la asignación de la operación
    And como "Beneficiario" debe el ID y nombre del operador relacionado al anticipo
    And conforma el dato "Referencia" de la siguiente estructura:
    """
      “NO OP:”+ <Número de operación bancaria del anticipo> + “ANT:” +<Folio anticipo>”-”+<Nombre operador> + “VIAJE” + <Número de viaje>
    """
    And como "Importe" toma el importe del anticipo
    And el sistema elimina la relaciín entre los anticipos y la dispersión
    And elimina la dispersión