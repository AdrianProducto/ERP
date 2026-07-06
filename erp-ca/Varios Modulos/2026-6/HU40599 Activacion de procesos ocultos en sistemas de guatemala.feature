Feature: Activación de procesos ocultos para Guatemala

    Como usuario del sistema
    Quiero que los procesos que actualmente se encuentran ocultos en el sistema para el país de Guatemala,
    Para que los usuarios guatemaltecos tengan acceso completo a todas las funcionalidades disponibles según su configuración regional.

Background:
    Given el sistema tiene una configuración activa para el país "Guatemala"
    And existen procesos en estado "oculto" para dicha configuración

Scenario: Activar procesos del Módulo Indicadores
    Given que los siguientes procesos del módulo "Indicadores" se encuentran ocultos para Guatemala:
    | Proceso                                          |
    | Indicador Mapa de Ubicaciones de Unidades        |
    | Indicador de Viajes                              |
    | Alerta de Vencimientos Documentos Operadores     |
    | Alerta de Vencimientos Documentos Unidades       |
    | Alerta de Artículos Debajo del Punto de Reorden  |
    | Just in time                                     |
    | Servicios Próximos a Vencer                      |
    | Alerta de Servicios Programados por Odómetro GPS |
    | Unidades Bajo Rendimiento                        |
    | Alerta de Servicios Programados en Horas         |
    | Usuarios En el Sistema                           |
    | Unidades con eventos emergentes                  |
    | Unidades Con Falta De Reporteo                   |
    | Indicador de Combustible Por Unidad              |
    | Indicador de Existencia de Combustible           |
    When el desarrollador activa la visibilidad de dichos procesos para el país "Guatemala"
    Then cada proceso debe estar visible y accesible para usuarios de Guatemala
    And la configuración de otros países no debe verse afectada

Scenario: Activar procesos del Módulo Tráfico
    Given los siguientes procesos del módulo "Tráfico" se encuentran ocultos para Guatemala:
    | Proceso                                   |
    | Proceso Tablero de unidades               |
    | Reporte Viajes por Unidad                 |
    | Reporte Rendimiento por unidad            |
    | Reporte detallado de estatus de viaje     |
    | Utilería Liberar Relaciones PEMEX         |
    | Reporte Relación de Viajes con Salida     |
    | Reporte Cargas Despachadas                |
    | Reporte Impresión Masiva de Liquidaciones |
    When el desarrollador activa la visibilidad de dichos procesos para el país "Guatemala"
    Then cada proceso debe estar visible y accesible para usuarios de Guatemala
    And la configuración de otros países no debe verse afectada

Scenario: Activar procesos del Módulo Mantenimiento
    Given el catalogo "Catálogo de Turnos" del módulo "Mantenimiento" se encuentra oculto para Guatemala
    When el desarrollador activa su visibilidad para el país "Guatemala"
    Then el proceso debe estar visible y accesible para usuarios de Guatemala
    And la configuración de otros países no debe verse afectada

Scenario: Activar procesos del Módulo Inventario
    Given que la utileria "Utilería Re-Calcular Existencia" del módulo "Inventario" se encuentra oculto para Guatemala
    When el desarrollador activa su visibilidad para el país "Guatemala"
    Then el proceso debe estar visible y accesible para usuarios de Guatemala
    And la configuración de otros países no debe verse afectada

Scenario: Activar procesos del Módulo Llantas
    Given el reporte "Reporte Estatus actual de llantas" del módulo "Llantas" se encuentra oculto para Guatemala
    When el desarrollador activa su visibilidad para el país "Guatemala"
    Then el proceso debe estar visible y accesible para usuarios de Guatemala
    And la configuración de otros países no debe verse afectada

Scenario: Activar procesos del Módulo Contabilidad
    Given los siguientes procesos del módulo "Contabilidad" se encuentran ocultos para Guatemala:
    | Proceso                                          |
    | Ejercicios períodos                              |
    | Catálogo de equivalencias contables              |
    | Catálogo de Datos                                |
    | Catálogo de Prepolizas                           |
    | Catálogo de Tipos de polizas                     |
    | Utilería Reoricesar períodos                     |
    | Utilería Abrir ejercicio contable                |
    | Utilería Eliminación masiva de cuentas contables |
    When el desarrollador activa la visibilidad de dichos procesos para el país "Guatemala"
    Then cada proceso debe estar visible y accesible para usuarios de Guatemala
    And la configuración de otros países no debe verse afectada

#Scenario: Activar procesos del Módulo Transporte de Personal
    Given los siguientes procesos del módulo "Transporte de Personal" se encuentran ocultos para Guatemala:
    | Proceso                       |
    | Módulo Cotizador               |
    | Módulo Bitácora de conducción  |
    | Módulo Operación portuaria     |
    | Módulo Paquetería              |
    When el desarrollador activa la visibilidad de dichos procesos para el país "Guatemala"
    Then cada proceso debe estar visible y accesible para usuarios de Guatemala
    And la configuración de otros países no debe verse afectada

#Scenario: Activar módulos completos
    Given los siguientes módulos se encuentran completamente ocultos para Guatemala:
    | Módulo                           |
    | Módulo Control volumétrico       |
    | Módulo Doble check               |
    | Módulo Planeación de solicitudes |
    | Módulo Fiscal                    |
    | Módulo EDI                       |
    When el desarrollador activa la visibilidad de dichos módulos para el país "Guatemala"
    Then cada módulo debe estar visible y accesible para usuarios de Guatemala
    And todos los subprocesos asociados deben habilitarse de forma correspondiente
    And la configuración de otros países no debe verse afectada

Scenario: Activar procesos del Módulo Nómina
    Given los siguientes procesos del módulo "Nómina" se encuentran ocultos para Guatemala:
    | Proceso                                       |
    | Catálogo de Equivalencias de CC               |
    | Catálogo de tipos de períodos                 |
    | Catálogo de Puesto                            |
    | Catálogo de Departamentos                     |
    | Catálogo de Turnos                            |
    | Catálogo de Períodos                          |
    | Catálogo de Tipos de incidencias              |
    | Catálogo de Conceptos PDO                     |
    | Catálogo de Tipos de acumulados               |
    | Catálogo de Fórmulas                          |
    | Catálogo de Parámetros generales              |
    | Modificación de variables                     |
    | Utilería Importar Incidencias                 |
    | Utilería Eliminar Finiquito                   |
    | Utilería Verificación Historial de Empleado   |
    | Utilería Abrir y Cerrar Períodos              |
    | Utilería Eliminar Recibos                     |
    | Utilería Abrir períodos específicos           |
    | Utilería Importación de PDO Fijos             |
    | Proceso Aguinaldo                             |
    | Reporte Impresión Masiva de Recibos           |
    When el desarrollador activa la visibilidad de dichos procesos para el país "Guatemala"
    Then cada proceso debe estar visible y accesible para usuarios de Guatemala
    And la configuración de otros países no debe verse afectada

Scenario: Validación general post-activación
    Given todos los procesos y módulos han sido activados para el país "Guatemala"
    When un usuario con sesión activa vinculada al país "Guatemala" accede al sistema
    Then debe visualizar todos los módulos y procesos previamente ocultos
    And cada proceso debe ejecutarse sin errores de configuración