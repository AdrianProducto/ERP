Feature: Nuevo Endpoint para Importar Materiales hacia un viaje en el ERP
    Yo como Analista de Producto,
    Quiero que se cree un nuevo Endpoint para importar materiales hacia un viaje en el ERP,
    Para facilitar el proceso de integración con otras plataformas y permitir que los clientes puedan registrar los materiales que se van a transportar en un viaje de manera más eficiente.
  
  Background:
    Given que en el sistema GM Transport ERP se pueden registrar materiales dentro de un viaje
      And el sistema está preparado para recibir información de materiales a través de una API de integración con otras plataformas
      And existe un endpoint que genera un token único para permitir el proceso de Importación de Materiales
      And el endpoint notifica al cliente si no pudo ser posible el proceso de Importación de Materiales a través de un correo electrónico

  Scenario: El cliente ejecuta el Endpoint de Importación de Materiales con un token válido
    Given que el cliente tiene el nuevo Endpoint para importar materiales hacia un viaje
      And el cliente tiene un token generado por el Endpoint de autenticación
     When el cliente ejecute el Endpoint de Importación de Materiales proporcionando el token y la información requerida de los materiales a importar
      And se valide que exista el viaje comparando el dato "Viaje" en el listado de viajes del sistema GM Transport ERP en la columna de "VIAJE" donde se muestra el dato "[Viaje]"
      And el token proporcionado sea válido y tenga vigencia
      And la información esté en formato JSON respetando la siguiente estructura, como este ejemplo:
        '''
        {
            "Viaje": "MXL-12345",
            "FolioFactura": "SULTANA-949393",
            "Mercancias": [
                {
                    "CantidadTotal": 2.000,
                    "PesoTotal": 500.000,
                    "UnidadPeso": "KILOGRAMOS",
                    "Mercancia": [
                        {
                            "Cantidad": 1.000,
                            "Descripcion": "ARTICULO 1",
                            "UnidadEmbalaje": "CAJAS",
                            "Peso": 250.000,
                            "UnidadPeso": "KILOGRAMOS",
                            "ComplementoCP": [
                                {
                                    "ClaveProdServ": 15151515,
                                    "ClaveUnidadMedida": 151515151,
                                    "ClaveUnidad": 2051560
                                }
                            ]
                        },
                        {
                            "Cantidad": 1.000,
                            "Descripcion": "ARTICULO 2",
                            "UnidadEmbalaje": "CAJAS",
                            "Peso": 250.000,
                            "UnidadPeso": "KILOGRAMOS",
                            "ComplementoCP": [
                                {
                                    "ClaveProdServ": 15151515,
                                    "ClaveUnidadMedida": 151515151,
                                    "ClaveUnidad": 2051560
                                }
                            ]
                        }
                    ]
                }
            ]
        }
        '''
     Then los materiales serán importados correctamente hacia el viaje especificado en el sistema GM Transport ERP
      And se actualizará el viaje con la información de los materiales importados
      And el campo "FolioFactura" quedará registrado en el campo de "No. Viaje Cliente" del viaje
      And el endpoint regresará un mensaje de éxito indicando que los materiales fueron importados correctamente, por ejemplo:
        '''
        Importación exitosa: Los materiales han sido importados correctamente hacia el viaje [Viaje].
        '''
  
  Scenario: El cliente ejecuta el Endpoint de Importación de Materiales con un token inválido
    Given que el cliente tiene el nuevo Endpoint para importar materiales hacia un viaje
      And el cliente tiene un token generado por el Endpoint de autenticación
     When el cliente ejecute el Endpoint de Importación de Materiales proporcionando el token y la información requerida de los materiales a importar
      And se valide que exista el viaje comparando el dato "Viaje" en el listado de viajes del sistema GM Transport ERP
      And el token proporcionado sea inválido o no tenga vigencia
     Then no se importarán los materiales hacia el viaje en el sistema GM Transport ERP
      And el endpoint regresará un mensaje de error indicando que la autenticación fue incorrecta y que los materiales no pudieron ser importados, por ejemplo:
        '''
        Error de autenticación: El token proporcionado es inválido o ha expirado. No se pudieron importar los materiales. Favor de proporcionar un token válido e intentar nuevamente.
        '''
    
  Scenario: El cliente ejecuta el Endpoint de Importación de Materiales con un viaje que no existe en el sistema GM Transport ERP
    Given que el cliente tiene el nuevo Endpoint para importar materiales hacia un viaje
      And el cliente tiene un token generado por el Endpoint de autenticación
     When el cliente ejecute el Endpoint de Importación de Materiales proporcionando el token y la información requerida de los materiales a importar
      And se valide que no exista el viaje comparando el dato "Viaje" en el listado de viajes del sistema GM Transport ERP
     Then no se importarán los materiales hacia ningún viaje en el sistema GM Transport ERP
      And el endpoint regresará un mensaje de error indicando que el viaje no existe y que los materiales no pudieron ser importados, por ejemplo:
        '''
        Error de validación: El viaje [Viaje] no existe en el sistema. No se pudieron importar los materiales. Favor de verificar la información del viaje e intentar nuevamente.
        '''
      And se enviará un correo al equipo del cliente notificando el error en la importación, el correo al que se le enviará el mensaje es "documentos@sersal.mx"


