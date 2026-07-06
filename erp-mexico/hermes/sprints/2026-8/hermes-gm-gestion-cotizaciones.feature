# language: es

# NOTA DE IMPLEMENTACIÓN:
# La funcionalidad de aprobar y rechazar cotizaciones ya existe en Hermes GM.
# Esta historia cubre únicamente la nueva sección "Cotizaciones de Clientes":
# el listado de solicitudes enviadas desde el Portal Cliente, con sus respuestas
# del formulario dinámico y la capacidad de gestionar el estatus del proceso.

@hermes-gm @admin @cotizaciones-clientes
Característica: Sección de Cotizaciones de Clientes en Hermes GM
  Como administrador autenticado en Hermes GM
  Quiero ver y gestionar las solicitudes de cotización enviadas desde el Portal Cliente
  Para revisar lo que el cliente respondió, el análisis de la IA y avanzar el estatus del proceso

  Antecedentes:
    Dado que el administrador está autenticado en Hermes GM
    Y existe al menos una cotización enviada desde el Portal Cliente

  Escenario: Administrador visualiza el listado de cotizaciones de clientes
    Cuando el administrador accede a la sección "Cotizaciones de Clientes"
    Entonces el sistema muestra el listado de solicitudes recibidas desde el portal
    Y cada fila muestra: ID, cliente, tipo de desarrollo, complejidad, fecha y estatus actual

  Escenario: Administrador consulta el detalle de una cotización con las respuestas del cliente
    Dado que el administrador selecciona una cotización del listado
    Cuando abre el detalle
    Entonces el sistema muestra el tipo de desarrollo seleccionado por el cliente
    Y las respuestas a cada sub-pregunta del formulario con su nivel de complejidad
    Y las notas adicionales del cliente si las hay
    Y el análisis generado por la IA con categoría, complejidad, razonamiento y costo estimado

  Escenario: Administrador avanza el estatus de una cotización manualmente
    Dado que el administrador está en el detalle de una cotización
    Cuando cambia el estatus a uno de los valores del proceso: Enviada, En Análisis, Analizada o Respuesta Enviada
    Y guarda el cambio
    Entonces el sistema actualiza el estatus de la cotización
    Y el cliente ve el nuevo estatus reflejado en su portal

  Escenario: Administrador filtra cotizaciones por estatus
    Dado que el administrador está en el listado de cotizaciones de clientes
    Cuando aplica un filtro por estatus
    Entonces el sistema muestra únicamente las cotizaciones que corresponden al estatus seleccionado

  Escenario: Administrador busca una cotización por cliente o ID
    Dado que el administrador está en el listado de cotizaciones de clientes
    Cuando ingresa un término de búsqueda en el buscador
    Entonces el sistema filtra el listado mostrando solo las cotizaciones que coinciden con el cliente o ID buscado
