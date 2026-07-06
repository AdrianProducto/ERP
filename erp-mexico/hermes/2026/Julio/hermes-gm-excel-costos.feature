# language: es

@hermes-gm @admin @excel @referencia-ia
Característica: Actualización del Excel de Referencia de la IA
  Como administrador de Hermes GM
  Quiero subir una nueva versión del Excel de referencia que usa la IA
  Para que los análisis de cotizaciones reflejen los tiempos, descripciones y criterios actuales

  Antecedentes:
    Dado que el administrador está autenticado en Hermes GM
    Y existe una versión activa del Excel de referencia en el sistema

  Escenario: Administrador sube nueva versión y la IA la adopta
    Dado que el administrador tiene un archivo Excel actualizado con tiempos, descripciones y criterios vigentes
    Cuando lo carga en el portal de Excel de Referencia
    Entonces el sistema activa la nueva versión como archivo vigente
    Y registra en bitácora el nombre del archivo, fecha, hora y usuario que realizó la carga
    Y los nuevos análisis de cotizaciones utilizan los datos del Excel actualizado

  Escenario: Análisis en curso conservan la versión anterior del Excel
    Dado que hay cotizaciones en proceso de análisis al momento de cargar el nuevo Excel
    Cuando el sistema activa la nueva versión
    Entonces los análisis en curso continúan usando la versión anterior
    Y solo los nuevos análisis usan el Excel actualizado

  Escenario: Al subir nuevo Excel la IA revisa automáticamente todas las cotizaciones previas
    Dado que existen cotizaciones previamente aprobadas o rechazadas
    Cuando el administrador sube una nueva versión del Excel
    Entonces el sistema ejecuta automáticamente una revisión con la IA sobre todas esas cotizaciones
    Y la IA re-evalúa cada una comparando los tiempos, descripciones y criterios del Excel anterior con los del nuevo
    Y genera un reporte de revisión que el administrador puede consultar

  Escenario: La IA detecta que los valores del Excel cambiaron y la decisión previa ya no aplica
    Dado que una cotización fue aprobada o rechazada con base en ciertos tiempos, descripciones o criterios del Excel anterior
    Y en el nuevo Excel esos valores son distintos — ya sea que aumentaron, disminuyeron o cambiaron su descripción —
    Cuando la IA re-evalúa esa cotización con los nuevos datos
    Entonces determina que la decisión original ya no es consistente con los datos actuales
    Y el sistema marca esa cotización como "requiere revisión"
    Y el administrador puede ver qué valores cambiaron y en qué dirección

  Escenario: Cotización rechazada cuya razón ya no aplica porque los tiempos aumentaron
    Dado que una cotización fue rechazada porque los tiempos del Excel eran menores a lo requerido
    Y en el nuevo Excel esos tiempos son mayores y ya cubren el criterio
    Cuando la IA revisa esa cotización
    Entonces la marca como "requiere revisión"
    Y el administrador ve que el motivo del rechazo ya no se sostiene con los valores actuales del Excel

  Escenario: Cotización aprobada que ya no aplicaría con los nuevos valores del Excel
    Dado que una cotización fue aprobada con base en tiempos o criterios del Excel anterior
    Y en el nuevo Excel esos valores son menores o cambiaron de forma que ya no cumplen con lo requerido
    Cuando la IA revisa esa cotización
    Entonces la marca como "requiere revisión"
    Y el administrador ve que la aprobación original podría no ser válida con los datos actuales

  Escenario: Cotización cuya decisión sigue siendo válida con el nuevo Excel
    Dado que los tiempos, descripciones y criterios del Excel que aplican a una cotización no cambiaron significativamente
    Cuando la IA revisa esa cotización
    Entonces el sistema la mantiene sin cambios
    Y no aparece en el reporte de revisión del administrador

