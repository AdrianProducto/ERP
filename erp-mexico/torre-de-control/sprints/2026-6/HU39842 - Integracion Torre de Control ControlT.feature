# language: es

Feature: Integración automática de viajes con Torre de Control (ControlT)
  Como usuario del módulo de Registro de Viajes
  Quiero que los viajes se transmitan automáticamente a ControlT al asignarlos o cancelarlos
  Para evitar la captura manual en ambos sistemas y tener visibilidad del estatus de transmisión

  Background:
    Given el usuario tiene sesión activa en el ERP de GM Transport
    And el usuario tiene acceso al módulo de Registro de Viajes

  # ─────────────────────────────────────────────────────────────
  # TRANSMISIÓN AL ASIGNAR
  # ─────────────────────────────────────────────────────────────

  Scenario: Transmisión exitosa a ControlT al asignar unidad y operador a un viaje
    Given existe un viaje registrado con trayectos, origen y destino con código DANE capturado
    And la unidad asignada tiene placas registradas en el catálogo
    And el operador asignado tiene número de identificación Colombia registrado
    And el viaje tiene el campo "Tipo de viaje ControlT" capturado
    When el usuario asigna la unidad y el operador al viaje
    Then el sistema transmite automáticamente el viaje a ControlT
    And el viaje muestra el estatus de ControlT como "Enviado" en el listado de viajes
    And el usuario no necesita realizar ninguna acción adicional

  Scenario: El listado de viajes muestra la columna de estatus ControlT
    Given existen viajes registrados con diferentes estatus de transmisión
    When el usuario accede al listado de viajes
    Then el listado muestra la columna "Estatus ControlT" para cada viaje
    And los valores posibles son: Enviado, Pendiente o Error

  Scenario: Reenvío manual de un viaje a ControlT desde el registro
    Given existe un viaje con estatus ControlT "Error"
    When el usuario abre el registro del viaje
    And hace clic en el botón de reenvío a ControlT
    Then el sistema vuelve a transmitir el viaje a ControlT
    And actualiza el estatus ControlT del viaje según el resultado del reenvío

  Scenario: El viaje continúa registrado normalmente cuando el envío a ControlT falla
    Given existe un viaje con unidad, operador y tipo de viaje ControlT capturados
    And la plataforma ControlT no está disponible al momento de la asignación
    When el usuario asigna la unidad y el operador al viaje
    Then el viaje queda registrado y asignado correctamente en el ERP
    And el estatus ControlT del viaje queda como "Error"
    And el sistema registra el incidente para seguimiento por el equipo de soporte

  # ─────────────────────────────────────────────────────────────
  # CANCELACIÓN
  # ─────────────────────────────────────────────────────────────

  Scenario: Notificación automática de cancelación a ControlT al cancelar un viaje
    Given existe un viaje previamente transmitido a ControlT con estatus "Enviado"
    When el usuario cancela el viaje en el ERP
    Then el sistema notifica automáticamente la cancelación a ControlT
    And el viaje queda cancelado en el ERP con normalidad
    And el estatus ControlT del viaje se actualiza en el listado

  Scenario: Cancelar un viaje que nunca fue enviado a ControlT
    Given existe un viaje con estatus ControlT "Pendiente" o "Error"
    When el usuario cancela el viaje en el ERP
    Then el viaje queda cancelado en el ERP
    And el sistema no intenta notificar a ControlT al no existir un registro previo

  # ─────────────────────────────────────────────────────────────
  # INDEPENDENCIA DE ESTATUS
  # ─────────────────────────────────────────────────────────────

  Scenario: Un cambio de estatus en ControlT no modifica el estatus del viaje en el ERP
    Given existe un viaje transmitido a ControlT con estatus "Enviado"
    When ControlT actualiza el estatus del recorrido en su plataforma
    Then el estatus del viaje en el ERP permanece sin cambios
    And el ERP no recibe ni procesa actualizaciones de estatus provenientes de ControlT

  # ─────────────────────────────────────────────────────────────
  # NUEVO CAMPO: TIPO DE VIAJE CONTROLT
  # ─────────────────────────────────────────────────────────────

  Scenario: Captura del tipo de viaje ControlT en el registro de viaje
    Given el usuario está en el registro de un viaje nuevo
    When accede al campo "Tipo de viaje ControlT"
    Then el sistema muestra una lista de opciones definidas por ControlT
    And el usuario puede seleccionar el tipo que corresponde al servicio

  Scenario: Intentar asignar un viaje sin haber capturado el tipo de viaje ControlT
    Given existe un viaje sin el campo "Tipo de viaje ControlT" capturado
    When el usuario asigna unidad y operador al viaje
    Then el sistema muestra un aviso indicando que el campo "Tipo de viaje ControlT" es requerido para la transmisión
    And no transmite el viaje a ControlT hasta que el campo sea capturado

  # ─────────────────────────────────────────────────────────────
  # CATÁLOGO DE CIUDADES — CÓDIGO DANE
  # ─────────────────────────────────────────────────────────────

  Scenario: Captura del código DANE en el catálogo de orígenes y destinos
    Given el usuario accede al catálogo de Orígenes y Destinos
    When abre el registro de una ciudad en Colombia
    Then el registro muestra el campo "Código DANE"
    And el usuario puede capturar o editar el código de ciudad correspondiente

  Scenario: Transmisión bloqueada cuando una parada no tiene código DANE capturado
    Given existe un viaje con una parada cuya ciudad no tiene código DANE registrado
    When el usuario asigna unidad y operador al viaje
    Then el sistema no transmite el viaje a ControlT
    And muestra un aviso indicando qué parada tiene la ciudad con código DANE faltante

  # ─────────────────────────────────────────────────────────────
  # CATÁLOGO DE OPERADORES — IDENTIFICACIÓN COLOMBIA
  # ─────────────────────────────────────────────────────────────

  Scenario: Captura del número de identificación Colombia en el catálogo de operadores
    Given el usuario accede al catálogo de Operadores
    When abre el registro de un operador que opera en Colombia
    Then el registro muestra el campo "Número de identificación Colombia"
    And el usuario puede capturar la cédula o número de identificación del operador

  Scenario: Transmisión bloqueada cuando el operador no tiene identificación Colombia registrada
    Given existe un viaje asignado a un operador sin identificación Colombia capturada
    When el usuario asigna el operador al viaje
    Then el sistema no transmite el viaje a ControlT
    And muestra un aviso indicando que el operador no tiene número de identificación Colombia registrado

  # ─────────────────────────────────────────────────────────────
  # CATÁLOGO DE UNIDADES — TIPO DE VEHÍCULO
  # ─────────────────────────────────────────────────────────────

  Scenario Outline: Determinación automática del tipo de vehículo para ControlT
    Given existe una unidad con las siguientes características en el catálogo: <caracteristica>
    When el viaje con esa unidad es transmitido a ControlT
    Then el sistema envía automáticamente el tipo de vehículo "<tipo_controlt>"

    Examples:
      | caracteristica                        | tipo_controlt |
      | unidad propia (ni rentada ni tercero) | Propio        |
      | unidad marcada como rentada           | Rentado       |
      | unidad de permisionario o tercero     | Tercero       |

  # ─────────────────────────────────────────────────────────────
  # FUERA DE ALCANCE — VALIDACIONES NEGATIVAS
  # ─────────────────────────────────────────────────────────────

  Scenario: El ERP no muestra el estatus del recorrido en tiempo real desde ControlT
    Given existe un viaje transmitido a ControlT
    When el usuario revisa el registro del viaje en el ERP
    Then el ERP no muestra información de seguimiento o ubicación en tiempo real proveniente de ControlT

  Scenario: No es posible modificar un viaje ya transmitido a ControlT desde el ERP
    Given existe un viaje con estatus ControlT "Enviado"
    When el usuario intenta modificar datos del recorrido desde el ERP
    Then el ERP gestiona la modificación de forma normal en su propio flujo
    And no reenvía ni actualiza el registro en ControlT por cambios en los datos del viaje
