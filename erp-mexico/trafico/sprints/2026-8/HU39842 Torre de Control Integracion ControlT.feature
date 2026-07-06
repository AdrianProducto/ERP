@Jaqueline @HU39842 @TorreDeControl
Feature: Integración ERP con Torre de Control (ControlT) — Transmisión automática de viajes

    Yo como usuario del módulo de Tráfico
    requiero que los viajes del ERP se transmitan automáticamente a ControlT al asignar operador
    Para que el equipo de monitoreo pueda dar seguimiento en tiempo real sin captura doble de información.

    Background: Given que el usuario tiene acceso al módulo de Tráfico

    # ─── CONFIGURACIÓN DEL SISTEMA ───────────────────────────────────────────

    Scenario: Los campos de configuración solo son visibles cuando la integración está activa
        Given que el usuario accede a la sección de configuración de ControlT
        When el interruptor de integración está desactivado
        Then los campos de credenciales y parámetros de ControlT no se muestran en pantalla

    Scenario: Activar el interruptor muestra los campos de configuración
        Given que el interruptor de integración con ControlT está desactivado
        When el usuario activa el interruptor
        Then el sistema muestra los campos de configuración:
            | Campo                                    |
            | URL del servicio                         |
            | Usuario                                  |
            | Contraseña                               |
            | Código de compañía                       |
            | RFC de la empresa de transporte          |
            | Razón social de la empresa de transporte |
            | Zona horaria (UTC)                       |

    Scenario: Guardar la configuración de ControlT con todos los campos requeridos
        Given que el usuario activó el interruptor de integración
        And ingresó todos los campos de configuración requeridos
        When el usuario guarda la configuración
        Then el sistema almacena las credenciales y parámetros
        And los viajes futuros comenzarán a transmitirse a ControlT al asignar operador

    Scenario: No se puede guardar la configuración si faltan campos obligatorios
        Given que el usuario activó el interruptor de integración
        And dejó vacío al menos un campo obligatorio de configuración
        When el usuario intenta guardar la configuración
        Then el sistema muestra un mensaje indicando los campos faltantes
        And no guarda la configuración

    Scenario: Deshabilitar la integración con ControlT
        Given que la integración con ControlT está habilitada
        When el usuario desactiva el interruptor de integración
        Then el sistema deja de transmitir viajes a ControlT
        And el listado de viajes muestra el icono "No aplica" para todos los registros

    # ─── CATÁLOGO DE ORÍGENES Y DESTINOS ─────────────────────────────────────

    Scenario: Registrar código postal en un origen o destino
        Given que el usuario accede al catálogo de orígenes y destinos
        When agrega o edita un lugar e ingresa el código postal
        Then el sistema guarda el código postal del lugar
        And el código de estado se resuelve automáticamente desde el catálogo de ControlT

    Scenario: Intentar transmitir un viaje cuyo origen o destino no tiene código postal
        Given que un origen o destino del viaje no tiene código postal registrado
        When el usuario asigna operador al viaje
        Then el sistema registra un error de transmisión
        And el estatus ControlT del viaje muestra el icono de "Error"
        And el ERP no bloquea el viaje y continúa su proceso normal

    # ─── CATÁLOGO DE TIPOS DE VIAJE ──────────────────────────────────────────

    Scenario: Configurar equivalencia ControlT en un tipo de viaje
        Given que el usuario accede al catálogo de tipos de viaje
        When selecciona un tipo de viaje y le asigna la equivalencia ControlT del 1 al 9
        Then el sistema guarda la relación entre el tipo de viaje del ERP y el código ControlT

    Scenario: Intentar transmitir un viaje cuyo tipo no tiene equivalencia ControlT configurada
        Given que el tipo de viaje del registro no tiene equivalencia ControlT asignada
        When el usuario asigna operador al viaje
        Then el sistema registra un error de transmisión
        And el estatus ControlT del viaje muestra el icono de "Error"
        And el ERP no bloquea el viaje

    # ─── TRANSMISIÓN AL ASIGNAR OPERADOR ─────────────────────────────────────

    Scenario: Transmisión exitosa al asignar operador
        Given que el viaje tiene todos los datos completos y correctos
        When el usuario asigna operador y unidad al viaje
        Then el sistema envía el viaje a ControlT automáticamente
        And el sistema guarda el ID interno que ControlT asignó al viaje
        And el estatus ControlT del viaje muestra el icono de "Enviado"

    Scenario: ControlT no disponible al momento de la asignación
        Given que el servicio de ControlT no está disponible
        When el usuario asigna operador al viaje
        Then el ERP completa la asignación normalmente sin bloquearse
        And el estatus ControlT del viaje muestra el icono de "Error"
        And se registra el detalle del error para consulta posterior

    Scenario: La integración está desactivada al momento de la asignación
        Given que la integración con ControlT está desactivada
        When el usuario asigna operador al viaje
        Then el ERP completa la asignación sin intentar transmitir a ControlT
        And el estatus ControlT del viaje muestra el icono de "No aplica"

    Scenario: El cliente del viaje no tiene RFC registrado
        Given que el cliente del viaje no tiene RFC en su catálogo
        When el usuario asigna operador al viaje
        Then el sistema registra un error de transmisión
        And el estatus ControlT del viaje muestra el icono de "Error"
        And el ERP no bloquea la asignación del operador

    Scenario: El operador no tiene teléfono celular registrado
        Given que el operador asignado al viaje no tiene teléfono celular en su catálogo
        When el usuario asigna operador al viaje
        Then el sistema transmite el viaje a ControlT usando un valor genérico en el campo de teléfono
        And si los demás datos son correctos el estatus muestra el icono de "Enviado"

    Scenario: Token de sesión con ControlT expirado al momento de la transmisión
        Given que el token de sesión con ControlT ha expirado
        When el usuario asigna operador al viaje
        Then el sistema renueva el token automáticamente sin intervención del usuario
        And reintenta la transmisión del viaje
        And si la transmisión es exitosa el estatus muestra el icono de "Enviado"
        And si la renovación del token falla el estatus muestra el icono de "Error"

    # ─── RETRANSMISIÓN AL MODIFICAR ──────────────────────────────────────────

    Scenario: Retransmisión al modificar un viaje previamente enviado
        Given que el viaje tiene estatus ControlT "Enviado"
        When el usuario modifica datos del viaje y guarda los cambios
        Then el sistema retransmite el viaje actualizado a ControlT automáticamente

    Scenario: No retransmitir si el viaje nunca fue enviado exitosamente
        Given que el viaje tiene estatus ControlT "Error" o "Pendiente"
        When el usuario modifica datos del viaje y guarda los cambios
        Then el sistema no intenta retransmitir a ControlT
        And el estatus ControlT permanece sin cambio

    # ─── CANCELACIÓN ─────────────────────────────────────────────────────────

    Scenario: Notificar cancelación a ControlT cuando el viaje fue enviado
        Given que el viaje tiene estatus ControlT "Enviado"
        When el usuario cancela el viaje en el ERP
        Then el sistema envía la cancelación a ControlT automáticamente
        And el estatus ControlT del viaje refleja la cancelación

    Scenario: No notificar cancelación si el viaje nunca fue transmitido
        Given que el viaje tiene estatus ControlT diferente a "Enviado"
        When el usuario cancela el viaje en el ERP
        Then el ERP cancela el viaje sin intentar notificar a ControlT

    # ─── LISTADO DE VIAJES — ICONOS Y REINTENTO ──────────────────────────────

    Scenario: Visualizar el icono de estatus ControlT en el listado de viajes
        Given que el usuario accede al listado de viajes
        Then cada registro muestra un icono de estatus ControlT
        And los posibles iconos corresponden a: "Enviado", "Error", "Pendiente" o "No aplica"

    Scenario: Reintentar transmisión desde el listado cuando el dato fue corregido
        Given que un viaje tiene estatus ControlT "Error"
        And el dato que causó el error ya fue corregido
        When el usuario hace clic en el icono de reintento del viaje
        Then el sistema valida nuevamente todos los datos del viaje
        And la transmisión se completa exitosamente
        And el icono de estatus ControlT cambia a "Enviado"

    Scenario: Reintento fallido porque el dato aún no fue corregido
        Given que un viaje tiene estatus ControlT "Error"
        And el dato que causó el error no ha sido corregido
        When el usuario hace clic en el icono de reintento
        Then el sistema registra nuevamente el error
        And el icono de estatus ControlT permanece en "Error"

    # ─── INDEPENDENCIA DE ESTATUS ─────────────────────────────────────────────

    Scenario: El estatus del viaje en el ERP no se ve afectado por eventos en ControlT
        Given que un viaje fue transmitido exitosamente a ControlT
        When ocurre cualquier cambio o evento en ControlT
        Then el estatus del viaje en el ERP no se modifica
        And ambos sistemas operan de forma completamente independiente

    # ─── MULTI-PAÍS ──────────────────────────────────────────────────────────

    Scenario Outline: Documento de identidad del conductor según país
        Given que el usuario trabaja en una base de datos configurada para el país "<pais>"
        When el sistema transmite un viaje a ControlT
        Then el campo de identificación del conductor utiliza el "<documento>"

        Ejemplos:
        | pais      | documento |
        | México    | CURP      |
        | Guatemala | CUI       |
