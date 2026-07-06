Feature: Generar nueva dispersión
  Como usuario de tráfico 
  Necesito poder generar registros de disperciones para liquidaciones
  Para poder tener un mejor control de la información

  Scenario: Solicitar información para generar dispersión
    Given el usuario se encuentra en el listado de dispersiones
    When presione el boton "Generar"
    Then el sistema debe solicitar la siguiente información:
      | Campo               | Tipo     | Obligatorio | Permitidos                                                     | Máx | Default      | Opciones                                                 |
      | Descripción         | Texto    | Sí          | Letras, números y caracteres especiales                        | 30  | En blanco    |                                                          |
      | Fecha               | Fecha    | Sí          | Fecha menor o igual a la actual                                |     | fecha_actual |                                                          |
      | Cuenta Bancaria     | Catalogo | Sí          | Cuentas asociadas a los bancos con Layout de anticipos cargado |     | En blanco    | Catalogo de cuentas bancarias                            |
      | T. Cambio           | Númerico | Sí          | Numeros con hasta 4 decimales                                  |     | TC_actual    |                                                          |
      | Operación           | Combo    | Sí          |                                                                |     | TODAS        | TODAS, 01 PROPIAS, 02 TERCEROS, 04 SPEI, 05 TEF, 07 OPIS |
      | Fecha de aplicación | Fecha    | Si          |                                                                |     | fecha_actual |                                                          |
    And presenta una lista con solo liquidaciones autorizadas
    And que no estén relacionadas a otra dispersión
    And que no tengan estatus PAGADA
    And cuya fecha de liquidación sea igual al dia actual
    And por cada liquidación presenta la siguiente información:
      | Folio                 |
      | Operador              |
      | Fecha inicial         |
      | Fecha final           |
      | Importe               |
      | Moneda                |
      | Banco                 |
      | Cuenta bancaria/CLABE |
    And presenta las siguientes opciones:
      | Actualizar              |
      | Asignar datos bancarios |
      | Aceptar                 |
      | Cancelar                |

  Scenario: Búsqueda de liquidaciones a incluir
    Given el usuario captura un rango de fechas de búsqueda
    When el usuario presiona el boton "Actualizar"
    Then sistema encuentra liquidaciones autorizados
    And que no estén relacionadas a otra dispersión
    And que no tengan estatus PAGADA
    And cuya fecha esté dentro del rango seleccionado
    And actualiza el listado liquidaciones para presentar las coincidencias

  Scenario: No se encontraron coincidencias
    Given el usuario captura un rango de fechas de búsqueda
    When el usuario presiona el boton "Actualizar"
    Then el sitema determina que no se encontraron liquidaciones autorizados
    And que no estén relacionadas a otra dispersión
    And que no tengan estatus PAGADA
    And cuya fecha esté dentro del rango seleccionado
    And el sistema presenta el mensaje:
    """
      No se encontraron resultados
    """ 
    And el listado de liquidaciones se muestra en blanco

  Scenario: Validar rango de fechas para buscar liquidaciones
    Given un rango de fechas capturado
    When el sistema determina que la fecha inicial es mayor a la fecha final 
    Then el sistema iguala la fecha final a la fecha inicial
    
  Scenario: Calcular total de la operacion y actualizar numero de liquidaciones seleccionados
    Given el usuario se encuentra registrando una dispersión avanzada
    When el usuario selecciona una o más liquidaciones
    Then el sistema actualiza el número de liquidaciones seleccionadas
    And actualiza el total de la operacion realizando la sumatoria de los importes correspondientes a las liquidaciones seleccinadas

  Scenario: Asignar datos bancarios
    Given el usuario se encuentra registrando una dispersión avanzada
    And selecciona una liquidación con operador sin banco y/o cuenta bancaria/CLABE asignada
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
    Then el actualiza el listado de liquidaciones

  Scenario: Cuenta bancaria invalida
    Given el usuario actualiza los datos bancarios del operador
    And solicita guardar los cambios
    When el sistema determina que la cuenta bancaria capturada no tiene entre 10 y 18 digitos
    Then el manda el siguiente mensaje:
    """
      La cuenta bancaria debe tener entre 10 y 18 caracteres, favor de verificar.
    """
    And no realiza ningun cambio

  Scenario: Validar de fecha de dispersión
    Given el usuario captura la fecha de dispersión
    When el campo pierde el foco
    Then el sistema determina que la fecha capturada es mayor a la fecha actual
    And el sistema muestra el mensaje:
    """
      La fecha no puede ser mayor a la fecha actual
    """
    And marca en rojo el campo 

  Scenario: Validar captura de datos obligatorios de la dispersión
    Given el usuario capturo la información requerida
    And presiona el boton "Aceptar"
    When el sistema detecta que no se capturaron campos obligatorios
    Then presenta el mensaje:
    """
      Completa todos los campos requeridos antes de continuar
    """
    And el sistema marca en rojo los campos obligatorios por capturar 
    And no genera el archivo de dispersión

  Scenario: Validar selección mínima de liquidaciones
    Given el usuario intenta generar la dispersión
    When el sistema determina que no se selecciono por lo menos una liquidación
    Then el sistema muestra el mensaje 
    """
      Es necesario seleccionar por lo menos una liquidación para continuar
    """
    And no genera el archivo de dispersión

  Scenario: Validar de operadores sin información bancaria
    Given existen liquidaciones seleccionadas con operadores sin información bancaria completa
    When el usuario intenta generar la dispersión
    Then el sistema muestra el mensaje 
    """
      Los siguientes operadores no cuentan con su información bancaria completa
    """
    And muestra la lista de operadores correspondientes
    And no genera el archivo de dispersión

  Scenario: Generación exitosa de la dispersión
    Given toda la información requerida ha sido capturada correctamente
    And existe al menos una liquidación seleccionada
    And todos los operadores cuentan con información bancaria completa
    When el usuario solicita generar la dispersión
    Then el sistema registra la dispersión exitosamente
    And relaciona las liquidaciones seleccionadas con la dispersion registrada
    And genera el archivo de dispersion correspondiente
    And descarga el archivo generado en la computadora del usuario
    And la dispersión se muestra en el listado de Dispersión Avanzada

  Scenario: Cancelar proceso
    Given el usuario se encuentra registrando una dispersion
    And presiona el boton "Cancelar"
    Then el sistema no realiza ningun cambio
    And regresa al listado de dispersiones 

