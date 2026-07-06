Feature: Pagar liquidaciones de la dispersion
  Como usuario de dispersiones
  Necesito poder marcar como pagadas las liquidaciones relacionadas a una disperción que ya fueron procesadas por el banco
  Con el fin de mantener la información en sistema actualizada

  Scenario: Solicitar información para el pago de liquidaciones
    Given existen dispersiones registradas pendientes de pago
    When el usuario solicita pagar
    Then el sistema presenta la cuenta bancaria seleccionada al realizar la dispersióna en el campo "Cuenta Bancaria" modo de consulta
    And presenta la opción "TRANSFERENCIA" en el campo "Tipo de movimiento" a modo consulta
    And el sistema solicita la siguiente información:
      | Campo                  | Tipo     | Obligatorio | Permitidos                                            | Máx | Default      |
      | Fecha                  | Fecha    | Sí          | Fecha menor o igual a la actual en formato DD/MM/AAAA |     | fecha_actual |
      | Fecha de cobro         | Fecha    | Sí          | En formato DD/MM/AAAA                                 |     | fecha_actual | 
      | T. Cambio              | Númerico | Sí          | Numeros con hasta 6 decimales                         |     | TC_actual    |
    And presenta un listado de las liquidaciones a afectar:
      | Folio    |
      | Fecha    |
      | Operador |
      | Importe  |
      | Moneda   |
      | Concepto |
    And presenta el total de liquidaciones a afectar
    And presenta el total de la operación que representa la sumatoria del importe de todos las liquidaciones incluidos
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
    And no genera realiza la operación


  Scenario: Generar pago de liquidaciones
    Given el usuario solicita realizar el pago/timbrado de cada liquidación
    When el sistema determina que se ha capturado toda la información requerida
    Then genera un movimiento bancario por cada liquidación incluida
    And como "Cuenta bancaria" toma la cuenta bancaria seleccionada al realizar el pago de la dispersión
    And como "Número de movimiento" asigna de forma automática el siguiente consecutivo disponible
    And como "Tipo de cambio" toma el tipo de cambio especificado al realizar al realizar el pago de la dispersión
    And como "Concepto" toma el valor "RETIRO POR TRANSFERENCIA"
    And como "Fecha" toma la fecha especificada al realizar al realizar el pago de la dispersión
    And como "Fecha de cobro" toma la fecha de cobro especificada al realizar al realizar el pago de la dispersión
    And como "Beneficiario" debe el ID y nombre del operador relacionado a la liquidación
    And conforma el dato "Referencia" de la siguiente estructura:
    """
      LIQ: <Folio liquidacion> - <Nombre completo operador> - CTA: <Cuenta bancaria/CLABE operador>
    """
    And como "Importe" toma el importe de la liquidación
    And marca como "PAGADA" cada liquidación incluida
    And asigna como fecha de pago la fecha especificada al realizar el pago de la dispersión
    And timbra cada liquidación incluida
    And se muestra un mensaje con el resultado del proceso:
      """
        Registros procesados con éxito: {cantidad}
        Registros no procesados debido a errores: {cantidad}
      """
    
  Scenario: TODOS los registros son procesados con exito
    Given el sistema esta realizando el pago de una dispersión
    When todas las liquidaciones son pagadas y timbradas con exito 
    Then sistema elimina la relaciín entre las liquidaciones y la dispersión
    And elimina la dispersión

  Scenario: Generación de polizas
    Given existen liquidaciones procesadas correctamente
    When se cuenta con prepolizas configuradas para pago de liquidaciones
    Then el sistema genera las polizas correspondientes

  Scenario: Error al timbrar una o mas liquidaciones
    Given el sistema esta realizando el pago de una dispersión
    When se produce un error en el timbrado de una o mas liquidaciones
    Then el sistema cancela el pago de las liquidaciones cuyo timbrado fallo
    And cancela el movimiento bancario correspondiente
    And solo elimina la relacion entre la dispersión y las liquidaciones que fueron pagadas y timbradas exitosamente
