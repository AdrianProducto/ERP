Feature: Adecuación de Layout de Importación — Dirección para Clientes Guatemala
  Como usuario administrador del sistema en la de Guatemala
  Quiero que al importar clientes desde Excel, el layout contenga una columna "Dirección" en lugar de las columnas individuales "Calle", "NoExterior", "NoInterior", "Colonia" y "Localidad"
  Para poder capturar la dirección completa en un solo campo, de acuerdo al formato de dirección utilizado en Guatemala, y evitar la fragmentación en campos que no corresponden al modelo de dirección guatemalteco

  Background:
    Given el sistema está configurado con ClsSisLicencias::m_nTipoSistema = SISTEMA_GUATEMALA
    And el archivo de layout descargable es ImportarClientesGT.xls
    And el usuario tiene permisos de acceso al módulo de Catálogo de Clientes

  @Guatemala @Layout @Importacion @HappyPath
  Scenario: Descargar layout de importación de clientes con el nuevo formato para Guatemala
    Given el usuario está en la página PAGE_CatClientesImportar
    When el usuario hace clic en el enlace "Descargar Layout"
    Then el sistema descarga el archivo ImportarClientesGT.xls
    And el archivo contiene exactamente 15 columnas en la primera fila (encabezados)
    And los encabezados de columna son: NumeroCliente, FechaAlta, AsesorComercial, NIT, NombreFiscal, TipoCliente, Direccion, IdMunicipio, IdDepartamento, CodigoPostal, DiasCredito, CreditoQuetzales, CreditoDolares, IdMoneda, IdRegimenFiscal
    And el archivo NO contiene las columnas Calle, NoExterior, NoInterior, Colonia, Localidad

  @Guatemala @Layout @Importacion @HappyPath
  Scenario: Importar clientes exitosamente usando el nuevo layout de Guatemala
    Given el usuario ha descargado el layout ImportarClientesGT.xls con el nuevo formato de 15 columnas
    And el usuario ha llenado la columna "Direccion" con la dirección completa del cliente
    And el usuario ha llenado las columnas restantes con datos válidos
    When el usuario selecciona el archivo en EDT_Archivo
    And el usuario hace clic en BTN_Cargar
    Then el sistema procesa el archivo correctamente
    And el sistema almacena el valor de la columna "Direccion" en el campo CatClientes.Direccion
    And el sistema NO intenta leer las columnas Calle, NoExterior, NoInterior, Colonia, Localidad
    And los campos CatClientes.Calle, CatClientes.NoExterior, CatClientes.NoInterior, CatClientes.Colonia, CatClientes.Localidad quedan vacíos para el registro importado
    And el sistema muestra el mensaje "Total de registros importados: N"

  @Guatemala @Layout @Importacion @HappyPath
  Scenario: Importar cliente guatemalteco con dirección completa y datos complementarios
    Given el layout contiene los siguientes datos de un cliente en una fila:
      | NumeroCliente | FechaAlta  | AsesorComercial | NIT         | NombreFiscal    | TipoCliente | Direccion                       | IdMunicipio | IdDepartamento | CodigoPostal | DiasCredito | CreditoQuetzales | CreditoDolares | IdMoneda | IdRegimenFiscal |
      | 1001          | 01/06/2026 | 001             | 12345678K   | CLIENTE GT      | 1           | 6AV 3-45 ZONA 10 GUATEMALA CITY | 101         | 1              | 01010        | 30          | 50000.00         | 0.00           | 1        | 1               |
    When el usuario carga y ejecuta la importación
    Then el sistema crea el cliente con NIT "12345678K"
    And el sistema almacena Direccion = "6AV 3-45 ZONA 10 GUATEMALA CITY"
    And el sistema almacena IdMunicipio = "101"
    And el sistema almacena IdDepartamento = "1"
    And el sistema almacena CodigoPostal = "01010"
    And el sistema asigna el AsesorComercial correspondiente al código "001"

  @Guatemala @Layout @Importacion @Validation
  Scenario: Validar encabezados incorrectos — columna faltante
    Given el archivo cargado tiene un encabezado "Calle" en la columna 7 en lugar de "Direccion"
    When el usuario hace clic en BTN_Cargar
    Then el sistema muestra el error "La columna 7 debe ser Direccion"
    And el sistema NO importa ningún registro
    And el sistema cancela la operación

  @Guatemala @Layout @Importacion @Validation
  Scenario: Validar encabezados incorrectos — layout antiguo de 19 columnas
    Given el archivo cargado corresponde al layout antiguo de 19 columnas (con Calle, NoExterior, NoInterior, Colonia, Localidad)
    When el usuario hace clic en BTN_Cargar
    Then el sistema detecta que el encabezado en columna 7 es "Calle" y no "Direccion"
    And el sistema muestra el error correspondiente de validación de encabezados
    And el sistema NO importa ningún registro

  @Guatemala @Layout @Importacion @Validation
  Scenario: Importar cliente con dirección vacía
    Given el archivo cargado tiene el nuevo formato de 15 columnas
    And la columna "Direccion" está vacía para una fila
    When el usuario ejecuta la importación
    Then el sistema intenta crear el cliente
    And la validación en ClsCatClientes::Agregar() rechaza el registro porque "La dirección es un campo requerido"
    And el sistema registra el error en EDT_LogErrores

  @Guatemala @Layout @Importacion @Validation
  Scenario: Importar cliente con dirección muy larga
    Given el archivo cargado tiene el nuevo formato de 15 columnas
    And la columna "Direccion" contiene más de 200 caracteres
    When el usuario ejecuta la importación
    Then el sistema trunca o rechaza el valor según la capacidad del campo Direccion (varchar(200))
    And el sistema notifica el error en EDT_LogErrores si fue rechazado

  @Mexico @Layout @Importacion @Regression
  Scenario: México permanece sin cambios — layout con columnas individuales de dirección
    Given el sistema está configurado con ClsSisLicencias::m_nTipoSistema = SISTEMA_MEXICO
    When el usuario descarga el layout de importación
    Then el sistema descarga el archivo ImportarClientes.xls
    And el archivo contiene las 18 columnas originales
    And el archivo incluye las columnas Calle, NoExterior, NoInterior, Colonia, Localidad, Municipio
    And la columna "Direccion" NO está presente en el layout

  @Mexico @Layout @Importacion @Regression
  Scenario: México puede seguir importando clientes con el layout actual sin cambios
    Given el sistema está configurado con SISTEMA_MEXICO
    And el usuario carga un archivo ImportarClientes.xls con datos válidos
    When el usuario ejecuta la importación
    Then el sistema importa los clientes correctamente
    And el sistema construye Direccion concatenando Calle + NoExterior + NoInterior + Colonia + Localidad (igual que antes)
    And el sistema almacena individualmente Calle, NoExterior, NoInterior, Colonia, Localidad, Municipio

  @Mexico @Layout @Importacion @Regression
  Scenario: México rechaza el nuevo layout de Guatemala
    Given el sistema está configurado con SISTEMA_MEXICO
    And el usuario carga un archivo con el formato de Guatemala (15 columnas, columna "Direccion")
    When el usuario ejecuta la importación
    Then el sistema valida los encabezados contra el formato México
    And el sistema detecta que la columna 6 no es "TipoCliente" (porque el diseño de columnas es diferente)
    And el sistema muestra el error de validación correspondiente
    And el sistema NO importa ningún registro

  @Guatemala @Layout @Descarga @Integration
  Scenario: La descarga del layout incluye la hoja de asesores comerciales (tercera hoja)
    Given el sistema está configurado con SISTEMA_GUATEMALA
    When el usuario descarga el layout
    Then el sistema copia el archivo ImportarClientesGT.xls
    And el sistema carga los asesores comerciales activos en la hoja 3 del archivo Excel
    And el sistema entrega el archivo al usuario para descarga

  @Guatemala @Layout @Importacion @Integration
  Scenario: Importación respeta el tipo de sistema desde ClsSisLicencias
    Given el sistema tiene m_nTipoSistema = SISTEMA_GUATEMALA
    When el usuario hace clic en BTN_Cargar
    Then el sistema ejecuta la función cargarExcelGuatemala()
    And el sistema NO ejecuta cargarExcelMexico()
    And el sistema utiliza la validación de 15 columnas del nuevo layout GT