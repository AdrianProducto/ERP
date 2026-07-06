# language: es

@hermes-gm @admin @rechazos @ia
Característica: Gestión de Registros de Rechazo para la IA
  Como administrador de Hermes GM
  Quiero administrar los registros de rechazo que usa la IA en su análisis
  Para controlar qué antecedentes considera al evaluar nuevas cotizaciones

  Antecedentes:
    Dado que el administrador está autenticado en Hermes GM
    Y existen registros de rechazo activos e inactivos en el sistema

  Escenario: La IA solo considera registros activos en su análisis
    Dado que existen registros de rechazo activos e inactivos con la misma categoría y complejidad
    Cuando la IA analiza una nueva solicitud buscando antecedentes similares
    Entonces solo considera los registros activos en su análisis
    Y omite completamente los registros inactivos

  Escenario: Administrador desactiva un registro de rechazo
    Dado que existe un registro de rechazo activo que ya no es relevante
    Cuando el administrador lo desactiva desde la pantalla de Registros de Rechazo
    Entonces el sistema lo marca como inactivo
    Y la IA deja de considerarlo en nuevos análisis
    Y el registro no puede volver a activarse

  Escenario: Administrador elimina un registro de rechazo permanentemente
    Dado que existe un registro de rechazo que debe removerse del sistema
    Cuando el administrador lo elimina
    Entonces el sistema lo elimina definitivamente
    Y la IA no puede considerarlo en ningún análisis futuro

  Escenario: Rechazo de cotización genera automáticamente un registro activo
    Dado que el administrador rechazó una cotización con observación de motivo
    Cuando el sistema registra la decisión
    Entonces crea automáticamente un registro de rechazo activo
    Y el registro incluye la categoría, complejidad y motivo de la cotización rechazada
