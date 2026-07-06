# language: es

Feature: Control de estatus de viaje según derechos del operador en Mis Viajes
  Como operador de transporte
  Quiero que la aplicación respete mis derechos asignados en el ERP
  Para que solo pueda cambiar el estatus del viaje en los flujos que tengo permitidos

  Background:
    Dado que el operador ha iniciado sesión en la aplicación Mis Viajes
    Y los derechos del operador fueron cargados desde el ERP al iniciar sesión
    Y el operador tiene un viaje asignado con un trayecto seleccionado

  # ─────────────────────────────────────────
  # Derecho: Estatus Salida
  # ─────────────────────────────────────────

  Escenario: Select de estatus habilitado en Dar salida cuando Estatus Salida es true
    Dado que el operador tiene el proceso "Estatus Salida" en true
    Y el trayecto se encuentra en estado "Sin salida"
    Cuando el operador abre la pantalla "Dar salida"
    Entonces el select de estatus del viaje está habilitado
    Y el operador puede seleccionar un estatus antes de confirmar la salida

  Escenario: Select de estatus deshabilitado en Dar salida cuando Estatus Salida es false
    Dado que el operador tiene el proceso "Estatus Salida" en false
    Y el trayecto se encuentra en estado "Sin salida"
    Cuando el operador abre la pantalla "Dar salida"
    Entonces el select de estatus del viaje aparece deshabilitado
    Y el select aparece sin valor preseleccionado
    Y el operador no puede modificar el estatus del viaje en esa pantalla

  Escenario: Intentar interactuar con el select deshabilitado en Dar salida muestra mensaje de sin permiso
    Dado que el operador tiene el proceso "Estatus Salida" en false
    Y el trayecto se encuentra en estado "Sin salida"
    Cuando el operador abre la pantalla "Dar salida"
    Y el operador intenta tocar el select de estatus
    Entonces se muestra un mensaje indicando que no tiene permiso para realizar esta acción

  # ─────────────────────────────────────────
  # Derecho: Estatus Llegada
  # ─────────────────────────────────────────

  Escenario: Select de estatus habilitado en Dar llegada cuando Estatus Llegada es true
    Dado que el operador tiene el proceso "Estatus Llegada" en true
    Y el trayecto se encuentra en estado "En ruta"
    Cuando el operador abre la pantalla "Dar llegada"
    Entonces el select de estatus del viaje está habilitado
    Y el operador puede seleccionar un estatus antes de confirmar la llegada

  Escenario: Select de estatus deshabilitado en Dar llegada cuando Estatus Llegada es false
    Dado que el operador tiene el proceso "Estatus Llegada" en false
    Y el trayecto se encuentra en estado "En ruta"
    Cuando el operador abre la pantalla "Dar llegada"
    Entonces el select de estatus del viaje aparece deshabilitado
    Y el select aparece sin valor preseleccionado
    Y el operador no puede modificar el estatus del viaje en esa pantalla

  Escenario: Intentar interactuar con el select deshabilitado en Dar llegada muestra mensaje de sin permiso
    Dado que el operador tiene el proceso "Estatus Llegada" en false
    Y el trayecto se encuentra en estado "En ruta"
    Cuando el operador abre la pantalla "Dar llegada"
    Y el operador intenta tocar el select de estatus
    Entonces se muestra un mensaje indicando que no tiene permiso para realizar esta acción

  # ─────────────────────────────────────────
  # Derecho: Asignar Estatus
  # ─────────────────────────────────────────

  Escenario: Botón Asignar estatus activo cuando el derecho es true
    Dado que el operador tiene el proceso "Asignar Estatus" en true
    Cuando el operador accede al detalle del viaje
    Entonces el botón "Asignar estatus" aparece activo y puede ser presionado

  Escenario: Botón Asignar estatus desactivado cuando el derecho es false
    Dado que el operador tiene el proceso "Asignar Estatus" en false
    Cuando el operador accede al detalle del viaje
    Entonces el botón "Asignar estatus" aparece desactivado
    Y el operador no puede asignar un estatus desde esa opción

  Escenario: Presionar el botón desactivado muestra mensaje de sin permiso
    Dado que el operador tiene el proceso "Asignar Estatus" en false
    Cuando el operador accede al detalle del viaje
    Y el operador intenta presionar el botón "Asignar estatus"
    Entonces se muestra un mensaje indicando que no tiene permiso para realizar esta acción
    Y el panel de asignación de estatus no se abre

  # ─────────────────────────────────────────
  # Esquemas combinados
  # ─────────────────────────────────────────

  Esquema del escenario: Control del select de estatus según derecho y pantalla
    Dado que el operador tiene el proceso "<proceso>" en "<valor>"
    Y el trayecto se encuentra en estado "<estado_trayecto>"
    Cuando el operador abre la pantalla "<pantalla>"
    Entonces el select de estatus del viaje está "<estado_control>"

    Ejemplos:
      | proceso         | valor | estado_trayecto | pantalla    | estado_control |
      | Estatus Salida  | true  | Sin salida      | Dar salida  | habilitado     |
      | Estatus Salida  | false | Sin salida      | Dar salida  | deshabilitado  |
      | Estatus Llegada | true  | En ruta         | Dar llegada | habilitado     |
      | Estatus Llegada | false | En ruta         | Dar llegada | deshabilitado  |

  Esquema del escenario: Control del botón Asignar estatus según derecho
    Dado que el operador tiene el proceso "Asignar Estatus" en "<valor>"
    Cuando el operador accede al detalle del viaje
    Entonces el botón "Asignar estatus" aparece "<estado_boton>"

    Ejemplos:
      | valor | estado_boton |
      | true  | activo       |
      | false | desactivado  |

  # ─────────────────────────────────────────
  # Independencia de derechos
  # ─────────────────────────────────────────

  Escenario: Estatus Salida false no afecta el select en Dar llegada
    Dado que el operador tiene el proceso "Estatus Salida" en false
    Y el operador tiene el proceso "Estatus Llegada" en true
    Y el trayecto se encuentra en estado "En ruta"
    Cuando el operador abre la pantalla "Dar llegada"
    Entonces el select de estatus del viaje está habilitado

  Escenario: Estatus Llegada false no afecta el select en Dar salida
    Dado que el operador tiene el proceso "Estatus Llegada" en false
    Y el operador tiene el proceso "Estatus Salida" en true
    Y el trayecto se encuentra en estado "Sin salida"
    Cuando el operador abre la pantalla "Dar salida"
    Entonces el select de estatus del viaje está habilitado

  Escenario: Asignar Estatus false no afecta los selects de salida ni llegada
    Dado que el operador tiene el proceso "Asignar Estatus" en false
    Y el operador tiene el proceso "Estatus Salida" en true
    Y el trayecto se encuentra en estado "Sin salida"
    Cuando el operador abre la pantalla "Dar salida"
    Entonces el select de estatus del viaje está habilitado
