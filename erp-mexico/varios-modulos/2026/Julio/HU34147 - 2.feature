Feature: Generar reporte en el dashboard de KPIs como usuario
    Yo como Analista de Producto,
    Quiero que se genere un reporte en el dashboard de KPIs en el sistema GM Transport ERP,
    Para que los usuarios puedan visualizar de manera clara y concisa los indicadores clave de desempeño relacionados con sus operaciones de transporte.

  Background:
    Given que en el menú del sistema GM Transport ERP existe una opción para acceder a diferentes módulos
      And la opción para entrar a un dashboard de KPIs se habilita mediante el sistema de ADMON

  Scenario: Escoger un reporte del menú de Dashboard de KPIs para visualizarlo
    Given que el usuario se encuentra dentro del Dashboard de KPIs
     When el usuario selecciona un reporte del listado
     Then se abrirá el reporte seleccionado en una nueva pestaña del navegador
      And el reporte se cargará con los controladores de Power BI para mostrar la información
      And el usuario podrá interactuar con el reporte utilizando las funcionalidades de Power BI para hacer filtros, seleccionar diferentes visualizaciones, etc
      And el menú de Dashboard de KPIs se mantendrá abierto en la pestaña original para que el usuario pueda seleccionar otros reportes si así lo desea

