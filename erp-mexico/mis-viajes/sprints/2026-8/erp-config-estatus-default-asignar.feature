# language: es

Feature: Configuración del estatus por defecto para Dar Salida y Dar Llegada en App Móviles
  Como administrador del sistema
  Quiero configurar el estatus que se muestra por defecto en los selects de Dar Salida y Dar Llegada de Mis Viajes
  Para que los operadores partan de un valor predefinido al cambiar el estatus del viaje

  Background:
    Dado que el administrador ha iniciado sesión en el ERP
    Y accede al módulo "Tráfico"
    Y navega a "Catálogos" y entra a "Parámetros de Configuración"
    Y selecciona la pestaña "App Móviles"
    Y visualiza la sección "Mis Viajes"

  # ─────────────────────────────────────────
  # Visualización de los nuevos campos
  # ─────────────────────────────────────────

  Escenario: Se muestran los nuevos selects de estatus por defecto en la sección Mis Viajes
    Entonces aparece el campo "Estatus por Defecto Dar Salida Móvil"
    Y aparece el campo "Estatus por Defecto Dar Llegada Móvil"
    Y cada campo muestra un select con los estatus disponibles del ERP

  # ─────────────────────────────────────────
  # Inicialización del campo en el ERP
  # ─────────────────────────────────────────

  Escenario: Los selects se inicializan con el primer registro del catálogo cuando no tienen valor guardado
    Dado que los campos "Estatus por Defecto Dar Salida Móvil" y "Estatus por Defecto Dar Llegada Móvil" nunca han sido configurados
    Cuando el administrador abre la pestaña "App Móviles"
    Entonces ambos selects aparecen inicializados con el primer registro del catálogo de estatus
    Y ninguno de los campos queda en null

  # ─────────────────────────────────────────
  # Configuración y persistencia
  # ─────────────────────────────────────────

  Esquema del escenario: El administrador configura el estatus por defecto y se persiste correctamente
    Dado que el campo "<campo>" está visible en la sección "Mis Viajes"
    Cuando el administrador selecciona un estatus en "<campo>"
    Y presiona "Guardar"
    Entonces el sistema persiste el valor seleccionado para "<campo>"
    Y al reabrir la pantalla el campo muestra el valor guardado

    Ejemplos:
      | campo                              |
      | Estatus por Defecto Dar Salida Móvil  |
      | Estatus por Defecto Dar Llegada Móvil |

  Escenario: Los dos campos se pueden configurar con valores distintos de forma independiente
    Cuando el administrador selecciona "DOCUMENTADO" en "Estatus por Defecto Dar Salida Móvil"
    Y selecciona "TERMINADO" en "Estatus por Defecto Dar Llegada Móvil"
    Y presiona "Guardar"
    Entonces el sistema persiste "DOCUMENTADO" para "Estatus por Defecto Dar Salida Móvil"
    Y el sistema persiste "TERMINADO" para "Estatus por Defecto Dar Llegada Móvil"
