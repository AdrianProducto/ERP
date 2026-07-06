Feature: Importación de Consumos de Combustible para Transporte de Personal
  Como usuario administrador del módulo de Transporte de Personal
  Quiero importar consumos de combustible desde archivo, asignarlos a recorridos y generar gastos
  Para poder controlar el gasto de combustible por unidad y vincularlo a las liquidaciones de operadores

  Background:
    Given el usuario tiene permisos de acceso al módulo de Transporte de Personal
    
  @TPersonal @Combustible @Importacion @HappyPath
  Scenario: Descargar layout de importación de consumos de combustible
    Given el usuario está en la página PAGE_ProConsumosCombustibleTPersonalImportar
    When el usuario hace clic en el enlace "Descargar Layout"
    Then el sistema descarga el archivo ImportarConsumosCombustibleTPersonal.xls
    And el archivo contiene los encabezados: Tarjeta, FechaHora, NumeroComprobante, IdProveedor, IdUnidad, Litros, Subtotal, Total, Odometro, IdImpuestoTraslado, ImporteImpuesto

  @TPersonal @Combustible @Importacion @HappyPath
  Scenario: Importar consumos de combustible exitosamente
    Given el usuario ha llenado el layout ImportarConsumosCombustibleTPersonal.xls con 3 registros válidos
    When el usuario selecciona el archivo en EDT_Archivo
    And el usuario selecciona la "configuración de formato correcta"
    And el usuario selecciona el proveedor en el pickup proveedor
    And el Proveedor selecciona un %IVA del combo "% IVA"
    And el usuario hace clic en BTN_Cargar
    Then el sistema procesa el archivo correctamente
    And el sistema inserta 3 registros en ProConsumosCombustibleTPersonal
    And el sistema muestra el mensaje "Total de registros importados: 3"
    And los 3 registros tienen IdRecorridoParada = NULL
    And los 3 registros tienen IdGastoRecorrido = NULL

  @TPersonal @Combustible @Importacion @HappyPath
  Scenario: Importar consumo con datos completos
    Given el layout contiene los siguientes datos:
      | Tarjeta    | FechaHora           | NumeroComprobante | IdProveedor | IdUnidad | Litros | Subtotal | Total   | Odometro | IdImpuestoTraslado | ImporteImpuesto |
      | 4920123456 | 15/06/2026 08:30:00 | 100123            | 50          | 25       | 120.5  | 2068.97  | 2400.00 | 45820    | 1                  | 331.03          |
    When el usuario carga y ejecuta la importación
    Then el sistema crea el registro en ProConsumosCombustibleTPersonal
    And el sistema almacena Tarjeta = "4920123456"
    And el sistema almacena Litros = 120.5
    And el sistema almacena Total = 2400.00
    And el sistema almacena Odometro = 45820
    And el sistema almacena FechaHora = "15/06/2026 08:30:00"
    And el sistema almacena IdRecorridoParada = NULL
    And el sistema almacena IdGastoRecorrido = NULL

  @TPersonal @Combustible @Importacion @Validation
  Scenario: Rechazar importación con número de comprobante duplicado
    Given ya existe un registro en ProConsumosCombustibleTPersonal con NumeroComprobante = 100123
    And el archivo contiene un registro con NumeroComprobante = 100123 para la misma unidad
    And el archivo contiene un registro con IdProveedor = 50 
    When el usuario ejecuta la importación
    Then el sistema rechaza el registro duplicado
    And el sistema registra el error "El comprobante 100123 ya existe para esta unidad" en EDT_LogErrores

  @TPersonal @Combustible @Importacion @Validation
  Scenario: Importación masiva — algunos registros válidos, otros inválidos
    Given el archivo contiene 5 registros: 3 válidos y 2 con errores (unidad incorrecta, litros en cero)
    When el usuario ejecuta la importación
    Then el sistema importa los 3 registros válidos
    And el sistema rechaza los 2 registros con errores
    And el sistema muestra "Registros importados: 3" y "Registros con error: 2"
    And el sistema lista los errores en EDT_LogErrores