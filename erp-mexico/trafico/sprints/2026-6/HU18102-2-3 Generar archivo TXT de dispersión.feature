Feature: Generar de archivo TXT para dispersión bancaria Banorte
  Como usuario que realiza una dispersión
  Quiero generar un archivo TXT basado en el layout de pago simplificado Banorte
  Para enviar pagos correctamente al banco

  Background:
    Given que existe un operador con datos bancarios configurados
    And existe una cuenta origen seleccionada para la dispersión
    And existe un anticipo con folio e importe total
    And existe una fecha de aplicación capturada
    And el RFC de la empresa está configurado en Parámetros Generales

  Scenario: Generar archivo TXT para dispersión de anticipos
    Given el usuario genera el archivo de dispersión
    When el layout configurado es para el pago simplificado del banco BANORTE 
    Then debe crearse un archivo con extensión ".TXT"
    And debe tener la siguiente estructura:
      | Operación              |
      | Clave                  |
      | Cuenta origen          |
      | Cuenta destino / CLABE |
      | Importe                |
      | Referencia             |
      | Descripción            |
      | RFC ordenante          |
      | IVA                    |
      | Fecha de aplicación    |
      | Instrucción de pago    |
    And el archivo no debe contener encabezado
    And los campos deben estar separados por TABs
    And los campos no deben rellenarse con espacios o ceros
    And debe descargarse automáticamente en la computadora del usuario

  #OBTENER CODIGO OPERACION
  Scenario: Asignar codigo operacion de acuerdo a lo especificado al registrar dispersión
    Given se especifico un tipo de operación diferente a "TODAS"
    When el sistema este generando el archivo 
    And este obteniendo la información del tipo de operación
    Then el sistema debe carga el código correspondiente a la opción seleccionada en el campo "Operación" durante el proceso de dispersión:
      | código | opcion      |
      | 01     | 01 PROPIAS  |
      | 02     | 02 TERCEROS |
      | 04     | 04 SPEI     |
      | 05     | 05 TEF      |
      | 07     | 07 OPIS     |
    
  Scenario: Asignar codigo operacion de acuerdo al banco del operador
    Given se especifico la opción "TODAS" en el campo "Operación al generar la dispersión"
    When el sistema este generando el archivo 
    And este obteniendo la información del tipo de operación
    Then el sistema debe carga el código 02 para los operadores cuyo banco relacionado es "BANORTE"
    And el sistema debe carga el código 04 para los operadores cuyo banco relacionado es diferente a "BANORTE"

  #OBTENER CLAVE ID
  Scenario: Obtener Clave ID para operacion a terceros
    Given que la operación es "02"
    When el sistema este generando el archivo 
    And este obteniendo la información para la clave ID
    Then el campo "Clave ID" debe obtenerse del campo "ID Banorte" configurado en el catálogo de operadores

  Scenario: Obtener Clave ID para operacion SPEI
    Given que la operación es "04"
    When el sistema este generando el archivo 
    And este obteniendo la información para la clave ID
    Then el campo "Clave ID" debe obtenerse del campo "ID Banorte" configurado en el catálogo de operadores

  Scenario: Obtener Clave ID para operacion TEF
    Given que la operación es "05"
    When el sistema este generando el archivo 
    And este obteniendo la información para la clave ID
    Then el campo "Clave ID" debe obtenerse del campo "ID Banorte" configurado en el catálogo de operadores

  Scenario: Obtener Clave ID para operacion OPIS
    Given que la operación es "07"
    When el sistema este generando el archivo 
    And este obteniendo la información para la clave ID
    Then el campo "Clave ID" debe obtenerse del campo "ID Banorte" configurado en el catálogo de operadores

  Scenario: Dejar Clave ID vacía en operacion entre cuentas propias
    Given que la operación es "01"
    When el sistema este generando el archivo 
    And este obteniendo la información para la clave ID
    Then el campo "Clave ID" debe ir vacío
    And debe respetarse la posición mediante TABs
  
  Scenario: Dejar Clave ID vacía cuando no existe ID Banorte configurado en operacion a terceros
    Given que la operación es "02"
    And el operador no tiene configurado ID Banorte
    When el sistema este generando el archivo 
    And este obteniendo la información para la clave ID
    Then el campo "Clave ID" debe ir vacío
    And debe respetarse la posición mediante TABs

  Scenario: Dejar Clave ID vacía cuando no existe ID Banorte configurado en operacion SPEI
    Given que la operación es "04"
    And el operador no tiene configurado ID Banorte
    When el sistema este generando el archivo 
    And este obteniendo la información para la clave ID
    Then el campo "Clave ID" debe ir vacío
    And debe respetarse la posición mediante TABs

  Scenario: Dejar Clave ID vacía cuando no existe ID Banorte configurado en operacion TEF
    Given que la operación es "05"
    And el operador no tiene configurado ID Banorte
    When el sistema este generando el archivo 
    And este obteniendo la información para la clave ID
    Then el campo "Clave ID" debe ir vacío
    And debe respetarse la posición mediante TABs

  Scenario: Dejar Clave ID vacía cuando no existe ID Banorte configurado en operacion OPIs
    Given que la operación es "07"
    And el operador no tiene configurado ID Banorte
    When el sistema este generando el archivo 
    And este obteniendo la información para la clave ID
    Then el campo "Clave ID" debe ir vacío
    And debe respetarse la posición mediante TABs
  
  #OBTENER CUENTA ORIGEN
  Scenario: Obtener cuenta origen
    Given el sistema este generando el archivo
    When este obteniendo la información para la cuenta origen
    Then el sistema debe tomar la cuenta seleccionada en el campo "Cuenta bancaria" durante la generación de la dispersión 

  #OBTENER CUENTA DESTINO
  Scenario: Obtener cuenta destino / CLABE 
    Given el sistema este generando el archivo
    When este obteniendo la información para la cuenta destino / CLABE
    Then debe obtenerse del campo "Cuenta bancaria/CLABE" del catálogo de operadores

  #OBTENER IMPORTE
  Scenario: Obtener importe del anticipo
    Given el sistema este generando el archivo
    When este obteniendo la información para el dato importe
    Then el sistema debe tomar el importe total del anticipo
    And debe manejar dos decimales

  #OBTENER REFERENCIA
  Scenario: Obtener referencia de la operación
    Given el sistema este generando el archivo
    When este obteniendo la información para la referencia
    Then el sistema debe tomar el "Folio" correspondiente al anticipo
    And debe cortar el dato a los 10 caracteres

  #OBTENER DESCRIPCION
  Scenario: Obtener descripción de la operación
    Given el sistema este generando el archivo
    When este obteniendo la información para la descripcion 
    Then el sistema debe tomar el "Folio" correspondiente al anticipo
    And debe cortar el dato a los 30 caracteres

  #OBTENER RFC ORDENANTE
  Scenario: Obtener RFC ordenante para operacion SPEI
    Given que la operación es "04"
    When el sistema este generando el archivo 
    And este obteniendo la información para el RFC ordenante
    Then el campo debe obtenerse del RFC configurado en Parámetros Generales del sistema

  Scenario: Obtener RFC ordenante para operacion TEF
    Given que la operación es "05"
    When el sistema este generando el archivo 
    And este obteniendo la información para el RFC ordenante
    Then el campo debe obtenerse del RFC configurado en Parámetros Generales del sistema

  Scenario: Dejar RFC ordenante vacio en operacion entre cuentas propias
    Given que la operación es "01"
    When el sistema este generando el archivo 
    And este obteniendo la información para el RFC ordenante
    Then el campo "RFC ordenante" debe ir vacío
    And debe respetarse la posición mediante TABs

  Scenario: Dejar RFC ordenante vacio en operacion es a terceros
    Given que la operación es "02"
    When el sistema este generando el archivo 
    And este obteniendo la información para el RFC ordenante
    Then el campo "RFC ordenante" debe ir vacío
    And debe respetarse la posición mediante TABs

  Scenario: Dejar RFC ordenante vacio en operacion OPIS
    Given que la operación es "07"
    When el sistema este generando el archivo 
    And este obteniendo la información para el RFC ordenante
    Then el campo "RFC ordenante" debe ir vacío
    And debe respetarse la posición mediante TABs

  #OBTENER IVA
  Scenario: Obtener importe IVA
    Given el sistema este generando el archivo
    When este obteniendo la información para el IVA
    Then el sistema debe asignar el valor "0"

  #OBTENER FECHA DE APLICACION
  Scenario: Obtener Fecha de aplicación para operacion a terceros
    Given que la operación es "02"
    When el sistema este generando el archivo 
    And este obteniendo la información para la fecha de aplicación
    Then el campo debe tomar la fecha capturada en el campo "Fecha de aplicación" durante el proceso de dispersión
    And debe mostrarse en formato "DDMMAAAA"

  Scenario: Obtener Fecha de aplicación para operacion SPEI
    Given que la operación es "04"
    When el sistema este generando el archivo 
    And este obteniendo la información para la fecha de aplicación
    Then el campo debe tomar la fecha capturada en el campo "Fecha de aplicación" durante el proceso de dispersión
    And debe mostrarse en formato "DDMMAAAA"

  Scenario: Obtener Fecha de aplicación para operacion TEF
    Given que la operación es "05"
    When el sistema este generando el archivo 
    And este obteniendo la información para la fecha de aplicación
    Then el campo debe tomar la fecha capturada en el campo "Fecha de aplicación" durante el proceso de dispersión
    And debe mostrarse en formato "DDMMAAAA"

  Scenario: Obtener Fecha de aplicación para operacion OPIS
    Given que la operación es "07"
    When el sistema este generando el archivo 
    And este obteniendo la información para la fecha de aplicación
    Then el campo debe tomar la fecha capturada en el campo "Fecha de aplicación" durante el proceso de dispersión
    And debe mostrarse en formato "DDMMAAAA"

  Scenario: Dejar Fecha de aplicación vacia en operacion entre cuentas propias
    Given que la operación es "01"
    When el sistema este generando el archivo 
    And este obteniendo la información para la fecha de aplicación
    Then el campo "Fecha de aplicación" debe ir vacío
    And debe respetarse la posición mediante TABs

  #OBTENCION INSTRUCCION DE PAGO
  Scenario: Obtener Instrucción de pago para operacion entre cuentas propias
    Given que la operación es "01"
    When el sistema este generando el archivo 
    And este obteniendo la información para la Instrucción de pago
    Then el sistema debe asignar el valor "X"

  Scenario: Obtener Instrucción de pago para operacion a terceros
    Given que la operación es "02"
    When el sistema este generando el archivo 
    And este obteniendo la información para la Instrucción de pago
    Then el sistema debe asignar el valor "X"

  Scenario: Obtener Instrucción de pago para operacion TEF
    Given que la operación es "05"
    When el sistema este generando el archivo 
    And este obteniendo la información para la Instrucción de pago
    Then el sistema debe asignar el valor "X"

  Scenario: Obtener Instrucción de pago para operacion OPIS
    Given que la operación es "07"
    When el sistema este generando el archivo 
    And este obteniendo la información para la Instrucción de pago
    Then el sistema debe asignar el valor "X"

  Scenario: Dejar Instrucción de pago vacia en operacion SPEI
    Given que la operación es "04"
    When el sistema este generando el archivo 
    And este obteniendo la información para la Instrucción de pago
    Then el campo "Instrucción de pago" debe ir vacío
    And debe respetarse la posición mediante TABs