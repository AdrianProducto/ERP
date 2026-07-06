# language: es
# HU Técnica: Worker de polling configurable para sincronización de permisos desde GestorOperadores

@mis-viajes @tecnico
Feature: Worker de polling para sincronización de permisos desde GestorOperadores
  Como sistema backend de Mis Viajes
  Quiero un worker configurable que consulte GestorOperadores periódicamente
  Para detectar cambios de permisos y notificar a los operadores con sesión activa vía WebSocket

  Background:
    Dado que el worker de permisos está iniciado
    Y el intervalo de polling está configurado en la variable PERMISOS_POLLING_INTERVAL (default: 12h)
    Y el servicio GestorOperadores está disponible en 192.168.2.248:9436

  # ─────────────────────────────────────────
  # INICIALIZACIÓN DEL WORKER
  # ─────────────────────────────────────────

  @smoke @worker
  Escenario: El worker inicia con el intervalo definido en la variable de configuración
    Dado que la variable PERMISOS_POLLING_INTERVAL tiene el valor "12h"
    Cuando el backend inicia
    Entonces el worker de permisos arranca con un ticker de 12 horas
    Y registra en el log "Worker de permisos iniciado con intervalo: 12h"

  @worker @configuracion
  Escenario: El intervalo del worker se toma de la variable de entorno sin recompilar
    Dado que la variable PERMISOS_POLLING_INTERVAL se cambia a "30m"
    Cuando el backend reinicia
    Entonces el worker arranca con un ticker de 30 minutos
    Y el comportamiento del polling refleja el nuevo intervalo

  # ─────────────────────────────────────────
  # DETECCIÓN DE CAMBIOS
  # ─────────────────────────────────────────

  @smoke @polling
  Escenario: El worker detecta cambio de permisos y emite evento WebSocket
    Dado que el operador "OP-001" tiene una sesión WebSocket activa
    Y el hash de sus permisos almacenado es "abc123"
    Y GestorOperadores devuelve un hash diferente "def456" para "OP-001"
    Cuando el worker ejecuta el ciclo de polling
    Entonces el backend emite el evento "permissions_updated" por WebSocket al operador "OP-001"
    Y actualiza el hash almacenado a "def456"
    Y registra en el log "Permisos actualizados para operador OP-001"

  @polling
  Escenario: El worker no emite evento si los permisos no cambiaron
    Dado que el operador "OP-001" tiene una sesión WebSocket activa
    Y el hash de sus permisos almacenado es "abc123"
    Y GestorOperadores devuelve el mismo hash "abc123" para "OP-001"
    Cuando el worker ejecuta el ciclo de polling
    Entonces no se emite ningún evento WebSocket para el operador "OP-001"
    Y el hash almacenado permanece como "abc123"

  @polling
  Escenario: El worker omite operadores sin sesión WebSocket activa
    Dado que el operador "OP-002" no tiene sesión WebSocket activa
    Cuando el worker ejecuta el ciclo de polling
    Entonces no se consulta GestorOperadores para el operador "OP-002"
    Y no se emite ningún evento para ese operador

  # ─────────────────────────────────────────
  # MANEJO DE ERRORES
  # ─────────────────────────────────────────

  @error @polling
  Escenario: GestorOperadores no responde durante el ciclo de polling
    Dado que GestorOperadores no está disponible al momento del polling
    Cuando el worker ejecuta el ciclo de polling
    Entonces el worker registra el error en el log interno
    Y no emite ningún evento WebSocket a los operadores
    Y el hash almacenado no se modifica
    Y el worker continúa funcionando para el siguiente ciclo

  @error @polling
  Escenario: GestorOperadores responde con error para un operador específico
    Dado que GestorOperadores devuelve un error 500 para el operador "OP-003"
    Y devuelve respuesta correcta para los demás operadores
    Cuando el worker ejecuta el ciclo de polling
    Entonces el error de "OP-003" se registra en el log
    Y los demás operadores con cambios reciben su evento normalmente
    Y el worker no se detiene por el error individual

  # ─────────────────────────────────────────
  # FLUTTER — RECEPCIÓN DEL EVENTO
  # ─────────────────────────────────────────

  @smoke @flutter
  Escenario: La app Flutter recibe el evento y actualiza permisos en memoria
    Dado que el operador tiene la app activa con sesión WebSocket
    Cuando la app recibe el evento "permissions_updated" desde el backend
    Entonces AuthWebSocketManager dispara RefreshPermisosUseCase
    Y el AuthBloc recibe el evento PermisosActualizadosEvent
    Y se re-ejecuta ModulePermissionService.initializeFeatureModulesConditionally()
    Y los nuevos permisos quedan en AuthBloc.state sin reiniciar la sesión

  @flutter
  Escenario: La app muestra una notificación sutil al actualizar permisos
    Dado que la app recibió y procesó el evento "permissions_updated"
    Cuando los permisos se actualizan correctamente en memoria
    Entonces se muestra un toast no intrusivo con el texto "Tus permisos han sido actualizados"
    Y el toast desaparece automáticamente sin requerir acción del usuario

  @flutter @error
  Escenario: La app falla al procesar el evento de permisos actualizados
    Dado que la app recibió el evento "permissions_updated"
    Y RefreshPermisosUseCase falla al consultar los nuevos permisos
    Entonces el error se registra en el log local de la app
    Y no se muestra ningún mensaje de error al operador
    Y los permisos anteriores permanecen activos hasta el próximo intento

  # ─────────────────────────────────────────
  # ESQUEMA — VARIACIÓN DE INTERVALO
  # ─────────────────────────────────────────

  @configuracion
  Esquema del escenario: El worker respeta el intervalo configurado en la variable de entorno
    Dado que la variable PERMISOS_POLLING_INTERVAL tiene el valor "<intervalo>"
    Cuando el backend inicia el worker
    Entonces el ticker del worker se configura con un periodo de "<intervalo>"
    Y el log muestra "Worker de permisos iniciado con intervalo: <intervalo>"

    Ejemplos:
      | intervalo |
      | 30m       |
      | 1h        |
      | 6h        |
      | 12h       |
      | 24h       |
