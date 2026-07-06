
@lIQUIDACIONES  @HU-HU41881
# HU41881: El operador puede consultar el historial completo de sus liquidaciones desde la app
Feature: Listado completo de liquidaciones

Como operador de transporte,
Quiero ver el listado completo de mis liquidaciones en una pestaña "Todas" dentro de la pantalla de Liquidaciones,
Para consultar el estatus, montos y fechas de cualquier liquidación sin limitarme a la última y penúltima.

  Background:
    Given el operador tiene sesión activa en GM Mis Viajes
    And el operador cuenta con el permiso "Imprimir Liquidaciones" activo
    And el operador navega a Inicio > Liquidaciones

  # ─────────────────────────────────────────
  # AC-1: Pestañas visibles
  # ─────────────────────────────────────────
  Scenario: La pantalla de Liquidaciones muestra las dos pestañas
    When la pantalla de Liquidaciones carga
    Then se muestran dos pestañas: "Recientes" y "Todas"
    And la pestaña activa por defecto es "Recientes"
    And "Recientes" muestra la Última y Penúltima liquidación
    como actualmente las presenta la app

  # ─────────────────────────────────────────
  # AC-2: Pestaña "Todas" — listado cargado
  # ─────────────────────────────────────────
  Scenario: El operador accede a la pestaña "Todas"
    When el operador presiona la pestaña "Todas"
    Then se muestra el listado completo de liquidaciones
    And cada tarjeta muestra los siguientes campos:
      | Campo         | Detalle                     |
      | Folio         | Número de liquidación       |
      | Fecha Inicial | Fecha de inicio del periodo |
      | Fecha Final   | Fecha de fin del periodo    |
      | Autorizada    | Sí / No                     |
      | Pagada        | Sí / No                     |
      | Neto a pagar  | Monto + sufijo de moneda    |
      | Fecha de pago | Solo si aplica, vacío si no |
    And el listado está ordenado por fecha final descendente

  # ─────────────────────────────────────────
  # AC-3: Badges de estatus por colores
  # ─────────────────────────────────────────
  Scenario Outline: Cada liquidación muestra badge según su estatus
    Given el listado de liquidaciones está visible
    When una liquidación tiene estatus "<estatus>"
    Then se muestra un badge de color "<color>" con la etiqueta "<etiqueta>"

    Examples:
      | estatus       | color    | etiqueta      |
      | Pagada        | Verde    | Pagada        |
      | Autorizada    | Amarillo | Autorizada    |
      | Sin autorizar | Rojo     | Sin autorizar |

  # ─────────────────────────────────────────
  # AC-4: Moneda dinámica
  # ─────────────────────────────────────────
  Scenario Outline: El sufijo de moneda se muestra según la moneda del ERP
    Given una liquidación tiene moneda "<moneda>" en el ERP
    When se muestra en la tarjeta
    Then el neto a pagar aparece como "<ejemplo>"

    Examples:
      | moneda | ejemplo        |
      | MXN    | $12,500.00 MXN |
      | USD    | $1,200.00 USD  |

  # ─────────────────────────────────────────
  # AC-5: Búsqueda por folio
  # ─────────────────────────────────────────
  Scenario: El operador busca una liquidación por folio parcial
    Given el listado de liquidaciones está visible
    When el operador escribe "124" en el campo de búsqueda
    Then se muestran solo las liquidaciones cuyo folio contiene "124"
    And si no hay coincidencias se muestra "No se encontraron liquidaciones"

  # ─────────────────────────────────────────
  # AC-6: Filtros
  # ─────────────────────────────────────────
  Scenario: El operador filtra por rango de fechas
    Given el listado de liquidaciones está visible
    When el operador selecciona una fecha inicial y una fecha final en el filtro
    Then se muestran solo las liquidaciones cuya fecha final
    está dentro del rango seleccionado

  Scenario: El operador filtra por moneda
    Given el listado de liquidaciones está visible
    When el operador selecciona una moneda en el filtro
    Then se muestran solo las liquidaciones con esa moneda

  Scenario: El operador filtra por estatus de pago
    Given el listado de liquidaciones está visible
    When el operador selecciona un estatus en el filtro
    Then se muestran solo las liquidaciones con ese estatus

  # ─────────────────────────────────────────
  # AC-7: Descargar PDF desde el listado
  # ─────────────────────────────────────────
  Scenario: El operador descarga el PDF de una liquidación del listado
    Given el listado de liquidaciones está visible
    When el operador presiona una liquidación
    Then la app consulta el endpoint
      """
      GET /api/getformatoliquidacion
      Body: { rfc, idformato, idliquidacion }
      """
    And se descarga y abre el PDF de esa liquidación

  # ─────────────────────────────────────────
  # AC-8: Sin permiso
  # ─────────────────────────────────────────
  Scenario: El operador no tiene el permiso MV.LIQ.VER_LISTA
    Given el operador NO tiene el permiso "MV.LIQ.VER_LISTA"
    When navega a Inicio > Liquidaciones
    Then la pestaña "Todas" NO es visible
    And solo ve la pestaña "Recientes" con la última y penúltima liquidación

  # ─────────────────────────────────────────
  # AC-9: Sin resultados
  # ─────────────────────────────────────────
  Scenario: El operador no tiene liquidaciones registradas
    Given el operador accede a la pestaña "Todas"
    And el ERP no retorna liquidaciones
    When el listado carga
    Then se muestra el mensaje "No se encontraron liquidaciones"

  # ─────────────────────────────────────────
  # AC-10: Error al cargar
  # ─────────────────────────────────────────
  Scenario: Falla la consulta al backend
    Given el operador accede a la pestaña "Todas"
    And el ERP retorna un error
    When el listado intenta cargar
    Then se muestra el mensaje
    "Error al cargar la información, reintente nuevamente."
    And se muestra un botón para reintentar la carga
```

---

## Supuesto técnico a validar con el equipo de backend

> ¿Existe un endpoint para obtener el listado de liquidaciones por operador?
> Si no existe, el equipo backend debe crearlo contemplando los campos:
> `folio`, `fechaInicial`, `fechaFinal`, `autorizada`, `pagada`, `moneda`, `netoAPagar`, `fechaPago`.
> El endpoint de descarga PDF ya está disponible en `api/getformatoliquidacion`.

---

## Definición de terminado (DoD)

- [ ] Pestaña "Recientes" mantiene el comportamiento actual sin cambios
- [ ] Pestaña "Todas" visible solo con permiso `MV.LIQ.VER_LISTA`
- [ ] Listado ordenado por fecha final descendente por defecto
- [ ] Filtros funcionales: rango de fechas, moneda y estatus
- [ ] Búsqueda por folio con coincidencia parcial
- [ ] Badges de colores: verde, amarillo y rojo según estatus
- [ ] Sufijo de moneda dinámico según dato del ERP
- [ ] Descarga de PDF usando `api/getformatoliquidacion`
- [ ] Mensajes de vacío y error implementados