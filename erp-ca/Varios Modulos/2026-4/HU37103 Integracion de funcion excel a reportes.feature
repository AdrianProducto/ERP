Feature: Implementación de funcion de exportación en reportes tropicalizados previamente

  Como usuario de reportes del sistema
  Quiero que la funcionalidad de exportación aplicada en reportes tropicalizados se implemente en todos los reportes previamente adaptados
  Para mantener consistencia funcional en la generación y descarga de información

  Scenario: Implementación de función excel en reportes tropicalizados
    Given que el usuario se encuentra dentro de una base de datos de mexico o guatemala
    When el usuario genere cualquiera de los reportes ya tropicalizados
    Then el sistema debe aplicar correctamente la nueva funcion de exportación en formato Excel en los siguientes reportes:
    | Reporte                                                   |
    | Reporte de Gastos Mensual basado en Categorías            |
    | Reporte de Pasivos Detallado                              |
    | Reporte Auxiliar de Reposiciones                          |
    | Reporte Pasivos pendientes de pago                        |
    | Reporte Antigüedad de Saldos por Proveedor                |
    | Reporte de Pasivos por centro de costos                   |
    | Reporte Listado de Ingresos menos Cancelaciones           |
    | Reporte Auxiliar de Proveedores                           |
    | Reporte Listado Transferencias/Cheques por anticipo       |
    | Reporte Listado de Facturación                            |
    | Reporte de Cobranza                                       |
    | Reporte Vencimiento de facturas                           |
    | Reporte de Movimientos de Cobranza por Tipo de Movimiento |
    | Reporte de servicios por mecánico                         |
    | Reporte detalle de Facturación por cliente                |
    | Reporte de concepto de facturación                        |
    | Reporte de Pagos de clientes                              |
    | Reporte de cobranza por fecha programada de pago          | 
    | Reporte Detallado de Facturación Emitida                  |
    | Reporte listado de facturas canceladas                    |
    | Reporte Auxiliar de Facturación                           |
    | Reporte relación de saldos de clientes                    |
    | Reporte estado de cuenta de clientes                      |
    | Reporte auxiliar de clientes                              |
    | Reporte de viajes pendientes de facturar                  |
    | Reporte de salidas diarias con importes                   |
    | Reporte de combustible conciliado                         |
    | Reporte de ingresos generados por unidad                  |