Feature: Habilitar pantalla de Filtros Avanzados en el Dashboard de KPIs
    Yo como Analista de Producto,
    Quiero que se habilite una pantalla de Filtros Avanzados en el Dashboard de KPIs,
    Para que los usuarios puedan consultar con mejor facilidad los reportes de KPIs que se encuentran en el dashboard.

  Background:
    Given que en el dashboard de KPIs existen reportes de KPIs que el administrador ha publicado

  Scenario: Seleccionar la opción de Filtros en el menú del Dashboard y configurar los filtros
    Given que el usuario se encuentra en el Dashboard de KPIs
     When el usuario seleccione la opción de "Filtros" que se encuentra al lado de la barra de búsqueda en el Dashboard de KPIs
     Then el sistema desplegará un menú lateral con la pantalla de Filtros Avanzados, mostrando las siguientes opciones de filtros:
      '''
      - Filtro por Categoría: Permitirá filtrar los reportes por la categoría a la que pertenecen, podrá ser de selección múltiple. Las categorías serán definidas por el administrador del Dashboard de KPIs.
      - Filtro de Ordenar Por: Permitirá ordenar los reportes por diferentes criterios como "Abiertos recientemente", "Categoría", "A-Z" y "Z-A".
      '''
      And el usuario tendrá la opción de limpiar los filtros seleccionados para que los reportes vuelvan a mostrarse sin ningún filtro aplicado
      And el usuario tendrá la opción de guardar o cancelar los filtros seleccionados para que se apliquen a la vista del listado de reportes en el Dashboard de KPIs

