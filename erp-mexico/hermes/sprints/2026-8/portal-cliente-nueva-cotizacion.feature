# language: es

# ─────────────────────────────────────────────────────────────────────────────
# CATÁLOGO DE PREGUNTAS POR TIPO DE DESARROLLO
# El formulario muestra preguntas dinámicas según el tipo seleccionado.
# Cada pregunta tiene opciones de selección única (radio). La opción de mayor
# complejidad seleccionada entre todas las preguntas determina el nivel final.
#
# CATÁLOGO:
#
# [1] Catálogo
#     1.1 ¿Cuántos campos o datos necesitas capturar en la pantalla?
#         - Pocos campos simples (Sencillo)
#         - Campos con validaciones o dependencias entre ellos (Intermedio)
#         - Muchos campos con lógica compleja o condicional (Laborioso)
#     1.2 ¿Qué botones o acciones debe tener esta pantalla?
#         - Solo guardar / cancelar (Sencillo)
#         - Guardar, editar y eliminar (Intermedio)
#         - Acciones adicionales que afectan a otros módulos (Laborioso)
#     1.3 ¿Esta pantalla se relaciona con otros procesos del sistema?
#         - No, es independiente (Sencillo)
#         - Sí, con uno o dos módulos (Intermedio)
#         - Sí, con varios módulos o requiere sincronización (Laborioso)
#
# [2] Reportes
#     2.1 ¿Cuántos filtros de búsqueda y columnas tendrá el reporte?
#         - Menos de 5 filtros y 10 columnas (Sencillo)
#         - Entre 5 y 10 filtros o columnas (Intermedio)
#         - Más de 10 filtros o columnas (Laborioso)
#     2.2 ¿Qué nivel de complejidad tienen los datos a mostrar?
#         - Datos directos de una sola tabla (Sencillo)
#         - Datos de varias tablas con relaciones simples (Intermedio)
#         - Cálculos, agrupaciones o datos de múltiples fuentes (Laborioso)
#     2.3 ¿Requiere ejecución en segundo plano?
#         - No, se genera en tiempo real (Sencillo)
#         - Sí, porque tarda más de 30 segundos (Laborioso) [requiere análisis del equipo]
#
# [3] Proceso (Nuevas liquidaciones, nuevas facturas, etc.)
#     3.1 ¿Cuál es el alcance de esta nueva funcionalidad?
#         - Proceso simple dentro de un módulo (Sencillo)
#         - Proceso que toca dos o tres módulos (Intermedio)
#         - Afecta múltiples módulos del sistema (Laborioso)
#     3.2 ¿Qué nivel de relación tiene con otros procesos que ya existen?
#         - Es independiente de procesos existentes (Sencillo)
#         - Comparte datos con algún proceso existente (Intermedio)
#         - Coordinación con múltiples módulos existentes (Laborioso)
#
# [4] Listado
#     4.1 ¿Cuántas columnas de información necesitas ver en total?
#         - Menos de 8 columnas (Sencillo)
#         - Entre 8 y 15 columnas (Intermedio)
#         - Más de 15 columnas (Laborioso)
#     4.2 ¿El listado requiere filtros, opciones especiales o fórmulas?
#         - No, solo mostrar datos (Sencillo)
#         - Sí, filtros básicos o totales simples (Intermedio)
#         - Sí, filtros avanzados, fórmulas o columnas calculadas (Laborioso)
#
# [5] Parámetros
#     5.1 ¿A qué nivel aplican estas restricciones o reglas?
#         - A un solo campo o pantalla (Sencillo)
#         - A un módulo completo (Intermedio)
#         - A varios módulos o al comportamiento global del sistema (Laborioso)
#
# [6] Adecuaciones a reporte
#     6.1 ¿Cuántas columnas y filtros nuevos vas a agregar al reporte existente?
#         - 1 a 3 columnas o filtros (Sencillo)
#         - 4 a 7 columnas o filtros (Intermedio)
#         - Más de 7 columnas o filtros (Laborioso)
#     6.2 ¿Las nuevas columnas requieren cálculos o rediseño?
#         - No, son datos directos (Sencillo)
#         - Sí, cálculos simples (Intermedio)
#         - Sí, cálculos complejos o rediseño del reporte (Laborioso)
#
# [7] Adecuaciones a proceso
#     7.1 ¿Cuántos campos nuevos necesitas agregar al proceso?
#         - 1 a 3 campos simples (Sencillo)
#         - 4 a 8 campos o con validaciones (Intermedio)
#         - Más de 8 campos o con lógica compleja (Laborioso)
#     7.2 ¿Cómo impactará este cambio al resto de los procesos?
#         - No afecta otros procesos (Sencillo)
#         - Afecta uno o dos procesos relacionados (Intermedio)
#         - Afecta varios módulos o requiere migración de datos (Laborioso)
#
# [8] Adecuaciones a listados (columnas)
#     8.1 ¿Qué tipo de columnas necesitas agregar a la tabla?
#         - Columnas de texto o fecha simples (Sencillo)
#         - Columnas con formato especial o condicional (Intermedio)
#         - Columnas calculadas o con lógica de negocio compleja (Laborioso)
#     8.2 ¿Necesitas cambiar la estructura de la tabla?
#         - No, solo agregar columnas (Sencillo)
#         - Sí, reorganizar o agrupar columnas (Intermedio)
#         - Sí, rediseño completo del listado (Laborioso)
#
# [9] Adecuación aplicación móvil
#     9.1 ¿Cuál es la magnitud del cambio en la App?
#         - Cambio visual o de texto (Sencillo)
#         - Nueva pantalla o flujo dentro de la app existente (Intermedio)
#         - Nuevo módulo completo dentro de la app (Laborioso)
#
# [10] API
#     10.1 ¿Hacia dónde se mueven los datos de la API?
#          - Solo recibe datos de un sistema externo (Sencillo)
#          - Envía y recibe datos con transformación básica (Intermedio)
#          - Integración bidireccional con lógica de negocio compleja (Laborioso)
#
# [11] Adecuación API
#     11.1 ¿Qué le modificarás a la API actual?
#          - Agregar o cambiar un campo en la respuesta (Sencillo)
#          - Cambiar la lógica de procesamiento de datos (Intermedio)
#          - Rediseñar el flujo o agregar nuevos endpoints (Laborioso)
#
# [12] EDI
#     12.1 ¿Qué tipo de archivo o Carrier necesitas configurar?
#          - Adecuación a archivos de un Carrier que ya existe (Sencillo)
#          - Crear un nuevo archivo para un Carrier que ya existe (Intermedio)
#          - Configurar un Carrier completamente nuevo (Laborioso)
#
# [13] Addendas → EXCEPCIÓN: no muestra preguntas.
#      Mensaje: "Requiere análisis con el equipo de desarrollo"
#
# [14] Nueva APP Móvil → EXCEPCIÓN: no muestra preguntas.
#      Mensaje: "Requiere análisis con el equipo de desarrollo"
# ─────────────────────────────────────────────────────────────────────────────

