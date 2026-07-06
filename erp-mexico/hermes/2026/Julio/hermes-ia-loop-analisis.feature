# language: es

@hermes-gm @ia @analisis @loop
Característica: Loop de Análisis IA para Cotizaciones
  Como sistema Hermes
  Quiero que la IA analice cotizaciones considerando el historial de rechazos previos
  Para mejorar la precisión de las estimaciones

  Antecedentes:
    Dado que existe una solicitud de cotización pendiente de análisis
    Y el servicio de IA está disponible

  Escenario: La IA resuelve el análisis en el primer intento sin antecedentes similares
    Dado que no existen registros de rechazo activos con la misma categoría y complejidad
    Cuando la IA analiza la solicitud
    Entonces genera una respuesta con categoría, complejidad y estimación de costo
    Y la cotización queda disponible para revisión del administrador GM

  Escenario: La IA detecta antecedentes de rechazo y enriquece el análisis
    Dado que existen registros de rechazo activos con la misma categoría y complejidad de la solicitud
    Cuando la IA revisora identifica esas coincidencias
    Entonces enriquece el análisis con los datos de todos los antecedentes similares activos
    Y la IA principal reanaliza la solicitud con ese contexto adicional

  Escenario: El análisis no se resuelve tras tres intentos
    Dado que la IA realizó tres intentos de análisis sin generar una estimación definitiva
    Cuando se agota el número máximo de intentos permitidos
    Entonces el portal muestra al cliente el campo de contexto adicional para que pueda aportar más información

  Escenario: Cliente agrega contexto y el análisis reinicia desde el primer intento
    Dado que el análisis agotó los tres intentos previos
    Y el cliente proporcionó notas adicionales desde el portal
    Cuando el sistema recibe la solicitud reenviada con la información adicional
    Entonces la IA reinicia el análisis desde el primer intento usando la descripción original más las notas del cliente
