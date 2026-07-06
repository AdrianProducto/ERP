# language: es

Feature: Nuevos derechos de estatus de viaje en módulo Mis Viajes del ERP
  Como administrador del sistema
  Quiero configurar los derechos de estatus de viaje por perfil de operador
  Para controlar qué operadores pueden cambiar el estatus al dar salida, al dar llegada y desde el detalle del viaje

  Background:
    Dado que el administrador ha iniciado sesión en el ERP
    Y accede al módulo "Tráfico"
    Y navega a "Catálogos" y entra a "Parámetros de Configuración"
    Y selecciona la pestaña "App Móviles"
    Y accede a "Config de Licencias"
    Y selecciona un operador de la lista
    Y hace clic en el botón "Derechos"

  # ─────────────────────────────────────────
  # Visualización de los nuevos derechos
  # ─────────────────────────────────────────

  Escenario: Los tres nuevos derechos aparecen en la operación Mis Viajes
    Cuando el administrador expande la operación "Mis Viajes"
    Entonces se muestran los procesos "Estatus Salida", "Estatus Llegada" y "Asignar Estatus"
    Y cada uno muestra un checkbox de habilitado/deshabilitado

  Escenario: Los nuevos derechos están en true por defecto al asignar acceso a Mis Viajes
    Cuando el administrador asigna la operación "Mis Viajes" a un perfil por primera vez
    Entonces los procesos "Estatus Salida", "Estatus Llegada" y "Asignar Estatus" aparecen con valor true

  # ─────────────────────────────────────────
  # Configuración individual de cada derecho
  # ─────────────────────────────────────────

  Esquema del escenario: Configurar individualmente cada nuevo derecho
    Dado que el proceso "<proceso>" está en "<estado_inicial>" para el perfil seleccionado
    Cuando el administrador cambia el checkbox de "<proceso>" a "<nuevo_estado>"
    Y presiona "Aceptar"
    Entonces el sistema persiste el proceso "<proceso>" con valor "<nuevo_estado>"

    Ejemplos:
      | proceso         | estado_inicial | nuevo_estado |
      | Estatus Salida  | true           | false        |
      | Estatus Llegada | true           | false        |
      | Asignar Estatus | true           | false        |
      | Estatus Salida  | false          | true         |
      | Estatus Llegada | false          | true         |
      | Asignar Estatus | false          | true         |

  # ─────────────────────────────────────────
  # Retiro de acceso completo
  # ─────────────────────────────────────────

  Escenario: Al retirar el acceso completo a Mis Viajes los nuevos derechos desaparecen del listado
    Dado que el perfil tiene acceso a la operación "Mis Viajes" con los tres procesos configurados
    Cuando el administrador retira el acceso a la operación "Mis Viajes" del perfil
    Y presiona "Aceptar"
    Entonces la operación "Mis Viajes" ya no aparece en el listado del perfil
    Y los procesos "Estatus Salida", "Estatus Llegada" y "Asignar Estatus" dejan de mostrarse
