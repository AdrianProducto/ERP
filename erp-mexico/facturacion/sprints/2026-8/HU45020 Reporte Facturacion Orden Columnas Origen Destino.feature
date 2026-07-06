@Jaqueline @HU42910 @ReporteFacturacion
Feature: Orden de columnas Origen y Destino en el Reporte Listado de Facturación

    Yo como usuario del módulo de Facturación
    requiero que en el Reporte 01 - Listado de Facturación la columna Origen aparezca antes que la columna Destino
    Para que el orden de las columnas en pantalla y en el archivo Excel sea consistente y comprensible para el usuario.

    Background: Given que el usuario tiene acceso al Reporte 01 - Listado de Facturación

    Scenario: Visualización del orden de columnas en pantalla al generar el reporte
        Given el usuario configura el reporte con un rango de fechas, selecciona al menos una sucursal
        And tiene activas las opciones "Mostrar Origen" y "Mostrar Destino"
        When el usuario genera el reporte en pantalla
        Then la columna "Origen" aparece antes que la columna "Destino" en la tabla de resultados

    Scenario: Orden de columnas Origen y Destino en el archivo Excel exportado
        Given el usuario ha generado el reporte en pantalla con resultados
        And tiene activas las opciones "Mostrar Origen" y "Mostrar Destino"
        When el usuario hace clic en "Exportar XLS"
        Then el archivo Excel descargado contiene la columna "Origen" en una posición anterior a la columna "Destino"
        And los datos de cada columna corresponden correctamente a su encabezado

    Scenario: Exportar Excel con solo Mostrar Origen activo
        Given el usuario tiene activa únicamente la opción "Mostrar Origen" y desactivada "Mostrar Destino"
        When el usuario genera el reporte en pantalla
        And el usuario hace clic en "Exportar XLS"
        Then el archivo Excel contiene la columna "Origen"
        And no contiene la columna "Destino"

    Scenario: Exportar Excel con solo Mostrar Destino activo
        Given el usuario tiene activa únicamente la opción "Mostrar Destino" y desactivada "Mostrar Origen"
        When el usuario genera el reporte en pantalla
        And el usuario hace clic en "Exportar XLS"
        Then el archivo Excel contiene la columna "Destino"
        And no contiene la columna "Origen"

    Scenario: Exportar Excel sin Mostrar Origen ni Mostrar Destino
        Given el usuario tiene desactivadas las opciones "Mostrar Origen" y "Mostrar Destino"
        When el usuario genera el reporte en pantalla
        And el usuario hace clic en "Exportar XLS"
        Then el archivo Excel no contiene la columna "Origen" ni la columna "Destino"
        And el resto de las columnas del reporte se muestran correctamente

    Scenario: El orden del resto de columnas no se ve afectado por el cambio
        Given el usuario ha generado el reporte en pantalla con todas las opciones activas
        When el usuario hace clic en "Exportar XLS"
        Then las columnas del archivo Excel mantienen el mismo orden que en pantalla
        And las columnas previas a "Origen" y posteriores a "Destino" no cambian de posición

