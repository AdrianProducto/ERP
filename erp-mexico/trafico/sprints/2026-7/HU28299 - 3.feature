Feature: Habilitar nueva sección llamada "Info. Adicional VINs" en el apartado de Materiales del viaje
    Yo como usuario de Tráfico,
    Quiero que exista una nueva sección llamada "Info. Adicional VINs" en la descripción de cada material del viaje,
    Para poder registrar información adicional relacionada a los VINs de los vehículos transportados en el viaje.

  Background:
    Given que el nuevo parámetro "Generar R41 detallado de VINs por JSON" se encuentra habilitado para el cliente del viaje
      And el usuario se encuentra creando o modificando un viaje con ese cliente
      And el usuario puede registrar materiales mediante la importación de un archivo Excel con la información de los VINs de los vehículos transportados en el viaje

  Scenario: Configurar formato de archivo Excel con información de VINs
    Given que el usuario se encuentra en la sección de Materiales al crear o modificar un viaje
      And el usuario quiere crear un nuevo formato de importación para registrar la información de los VINs de los vehículos
     When el usuario esté configurando el formato de importación del archivo Excel
     Then aparecerá una nueva pestaña llamada "Información VINs" en la ventana de configuración del formato de importación
      And solicitará al usuario mapear las siguientes columnas del archivo Excel: "Truck Position", "Truck Orientation", "Truck Type", "Damage Indicator"

  Scenario: Cargar archivo Excel de la plantilla con información de VINs
    Given que el usuario se encuentra en la sección de Materiales al crear o modificar un viaje
      And el usuario quiere ingresar la información de los materiales mediante el proceso de importacion de materiales
      And el usuario ya tiene configurado el formato de importación del archivo Excel con la información de los VINs de los vehículos
     When el usuario cargue el archivo con la información de los materiales
     Then el sistema cargará la información de los VINs de los vehículos transportados en el viaje junto con la información adicional de los VINs
      And la información adicional de los VINs se podrá visualizar en la nueva sección "Info. Adicional VINs" dentro de la descripción de cada material del viaje
      And la información adicional se podrá editar manualmente en el sistema

