# language: es

@portal-cliente @cotizaciones @listado
Característica: Listado de Mis Cotizaciones en Portal Cliente
  Como cliente autenticado en Hermes Portal
  Quiero consultar el historial y estatus de mis cotizaciones
  Para dar seguimiento a mis solicitudes de desarrollo

  Antecedentes:
    Dado que el cliente está autenticado en el portal Hermes

  Regla: El cliente solo ve sus propias cotizaciones, ordenadas de más reciente a más antigua

    Escenario: Cliente visualiza su listado de cotizaciones
      Dado que el cliente tiene solicitudes de cotización registradas
      Cuando navega a "Mis Cotizaciones"
      Entonces el sistema muestra únicamente las cotizaciones del cliente autenticado
      Y las cotizaciones aparecen ordenadas de más reciente a más antigua

    Escenario: El listado pagina en bloques de 20 registros
      Dado que el cliente tiene más de 20 cotizaciones registradas
      Cuando navega a "Mis Cotizaciones"
      Entonces el sistema muestra las primeras 20 cotizaciones
      Y muestra controles de paginación para navegar al resto

    Escenario: Cliente sin cotizaciones previas ve estado vacío
      Dado que el cliente no ha enviado ninguna solicitud de cotización
      Cuando navega a "Mis Cotizaciones"
      Entonces el sistema muestra un mensaje invitando a crear su primera cotización
      Y muestra un enlace para ir a "Nueva Cotización"

  Regla: Cada cotización del listado muestra fecha, descripción breve, estatus y costo

    Escenario: Cotización con análisis disponible muestra el precio en el listado
      Dado que el cliente tiene cotizaciones con estatus "Analizada" o "Respuesta Enviada"
      Cuando navega a "Mis Cotizaciones"
      Entonces cada una de esas cotizaciones muestra: fecha de creación, descripción breve del requerimiento, estatus y precio estimado

    Escenario: Cotización sin análisis no muestra precio en el listado
      Dado que el cliente tiene cotizaciones con estatus "Enviada" o "En Análisis"
      Cuando navega a "Mis Cotizaciones"
      Entonces esas cotizaciones muestran: fecha de creación, descripción breve del requerimiento y estatus
      Y el campo de precio aparece vacío

  Regla: El precio que ve el cliente es siempre el importe final, sin desglosar ni mostrar conceptos internos

    Escenario: El listado muestra solo el precio final en cotizaciones analizadas
      Dado que el cliente tiene una cotización con estatus "Analizada" o "Respuesta Enviada"
      Cuando navega a "Mis Cotizaciones"
      Entonces el sistema muestra únicamente el precio final de esa cotización
      Y no muestra costo base, margen de seguridad ni ningún concepto de desglose

    Escenario: El detalle muestra solo el precio final sin ningún desglose interno
      Dado que el cliente tiene una cotización con estatus "Analizada" o "Respuesta Enviada"
      Cuando selecciona esa cotización del listado
      Entonces el sistema muestra el precio final de forma grande y destacada
      Y no muestra costo base, horas de desarrollo, margen de seguridad ni ningún concepto de desglose interno

  Regla: El detalle de una cotización analizada muestra únicamente los datos del cliente y el precio final

    Escenario: Cliente consulta el detalle de una cotización analizada
      Dado que el cliente tiene una cotización con estatus "Analizada" o "Respuesta Enviada"
      Cuando selecciona esa cotización del listado
      Entonces el sistema muestra el tipo de desarrollo, las respuestas al cuestionario y la descripción que el cliente capturó
      Y muestra el precio final de forma grande y destacada

    Escenario: Cliente consulta el detalle de una cotización en proceso
      Dado que el cliente tiene una cotización con estatus "Enviada" o "En Análisis"
      Cuando selecciona esa cotización del listado
      Entonces el sistema muestra el tipo de desarrollo, las respuestas al cuestionario y la descripción que el cliente capturó
      Y muestra un mensaje indicando que el análisis está en proceso
      Y no muestra precio estimado
