Feature: Modificar dispersión
  Como usuario de tráfico
  Necesito poder agregar o eliminar liquidaciones a una dispersión existente 
  Para que al subir la información al portal de BANORTE se procesen los registros deseados

  Scenario: Mostrar información de la dispersión
    Given existen dispersiones registradas
    When el usuario solicita modificar las liquidaciones relacionados
    Then el sistema muestra a manera de consulta la información relacionada a la dispersión:
      | Descripción         |
      | Cuenta Bancaria     |
      | Fecha               |
      | T. Cambio           |
      | Operación           |
      | Fecha de aplicaicón | 
    And muestra seleccionados las liquidaciones relacionados a la dispersion mostrando por cada uno:
      | Folio         |
      | Operador      |
      | Fecha inicial |
      | Fecha final   |
      | Importe       |
      | Moneda        |
    And presenta las opciones:
      | Actualizar              |
      | Asignar datos bancarios |
      | Aceptar                 |
      | Cancelar                |
  
  Scenario: Precargar fechas en rango de búsqueda de liquidaciones
    Given el usuario solicita modificar una dispersion 
    When el sistema carga la información correspondiente
    Then precarga en la fecha inicial del filtro la fecha mas antigua de las liquidaciones relacionadas
    And precarga en la fecha final del filtro, la fecha mas reciente de las liquidaciones relacionadas  
  
  Scenario: Búsqueda exitosa de liquidaciones
    Given el usuario captura un rango de fechas de búsqueda
    When el usuario presiona el boton "Actualizar"
    Then actualiza el listado para presentar las liquidaciones autorizadas
    And que no estén relacionadas a otra dispersión
    And que no esten marcadas como "PAGADAS"
    And cuya fecha esté dentro del rango seleccionado
    
  Scenario: Mostrar marcados liquidaciones relacionadas a la dispersión al actualizar resultados de busqueda
    Given existen liquidaciones relacionadas a la dispersión 
    When el usuario realiza la busqueda de liquidaciones
    And el rango de fecha seleccionado coincide con las fechas de las liquidaciones que ya estan relacionados a la dispersión
    Then al mostrar los resultados de la busqueda el sistema muestra seleccionadas las liquidaciones previamente relacionadas

  Scenario: No mostrar liquidaciones relacionadas a la dispersión al actualizar resultados de busqueda
    Given existen liquidaciones relacionados a la dispersión 
    When el usuario realiza la busqueda de liquidaciones
    And el rango de fecha seleccionado no coincide con las fechas de las liquidaciones que ya estan relacionadas a la dispersión
    Then al mostrar los resultados de la busqueda el sistema no muestra las liquidaciones previamente relacionadas

  Scenario: No se encontraron coincidencias
    Given el usuario captura un rango de fechas de búsqueda
    When el usuario presiona el boton "Actualizar"
    Then el sitema determina que no se encontraron liquidaciones autorizadas
    And que no estén relacionadas a otra dispersión
    And que no esten marcadas como "PAGADA"
    And cuya fecha esté dentro del rango seleccionado
    And el sistema presenta el mensaje:
    """
      No se encontraron resultados
    """ 

  Scenario: Validar rango de fechas para buscar liquidaciones
    Given un rango de fechas capturado
    When el sistema determina que la fecha inicial es mayor a la fecha final 
    Then el sistema iguala la fecha final a la fecha inicial
    
  Scenario: Calcular total de la operacion y actualizar numero de liquidaciones seleccionadas
    Given el usuario se encuentra actualizando una dispersión avanzada
    When el usuario selecciona una o más liquidaciones
    Then el sistema actualiza el número de liquidaciones seleccionadas
    And actualiza el total de la operacion realizando la sumatoria de los importes correspondientes a las liquidaciones seleccinadas

  Scenario: Asignar datos bancarios
    Given el usuario se encuentra registrando una dispersión avanzada
    And selecciona una liquidaciones con operador sin banco y/o cuenta bancaria/CLABE asignada
    And presiona el boton "Asignar datos bancarios"
    When el sistema solicita la siguiente información
      | Banco           |
      | Cuenta bancaria |
    And el usuario especifica la información solicitada
    And solicita guardar los cambios
    Then el sistema valida que la cuenta bancaria sea valida 
    And el sistema actualiza el listado de liquidaciones para mostrar la información capturada

  Scenario: Cuenta bancaria valida
    Given el usuario actualiza los datos bancarios del operador
    And solicita guardar los cambios
    When el sistema determina que la cuenta bancaria capturada tiene entre 10 y 18 digitos
    Then el actualiza el listado de anticipos

  Scenario: Cuenta bancaria invalida
    Given el usuario actualiza los datos bancarios del operador
    And solicita guardar los cambios
    When el sistema determina que la cuenta bancaria capturada no tiene entre 10 y 18 digitos
    Then el manda el siguiente mensaje:
    """
      La cuenta bancaria debe tener entre 10 y 18 caracteres, favor de verificar.
    """
    And no realiza ningun cambio

  Scenario: Validar selección mínima de liquidaciones
    Given el usuario presiona el boton "Aceptar"
    When el sistema determina que no se selecciono por lo menos una liquidaciones
    Then el sistema muestra el mensaje 
    """
      Es necesario seleccionar por lo menos una liquidación para continuar
    """
    And no realiza ninguna acción

  Scenario: Validar de operadores sin información bancaria
    Given existen liquidaciones seleccionadas con operadores sin información bancaria completa
    When el usuario presiona el boton "Aceptar"
    Then el sistema muestra el mensaje 
    """
      Los siguientes operadores no cuentan con su información bancaria completa
    """
    And muestra la lista de operadores correspondientes
    And no realiza ninguna acción

  Scenario: Guardar cambios
    Given existe al menos una liquidación seleccionada
    And todos los operadores cuentan con información bancaria completa
    When el usuario presiona el boton "Aceptar"
    Then el sistema crea la relación entre las nuevas liquidaciones seleccionadas con la dispersión actual
    And elimina la relación entre las liquidaciones previamente relacionadas que se desmarcaron con la dispersión actual
    And genera nuevamente el archivo de dispersión
    And realiza la descarga automática en el equipo del usuario

  Scenario: Cancelar proceso
    Given el usuario se encuentra modificando la dispersión
    And presiona el boton "Cancelar"
    Then el sistema no realiza ningun cambio
    And regresa al listado de dispersiones generadas

  