# language: es
# API de Zoho: https://github.com/GM-Transport/gm-ia-zoho-api

@hermes @zoho
Feature: Sincronización de horas con Zoho al aprobar cotización
  Como sistema Hermes
  Quiero sincronizar las horas estimadas en Zoho al aprobar una cotización
  Para que el equipo de ventas tenga visibilidad del esfuerzo real cotizado

  Background:
    Dado que el usuario está autenticado en la aplicación
    Y existe una cotización con estado "aprobada" y una respuesta generada por la IA

  # ─────────────────────────────────────────
  # INSERCIÓN EXITOSA
  # ─────────────────────────────────────────

  @zoho @smoke
  Escenario: Insertar horas en Zoho exitosamente al aprobar
    Dado que la cotización tiene RequirementID "#38726"
    Y la cotización tiene HorasDesarrollo de 4 y HorasCalidad de 4
    Y el registro "#38726" existe en Zoho
    Cuando el sistema sincroniza las horas con Zoho
    Entonces envía a Zoho HorasDesarrollo igual a 4 y HorasCalidad igual a 4
    Y se muestra el mensaje "Cotización aprobada e insertada en Zoho"

  @zoho @actualizacion
  Escenario: Actualizar horas en Zoho cuando el registro ya tiene datos anteriores
    Dado que la cotización tiene RequirementID "#38726"
    Y el registro "#38726" ya existe en Zoho con datos de una cotización anterior cancelada
    Cuando el sistema sincroniza las horas con Zoho
    Entonces el sistema sobreescribe las horas en Zoho con los nuevos valores
    Y se muestra el mensaje "Cotización aprobada, horas actualizadas en Zoho"

  # ─────────────────────────────────────────
  # FALLOS AL INSERTAR
  # ─────────────────────────────────────────

  @zoho @error
  Escenario: Registro no encontrado en Zoho
    Dado que la cotización tiene RequirementID "#99999"
    Y el registro "#99999" no existe en Zoho
    Cuando el sistema intenta sincronizar las horas con Zoho
    Entonces el sistema muestra el mensaje "No se pudo insertar en Zoho: registro no encontrado"
    Y la cotización queda con estado "aprobada (pendiente Zoho)"
    Y se muestra el botón "Reintentar" junto con el contador de intentos disponibles

  @zoho @error
  Escenario: Error de conexión con la API de Zoho
    Dado que la cotización tiene RequirementID "#38726"
    Y la API de Zoho no está disponible
    Cuando el sistema intenta sincronizar las horas con Zoho
    Entonces el sistema muestra el mensaje "No se pudo insertar en Zoho: error de conexión"
    Y la cotización queda con estado "aprobada (pendiente Zoho)"
    Y se muestra el botón "Reintentar" junto con el contador de intentos disponibles

  # ─────────────────────────────────────────
  # REINTENTOS MANUALES
  # ─────────────────────────────────────────

  @zoho @reintentos
  Escenario: Reintentar y la inserción en Zoho es exitosa
    Dado que la cotización tiene estado "aprobada (pendiente Zoho)"
    Y tiene menos de 5 reintentos acumulados en la última hora
    Y el registro ya existe en Zoho al momento del reintento
    Cuando el usuario hace clic en "Reintentar"
    Entonces las horas son enviadas a Zoho exitosamente
    Y la cotización queda con estado "aprobada"
    Y el botón "Reintentar" desaparece

  @zoho @reintentos
  Escenario: Reintentar y vuelve a fallar dentro del límite
    Dado que la cotización tiene estado "aprobada (pendiente Zoho)"
    Y tiene menos de 5 reintentos acumulados en la última hora
    Y el registro sigue sin existir en Zoho
    Cuando el usuario hace clic en "Reintentar"
    Entonces el sistema muestra nuevamente el mensaje de error
    Y la cotización mantiene el estado "aprobada (pendiente Zoho)"
    Y el contador de intentos disponibles se reduce en 1

  @zoho @reintentos
  Escenario: Se alcanza el límite de 5 reintentos por cotización en una hora
    Dado que la cotización tiene estado "aprobada (pendiente Zoho)"
    Y ha acumulado 5 reintentos fallidos en la última hora
    Cuando el usuario intenta hacer clic en "Reintentar"
    Entonces el botón "Reintentar" está deshabilitado
    Y se muestra el mensaje "Límite de intentos alcanzado. Verifica que el número exista en Zoho e intenta más tarde"
    Y otras cotizaciones pendientes Zoho conservan su propio contador independiente

  @zoho @reintentos
  Escenario: El contador de reintentos se restablece tras una hora
    Dado que la cotización tiene estado "aprobada (pendiente Zoho)"
    Y había alcanzado el límite de 5 reintentos
    Cuando transcurre más de una hora desde el primer reintento fallido
    Entonces el botón "Reintentar" vuelve a estar disponible
    Y el contador de intentos se reinicia a 5 para esa cotización

  # ─────────────────────────────────────────
  # ESQUEMA — VARIACIÓN DE HORAS
  # ─────────────────────────────────────────

  @zoho @smoke
  Esquema del escenario: Zoho recibe las horas correctas según la cotización
    Dado que la cotización tiene RequirementID "<requirement_id>"
    Y la cotización tiene <horas_dev>h de desarrollo y <horas_qa>h de calidad
    Y el registro "<requirement_id>" existe en Zoho
    Cuando el sistema sincroniza las horas con Zoho
    Entonces Zoho recibe HorasDesarrollo igual a "<horas_dev>" y HorasCalidad igual a "<horas_qa>"

    Ejemplos:
      | requirement_id | horas_dev | horas_qa |
      | #38726         | 4         | 4        |
      | #38727         | 8         | 6        |
      | #38728         | 2         | 2        |
      | #38729         | 16        | 12       |
