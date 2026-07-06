# language: es

Feature: Protección del usuario GM SOPORTE
  Como equipo de soporte de GM Transport
  Quiero que el usuario GM SOPORTE no pueda ser modificado por los usuarios del cliente
  Para garantizar que siempre podamos acceder al sistema y brindar soporte correctamente

  Background:
    Given el usuario tiene sesión activa en el sistema con perfil de Administrador
    And el usuario pertenece a la empresa cliente (no es el usuario GM SOPORTE)
    And existe el usuario GM SOPORTE registrado en el catálogo de usuarios

  # ─── MODIFICAR ────────────────────────────────────────────────────────────────

  Scenario: Intentar modificar al usuario GM SOPORTE desde el listado
    Given el usuario se encuentra en el catálogo de usuarios
    And selecciona al usuario GM SOPORTE en la lista
    When hace clic en el botón "Modificar"
    Then el sistema muestra un mensaje indicando que el usuario GM SOPORTE no puede ser modificado
    And no abre el formulario de edición
    And el usuario GM SOPORTE permanece sin cambios

  Scenario: Intentar guardar cambios sobre el usuario GM SOPORTE desde el formulario
    Given el usuario logra abrir el formulario del usuario GM SOPORTE
    When intenta guardar cualquier cambio
    Then el sistema bloquea la operación
    And muestra un mensaje indicando que ese usuario no puede ser modificado
    And no se aplica ningún cambio

  # ─── INACTIVAR ────────────────────────────────────────────────────────────────

  Scenario: Intentar inactivar al usuario GM SOPORTE
    Given el usuario se encuentra en el formulario del usuario GM SOPORTE
    When desmarca la casilla "Activo" e intenta guardar
    Then el sistema bloquea la operación
    And muestra un mensaje indicando que el usuario GM SOPORTE no puede ser inactivado
    And el usuario GM SOPORTE permanece activo en el sistema

  Scenario: El usuario GM SOPORTE siempre permanece activo tras cualquier intento de cambio
    Given un usuario del cliente realiza cualquier acción sobre el usuario GM SOPORTE
    When el sistema procesa la solicitud
    Then el usuario GM SOPORTE continúa con estatus activo
    And continúa con tipo de usuario Administrador

  # ─── DERECHOS ─────────────────────────────────────────────────────────────────

  Scenario: Intentar modificar los derechos del usuario GM SOPORTE
    Given el usuario se encuentra en el catálogo de usuarios
    And selecciona al usuario GM SOPORTE en la lista
    When hace clic en el botón "Derechos"
    Then el sistema muestra un mensaje indicando que los derechos de ese usuario no pueden ser modificados
    And no permite guardar ningún cambio en sus permisos

  Scenario: Intentar quitar un derecho específico al usuario GM SOPORTE
    Given el usuario logra abrir la pantalla de derechos del usuario GM SOPORTE
    When desmarca algún permiso e intenta guardar
    Then el sistema bloquea la operación
    And los derechos del usuario GM SOPORTE permanecen sin cambios

  # ─── COPIAR DERECHOS ──────────────────────────────────────────────────────────

  Scenario: Intentar copiar derechos de otro usuario sobre el usuario GM SOPORTE
    Given el usuario se encuentra en el catálogo de usuarios
    And selecciona al usuario GM SOPORTE en la lista
    When hace clic en el botón "Copiar Derechos"
    Then el sistema muestra un mensaje indicando que esa acción no está permitida para este usuario
    And no realiza ninguna copia ni modifica los derechos del usuario GM SOPORTE

  # ─── TIPO DE USUARIO ──────────────────────────────────────────────────────────

  Scenario: Intentar cambiar el tipo de usuario GM SOPORTE a un tipo distinto de Administrador
    Given el usuario logra abrir el formulario del usuario GM SOPORTE
    When cambia el tipo de usuario a cualquier opción diferente de Administrador e intenta guardar
    Then el sistema bloquea la operación
    And muestra un mensaje indicando que ese usuario siempre debe ser de tipo Administrador
    And el tipo de usuario del GM SOPORTE permanece como Administrador

  # ─── VISIBILIDAD ──────────────────────────────────────────────────────────────

  Scenario: El usuario GM SOPORTE sigue visible en el listado de usuarios
    Given el usuario se encuentra en el catálogo de usuarios
    When consulta la lista completa de usuarios del sistema
    Then el usuario GM SOPORTE aparece en el listado
    And es visible pero sus opciones de edición están restringidas

  # ─── OTROS USUARIOS NO SE VEN AFECTADOS ──────────────────────────────────────

  Scenario: Modificar un usuario distinto al GM SOPORTE sigue funcionando con normalidad
    Given el usuario se encuentra en el catálogo de usuarios
    And selecciona a cualquier usuario diferente al GM SOPORTE
    When realiza acciones de modificar, derechos o copiar derechos
    Then el sistema responde con normalidad
    And permite realizar los cambios sin restricción adicional