@portal-cliente @cotizacion @formulario
Característica: Nueva Cotización en Portal Cliente
  Como cliente autenticado en Hermes Portal
  Quiero enviar una solicitud de cotización usando el formulario dinámico
  Para recibir una estimación automática de mi requerimiento de desarrollo

  Antecedentes:
    Dado que el cliente está autenticado en el portal Hermes
    Y se encuentra en la pantalla "Nueva Cotización"

  Regla: El formulario muestra preguntas dinámicas según el tipo de desarrollo seleccionado

    Escenario: Cliente selecciona un tipo de desarrollo y aparecen sus preguntas específicas
      Dado que el cliente abre el selector de tipo de desarrollo
      Cuando selecciona cualquier tipo que no sea "Addendas" ni "Nueva APP Móvil"
      Entonces el sistema muestra las preguntas específicas correspondientes a ese tipo
      Y el campo de notas adicionales queda visible al final del formulario

    Esquema del escenario: Tipos exceptuados muestran mensaje de análisis con equipo
      Dado que el cliente seleccionó el tipo "<tipo_exceptuado>"
      Entonces el sistema oculta las preguntas y el campo de notas
      Y muestra un mensaje indicando que el requerimiento requiere análisis directo con el equipo de desarrollo

      Ejemplos:
        | tipo_exceptuado |
        | Addendas        |
        | Nueva APP Móvil |

    Escenario: Cliente intenta enviar sin responder todas las preguntas obligatorias
      Dado que el cliente seleccionó un tipo de desarrollo con preguntas obligatorias
      Pero no respondió todas las preguntas requeridas
      Cuando intenta enviar el formulario
      Entonces el sistema no procesa la solicitud
      Y señala los campos obligatorios que faltan

  Regla: El formulario se bloquea mientras la IA procesa el análisis

    Esquema del escenario: Cliente envía el formulario y el formulario se bloquea durante el análisis
      Dado que el cliente seleccionó el tipo "<tipo>"
      Y respondió todas las preguntas requeridas de ese tipo
      Y describió su requerimiento en el campo de texto
      Cuando envía el formulario
      Entonces el sistema bloquea todos los campos y botones del formulario
      Y muestra un indicador visual de que el análisis está en curso

      Ejemplos:
        | tipo                               |
        | Catálogo                           |
        | Reportes                           |
        | Proceso                            |
        | Listado                            |
        | Parámetros                         |
        | Adecuaciones a reporte             |
        | Adecuaciones a proceso             |
        | Adecuaciones a listados (columnas) |
        | Adecuación aplicación móvil        |
        | API                                |
        | Adecuación API                     |
        | EDI                                |

    Escenario: El análisis termina exitosamente y el cliente ve solo el precio final
      Dado que el cliente envió el formulario y la IA procesó el análisis correctamente
      Entonces el sistema muestra el precio final de forma destacada
      Y no muestra costo base, horas de desarrollo, margen de seguridad ni ningún concepto de desglose interno

    Escenario: Cliente cierra la pestaña mientras la IA procesa y el análisis termina
      Dado que el cliente envió el formulario y cerró la pestaña antes de que la IA terminara
      Y el análisis terminó mientras el cliente estaba fuera
      Cuando el cliente regresa a "Mis Cotizaciones"
      Entonces la cotización aparece con el precio estimado

    Escenario: Cliente cierra la pestaña mientras la IA procesa y el análisis sigue en curso
      Dado que el cliente envió el formulario y cerró la pestaña antes de que la IA terminara
      Y el análisis aún no ha terminado
      Cuando el cliente regresa a "Mis Cotizaciones"
      Entonces la cotización aparece con estatus "En Análisis"

  Regla: Si la IA no resuelve, el cliente puede reenviar contexto adicional hasta 5 veces

    Escenario: La IA no resuelve el análisis y solicita contexto adicional
      Dado que el cliente envió el formulario correctamente
      Y la IA no generó una estimación tras los intentos de análisis permitidos
      Entonces el sistema muestra un campo de texto adicional en el mismo formulario
      Y el botón cambia a "Reenviar con información adicional"
      Y el sistema indica cuántos intentos le quedan al cliente

    Escenario: Cliente reenvía con contexto adicional y obtiene estimación
      Dado que el sistema solicitó contexto adicional al cliente
      Y el cliente escribió en el campo adicional
      Cuando presiona "Reenviar con información adicional"
      Entonces el sistema bloquea el formulario mientras la IA procesa nuevamente
      Y al resolverse muestra el precio final con buffer de seguridad de forma destacada

    Escenario: Cliente agota los 5 intentos sin que la IA resuelva
      Dado que el cliente ha reenviado con contexto adicional 5 veces sin obtener estimación
      Entonces el sistema muestra un mensaje indicando que no fue posible generar la estimación automáticamente
      Y el mensaje invita al cliente a contactar directamente al equipo de GM Transport
      Y el botón de reenvío desaparece
