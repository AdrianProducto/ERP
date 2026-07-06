# language: es
# ══════════════════════════════════════════════════════════════════════
#  🆘  HU-35074 · ENVÍO DE NOTIFICACIÓN SOS SIN INTERFAZ GPS
#  🖥️  Contexto: ERP GM Transport — Configuración por Administrador
#  📅  Sprint: Junio 2026
# ══════════════════════════════════════════════════════════════════════
#
#  Reglas clave:
#  · La configuración de correos SOS es por cliente
#  · Solo usuarios con perfil Administrador pueden gestionar esta configuración
#  · El check controla ÚNICAMENTE el envío de correo (la campanita siempre se dispara)
#  · Máximo 5 correos por cliente; nombre y correo son obligatorios
#  · Correos únicos por cliente (validación case-insensitive)
#  · No hay edición inline — para cambiar un correo: eliminar y volver a agregar
#  · Los correos configurados se conservan aunque el check esté desactivado
# ══════════════════════════════════════════════════════════════════════

Feature: Configuración de correos SOS en el ERP
  Como Administrador del ERP GM Transport
  Quiero configurar los destinatarios de correo para la alerta SOS por cliente
  Para que las personas correctas reciban el correo cuando un operador active el SOS

  # ══════════════════════════════════════════════════════════════════
  #  ✅  FLUJO PRINCIPAL — Activar y configurar correos SOS
  # ══════════════════════════════════════════════════════════════════

  Scenario: Administrador activa el check SOS y agrega un correo válido
    Given el usuario tiene perfil de Administrador en el ERP
    And accede a Parámetros de Configuración de Tráfico > pestaña Apps Móviles
    When activa el check "Enviar notificación SOS por correo"
    And captura el nombre "LUIS" y el correo "luis.calidad@gmtransporterp.com"
    And hace clic en el botón "+"
    Then el correo queda registrado en la tabla de destinatarios del cliente
    And la tabla muestra la fila con nombre "LUIS" y correo "luis.calidad@gmtransporterp.com"

 

  Scenario: Administrador elimina un correo de la lista
    Given el usuario tiene perfil de Administrador en el ERP
    And accede a Parámetros de Configuración de Tráfico > pestaña Apps Móviles
    And la lista de correos SOS contiene los registros "LUIS" y "DAVID"
    When el administrador hace clic en el botón eliminar del registro "DAVID"
    Then el registro "DAVID" desaparece de la tabla
    And el registro "LUIS" permanece sin cambios

  # ══════════════════════════════════════════════════════════════════
  #  🔀  FLUJOS ALTERNATIVOS — Casos válidos en la configuración
  # ══════════════════════════════════════════════════════════════════

  Scenario: Administrador activa el check SOS sin agregar correos
    Given el usuario tiene perfil de Administrador en el ERP
    And accede a Parámetros de Configuración de Tráfico > pestaña Apps Móviles
    When activa el check "Enviar notificación SOS por correo"
    And no agrega ningún correo a la lista
    Then el check queda marcado como activo en la pantalla
    And la tabla de destinatarios permanece vacía

  Scenario: Administrador desactiva el check SOS — correos se conservan
    Given el usuario tiene perfil de Administrador en el ERP
    And accede a Parámetros de Configuración de Tráfico > pestaña Apps Móviles
    And el check "Enviar notificación SOS por correo" está activo
    And la lista tiene al menos un correo configurado
    When el administrador desactiva el check
    Then el check queda desmarcado en la pantalla
    And los correos configurados permanecen visibles en la tabla

  Scenario: Administrador reactiva el check SOS — correos previos siguen disponibles
    Given el usuario tiene perfil de Administrador en el ERP
    And accede a Parámetros de Configuración de Tráfico > pestaña Apps Móviles
    And el check "Enviar notificación SOS por correo" está desactivado
    And la tabla contiene correos configurados de una activación anterior
    When el administrador reactiva el check
    Then el check queda marcado como activo en la pantalla
    And los correos previamente configurados siguen visibles en la tabla sin cambios

  Scenario: Configuración de correos SOS es independiente entre clientes
    Given el usuario tiene perfil de Administrador en el ERP
    And el cliente "CLIENTE A" tiene configurados los correos "luis@clienteA.com" y "david@clienteA.com"
    When el administrador accede a la configuración del cliente "CLIENTE B"
    Then la tabla de correos SOS del cliente "CLIENTE B" no muestra los correos del cliente "CLIENTE A"

  # ══════════════════════════════════════════════════════════════════
  #  ❌  ERRORES Y LÍMITES — Validaciones al agregar correos
  # ══════════════════════════════════════════════════════════════════

  Scenario: Administrador intenta guardar un correo con formato inválido
    Given el usuario tiene perfil de Administrador en el ERP
    And accede a Parámetros de Configuración de Tráfico > pestaña Apps Móviles
    When captura el nombre "JOSE" y el correo "jose.correo-invalido"
    And hace clic en el botón "+"
    Then el sistema muestra un error de validación en el campo de correo
    And no agrega el registro a la tabla

  Scenario: Administrador deja el campo Nombre vacío
    Given el usuario tiene perfil de Administrador en el ERP
    And accede a Parámetros de Configuración de Tráfico > pestaña Apps Móviles
    When deja el campo "Nombre" vacío
    And captura un correo válido
    And hace clic en el botón "+"
    Then el sistema muestra un error indicando que el nombre es obligatorio
    And no agrega el registro a la tabla

  Scenario: Administrador deja el campo Correo vacío
    Given el usuario tiene perfil de Administrador en el ERP
    And accede a Parámetros de Configuración de Tráfico > pestaña Apps Móviles
    When captura el nombre "PEDRO"
    And deja el campo "Correo electrónico" vacío
    And hace clic en el botón "+"
    Then el sistema muestra un error indicando que el correo es obligatorio
    And no agrega el registro a la tabla

  Scenario: Administrador deja ambos campos vacíos
    Given el usuario tiene perfil de Administrador en el ERP
    And accede a Parámetros de Configuración de Tráfico > pestaña Apps Móviles
    When deja el campo "Nombre" vacío
    And deja el campo "Correo electrónico" vacío
    And hace clic en el botón "+"
    Then el sistema muestra error en ambos campos indicando que son obligatorios
    And no agrega ningún registro a la tabla

  # ══════════════════════════════════════════════════════════════════
  #  🛡️  VALIDACIONES — Duplicados en la lista de correos
  # ══════════════════════════════════════════════════════════════════

  Scenario Outline: Administrador intenta agregar un correo duplicado en cualquier capitalización
    Given el usuario tiene perfil de Administrador en el ERP
    And accede a Parámetros de Configuración de Tráfico > pestaña Apps Móviles
    And la lista de correos SOS ya contiene el correo "<correo_existente>"
    When el administrador captura el nombre "NUEVO" y el correo "<correo_nuevo>"
    And hace clic en el botón "+"
    Then el sistema muestra un mensaje indicando que el correo ya está registrado
    And no agrega el registro a la tabla

    Examples:
      | correo_existente                | correo_nuevo                    |
      | luis.calidad@gmtransporterp.com | luis.calidad@gmtransporterp.com |
      | luis.calidad@gmtransporterp.com | LUIS.CALIDAD@GMTRANSPORTERP.COM |
      | luis.calidad@gmtransporterp.com | Luis.Calidad@gmtransporterp.com |

  # ══════════════════════════════════════════════════════════════════
  #  🔐  PERMISOS — Control de acceso por perfil de usuario
  # ══════════════════════════════════════════════════════════════════

  Scenario: Usuario sin perfil de Administrador no ve la opción de configuración SOS
    Given el usuario tiene un perfil distinto a Administrador
    When accede a Parámetros de Configuración de Tráfico > pestaña Apps Móviles
    Then la opción "Enviar notificación SOS por correo" no es visible en la pantalla


