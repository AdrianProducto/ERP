# Característica
Feature: Alta controlada de proveedores desde XML
  Como usuario de GM Fiscal
  Quiero detectar proveedores nuevos desde un CFDI XML y validarlos antes de darlos de alta
  Para evitar registros incorrectos o riesgos fiscales dentro del ERP

  Background:
    Given que GM Fiscal puede leer el RFC emisor del XML
    And que el ERP cuenta con catálogo de proveedores

  Scenario: Reutilizar un proveedor existente en el ERP
    Given que el proveedor del XML ya existe en el catálogo del ERP
    When el sistema valida al proveedor
    Then el sistema reutiliza el proveedor existente
    And no solicita una nueva alta

  Scenario: Permitir alta controlada cuando el proveedor no existe y es válido
    Given que el proveedor del XML no existe en el ERP
    And que el proveedor no aparece en listas EFOS
    And que la información requerida del layout de alta está completa y es válida
    And que el NombreFiscal detectado desde el XML corresponde al nombre fiscal para el alta
    When el usuario confirma el alta del proveedor
    Then el sistema crea el proveedor en ERP
    And deja trazabilidad de que el alta provino desde un XML fiscal

  Scenario Outline: Bloquear o condicionar el alta cuando existen riesgos fiscales
    Given que el proveedor del XML no existe en el ERP
    And que se detecta la condición <condicion_proveedor>
    When el usuario intenta registrar el proveedor
    Then el sistema responde con <resultado_validacion>
    And muestra el mensaje <mensaje_esperado>

    Examples:
      | condicion_proveedor           | resultado_validacion | mensaje_esperado                                               |
      | aparece en lista EFOS         | bloqueo              | No es posible dar de alta al proveedor por riesgo fiscal       |
      | información fiscal incompleta | bloqueo              | El XML no contiene datos suficientes para validar al proveedor |
      | requiere validación humana    | advertencia          | El proveedor debe ser validado por el usuario antes del alta   |

  Scenario Outline: Validar que la información mínima requerida del layout esté completa antes del alta
    Given que el proveedor del XML no existe en el ERP
    And que el proveedor no aparece en listas EFOS
    And que el campo obligatorio <campo_obligatorio> no fue informado
    When el usuario intenta registrar el proveedor
    Then el sistema bloquea el alta del proveedor
    And muestra el mensaje <mensaje_esperado>
    And no crea el proveedor en ERP

    Examples:
      | campo_obligatorio | mensaje_esperado                                                    |
      | RFC               | El campo RFC es obligatorio para dar de alta al proveedor           |
      | NombreFiscal      | El campo NombreFiscal es obligatorio para dar de alta al proveedor  |
      | Calle             | El campo Calle es obligatorio para dar de alta al proveedor         |
      | Municipio         | El campo Municipio es obligatorio para dar de alta al proveedor     |
      | IdEstado          | El campo IdEstado es obligatorio para dar de alta al proveedor      |
      | CodigoPostal      | El campo CodigoPostal es obligatorio para dar de alta al proveedor  |
      | TipoProveedor     | El campo TipoProveedor es obligatorio para dar de alta al proveedor |

  Scenario Outline: Bloquear el alta cuando los datos del layout tienen formato inválido
    Given que el proveedor del XML no existe en el ERP
    And que el proveedor no aparece en listas EFOS
    And que el campo <campo_invalido> tiene el valor <valor_capturado>
    When el usuario intenta registrar el proveedor
    Then el sistema bloquea el alta del proveedor
    And muestra el mensaje <mensaje_esperado>
    And indica claramente que el campo <campo_invalido> impide el alta

    Examples:
      | campo_invalido  | valor_capturado | mensaje_esperado                                                     |
      | RFC             | GGT-081209-393  | El RFC debe capturarse sin guiones y con formato fiscal válido       |
      | RFC             | GGT 081209393   | El RFC no debe contener espacios innecesarios                        |
      | NumeroProveedor | ABC123          | El NumeroProveedor debe ser numérico y no aceptar letras             |
      | NumeroProveedor | -10             | El NumeroProveedor no puede ser negativo                             |
      | CodigoPostal    | 12A4B           | El CodigoPostal debe ser numérico y cumplir con el formato válido    |
      | CodigoPostal    | 123             | El CodigoPostal no cumple con la longitud válida esperada por negocio |
      | DiasCredito     | -30             | DiasCredito debe ser un entero numérico no negativo                  |
      | CreditoPesos    | -1500.50        | CreditoPesos debe ser numérico decimal y no negativo                 |
      | CreditoDolares  | -200.00         | CreditoDolares debe ser numérico decimal y no negativo               |
      | TipoProveedor   | 3               | TipoProveedor debe ser 1 Nacional o 2 Extranjero                     |
      | IdEstado        | ZZ99            | El IdEstado no existe en el catálogo permitido                       |

  Scenario Outline: Normalizar o asignar valores permitidos del layout antes del alta
    Given que el proveedor del XML no existe en el ERP
    And que el proveedor no aparece en listas EFOS
    And que el campo <campo_layout> fue detectado con la condición <condicion_campo>
    When el sistema prepara la información para el alta
    Then el valor final utilizado para el alta es <resultado_esperado>
    And la validación estructural del proveedor continúa

    Examples:
      | campo_layout    | condicion_campo               | resultado_esperado                |
      | NumeroProveedor | no fue informado              | siguiente consecutivo                                |
      | RFC             | viene con espacios laterales  | RFC normalizado sin espacios      |
      | NombreFiscal    | proviene del XML fiscal       | nombre fiscal mapeado al alta ERP |

  Scenario: Permitir el alta cuando los campos opcionales están vacíos pero los requeridos son válidos
    Given que el proveedor del XML no existe en el ERP
    And que el proveedor no aparece en listas EFOS
    And que RFC, NombreFiscal, Calle, Municipio, IdEstado, CodigoPostal y TipoProveedor son válidos
    And que NoExterior, NoInterior, Colonia, Localidad, DiasCredito, CreditoPesos y CreditoDolares vienen vacíos
    When el usuario confirma el alta del proveedor
    Then el sistema crea el proveedor en ERP
    And registra el proveedor con los campos opcionales vacíos permitidos
    And deja trazabilidad de que el alta provino desde un XML fiscal

  Scenario Outline: Validar catálogos permitidos para el alta del proveedor
    Given que el proveedor del XML no existe en el ERP
    And que el proveedor no aparece en listas EFOS
    And que el campo catalogado <campo_catalogado> tiene el valor <valor_capturado>
    When el usuario intenta registrar el proveedor
    Then el sistema responde con <resultado_validacion>
    And muestra el mensaje <mensaje_esperado>

    Examples:
      | campo_catalogado | valor_capturado | resultado_validacion | mensaje_esperado                                     |
      | IdEstado         | 09              | permitido            | El IdEstado es válido para el alta                   |
      | IdEstado         | CA              | permitido            | El IdEstado es válido para el alta                   |
      | IdEstado         | XX              | bloqueo              | El IdEstado no existe en el catálogo permitido       |
      | TipoProveedor    | 1               | permitido            | El TipoProveedor es válido para el alta              |
      | TipoProveedor    | 2               | permitido            | El TipoProveedor es válido para el alta              |
      | TipoProveedor    | 9               | bloqueo              | El TipoProveedor no corresponde a un valor permitido |

  Scenario: Evitar alta duplicada cuando el RFC ya existe en ERP aunque el usuario intente continuar
    Given que el RFC detectado desde el XML ya existe en el catálogo del ERP
    And que el usuario intenta continuar con el alta manual
    When el sistema valida la creación del proveedor
    Then el sistema bloquea la alta duplicada
    And muestra el mensaje El proveedor ya existe en ERP con el RFC indicado
    And no crea un nuevo proveedor

  Scenario Outline: Validar reglas específicas de NumeroProveedor antes del alta
    Given que el proveedor del XML no existe en el ERP
    And que el usuario captura NumeroProveedor como <numero_proveedor>
    When el sistema valida la estructura del alta
    Then el resultado de la validación es <resultado_validacion>
    And muestra el mensaje <mensaje_esperado>

    Examples:
      | numero_proveedor | resultado_validacion | mensaje_esperado                                         |
      | 12345            | permitido            | El NumeroProveedor es válido para el alta                |
      | 0                | permitido            | El NumeroProveedor es válido para el alta                |
      | vacío            | permitido            | Al no existir NumeroProveedor se utilizará 0             |
      | ABCD             | bloqueo              | El NumeroProveedor debe ser numérico y no aceptar letras |
      | 12-45            | bloqueo              | El NumeroProveedor no debe aceptar caracteres especiales |
      | -1               | bloqueo              | El NumeroProveedor no puede ser negativo                 |

  Scenario Outline: Validar reglas específicas de RFC antes del alta
    Given que el proveedor del XML no existe en el ERP
    And que el RFC detectado desde el XML es <rfc_detectado>
    When el sistema valida el RFC para el alta del proveedor
    Then el resultado de la validación es <resultado_validacion>
    And muestra el mensaje <mensaje_esperado>

    Examples:
      | rfc_detectado  | resultado_validacion | mensaje_esperado                                               |
      | GGT081209393   | permitido            | El RFC es válido para el alta                                  |
      | GGT-081209393  | bloqueo              | El RFC debe capturarse sin guiones y con formato fiscal válido |
      | GGT 081209393  | bloqueo              | El RFC no debe contener espacios innecesarios                  |
      | RFCINVALIDO    | bloqueo              | El RFC no cumple con el formato fiscal esperado                |

  Scenario Outline: Validar reglas de crédito cuando se capturan montos o días para el proveedor
    Given que el proveedor del XML no existe en el ERP
    And que el campo financiero <campo_financiero> tiene el valor <valor_capturado>
    When el sistema valida la información financiera del alta
    Then el resultado de la validación es <resultado_validacion>
    And muestra el mensaje <mensaje_esperado>

    Examples:
      | campo_financiero | valor_capturado | resultado_validacion | mensaje_esperado                                       |
      | DiasCredito      | 30              | permitido            | DiasCredito es válido para el alta                     |
      | DiasCredito      | 0               | permitido            | DiasCredito es válido para el alta                     |
      | DiasCredito      | -1              | bloqueo              | DiasCredito debe ser un entero numérico no negativo    |
      | CreditoPesos     | 15000.75        | permitido            | CreditoPesos es válido para el alta                    |
      | CreditoPesos     | -0.01           | bloqueo              | CreditoPesos debe ser numérico decimal y no negativo   |
      | CreditoDolares   | 2500.00         | permitido            | CreditoDolares es válido para el alta                  |
      | CreditoDolares   | -20.50          | bloqueo              | CreditoDolares debe ser numérico decimal y no negativo |

  Scenario Outline: Informar de forma clara el campo que impide el alta del proveedor
    Given que el proveedor del XML no existe en el ERP
    And que la validación estructural falla por el campo <campo_con_error>
    When el usuario intenta registrar el proveedor
    Then el sistema muestra el mensaje <mensaje_esperado>
    And el mensaje identifica explícitamente el campo <campo_con_error>
    And no permite continuar con el alta

    Examples:
      | campo_con_error | mensaje_esperado                                                              |
      | RFC             | No es posible dar de alta al proveedor porque el RFC es inválido              |
      | NombreFiscal    | No es posible dar de alta al proveedor porque NombreFiscal es obligatorio      |
      | IdEstado        | No es posible dar de alta al proveedor porque IdEstado no existe en catálogo   |
      | CodigoPostal    | No es posible dar de alta al proveedor porque CodigoPostal es inválido         |

  Scenario: Conservar trazabilidad completa cuando el proveedor se crea desde un XML fiscal
    Given que el proveedor del XML no existe en el ERP
    And que el alta del proveedor fue validada exitosamente
    When el sistema crea el proveedor en ERP
    Then registra que el proveedor provino desde un XML fiscal
    And conserva relación entre el RFC del XML y el proveedor creado
    And deja evidencia de la validación realizada antes del alta
