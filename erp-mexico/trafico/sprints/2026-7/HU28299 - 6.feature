Feature: Generación de R41 en formato JSON con código de evento "D09"
    Yo como usuario de Tráfico,
    Quiero que se genere un documento R41 en formato JSON al momento de crear un viaje con un cliente en donde el estatus del viaje sea el que represente el código de evento "D09",
    Para facilitar la integración con otros sistemas.

  Background:
    Given que el nuevo parámetro "Generar R41 detallado de VINs por JSON" se encuentra habilitado para el cliente del viaje
      And el usuario se encuentra creando un viaje con ese cliente
      And el usuario haya descrito qué estatus del viaje representa el código de evento "D09" en el catálogo de estatus de viaje

  Scenario: Terminar un viaje o modificar un viaje existente y asignarle el estatus con código de evento "D09"
    Given que el usuario se encuentra documentando un viaje con un cliente que tiene habilitado el nuevo parámetro para generar el R41 en formato JSON
      And el usuario quiere asignarle al viaje un estatus que represente el código de evento "D09"
      And el usuario haya ingresado la información de los materiaeles transportados en el viaje, incluyendo la información de los VINs de los vehículos transportados
     When el usuario asigne al viaje un estatus que represente el código de evento "D09"
     Then el sistema generará un documento R41 en formato JSON con la información del viaje y los VINs de los vehículos transportados en ese viaje
      And el sistema enviará automáticamente el archivo JSON al Endpoint configurado en el catálogo de clientes para ese cliente
      And la estructura del JSON generado deberá cumplir con el siguiente formato:
      '''
      {
        "R41": [
          {
            "vin": "VYJFGAFT4T5818808",
            "bol": "D09BOL000001",
            "eventCode": "D09",
            "eventDateTime": "2026-07-10T15:45:00-07:00",
            "dest": "M7680",
            "truckType": "O",
            "truckNumber": "47BK8Z",
            "tripNumber": "SL-783354",
            "truckCapacity": "9",
            "truckPos": "3",
            "loadPos": "F",
            "latitude": "32.502778",
            "longitude": "-116.958056",
            "stopSeq": "1",
            "damageInd": "N"
          },
          {
            "vin": "VYJFEAFT8T5824360",
            "bol": "D09BOL000001",
            "eventCode": "D09",
            "eventDateTime": "2026-07-10T15:50:00-07:00",
            "dest": "M1030",
            "truckType": "O",
            "truckNumber": "47BK8Z",
            "tripNumber": "SL-783354",
            "truckCapacity": "9",
            "truckPos": "3",
            "loadPos": "R",
            "latitude": "32.502778",
            "longitude": "-116.958056",
            "stopSeq": "1",
            "damageInd": "Y"
          },
          {
            "vin": "VYJFEAFT3T5824430",
            "bol": "D09BOL000001",
            "eventCode": "D09",
            "eventDateTime": "2026-07-10T15:55:00-07:00",
            "dest": "M1030",
            "truckType": "O",
            "truckNumber": "47BK8Z",
            "tripNumber": "SL-783354",
            "truckCapacity": "9",
            "truckPos": "3",
            "loadPos": "F",
            "latitude": "32.502778",
            "longitude": "-116.958056",
            "stopSeq": "1",
            "damageInd": "N"
          }
        ]
      }
      '''
      And cada campo del JSON representará la siguiente información:
        '''
            "vin": número de identificación vehicular de cada vehículo transportado en el viaje, se tomará del campo "Descripción" del listado de materiales el viaje,
            "bol": folio del viaje registrado en el sistema, se compone de "Sucursal"+"Folio del viaje"
            "eventCode": código de evento asignado al estatus del viaje,
            "eventDateTime": fecha y hora en la que el viaje alcanzó el estatus con código de evento "D09", respetar la zona horaria de la sucursal donde se está generando el viaje,
            "dest": código del destinatario del trayecto donde se transporta el vehículo, se tomará del campo de No. Equivalencia del catálogo de Remitentes-Desinatarios,
            "truckType": se tomará del campo "Truck Type" de la sección de Info. Adicional VINs en la descripción del material del viaje,
            "truckNumber": código de la unidad asignada al trayecto del viaje,
            "tripNumber": folio del viaje que el cliente pondrá en el campo No Viaje Cliente al momento de crear o modificar el viaje,
            "truckCapacity": tomará del nuevo campo Capacidad (unidades) que se agregó al catálogo de Unidades, en caso de que la unidad asignada al viaje tenga registrada una capacidad en ese campo, de lo contrario se enviará un valor de 0,
            "truckPos": se tomará del campo "Truck Position" de la sección de Info. Adicional VINs en la descripción del material del viaje,
            "loadPos": se tomará del campo "Load Position" de la sección de Info. Adicional VINs en la descripción del material del viaje,
            "latitude": se tomará la información mediante la petición de la información de la API de Scania en donde se tomará el valor de la latitud de la unidad asignada al viaje,
            "longitude": se tomará la información mediante la petición de la información de la API de Scania en donde se tomará el valor de la longitud de la unidad asignada al viaje,
            "stopSeq": número de secuencia del trayecto del viaje,
            "damageInd": se tomará del campo "Damage Indicator" de la sección de Info. Adicional VINs en la descripción del material del viaje, será de valor "Y" en caso de que se haya registrado algún daño al vehículo transportado, o "N" en caso de que no se haya registrado ningún daño
        '''

