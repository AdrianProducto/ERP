Feature: Servicio para generar correo en caso de error de importación de materiales a un viaje
    Yo como Analista de Producto,
    Quiero que se genere un correo al equipo del cliente en caso de que ocurra un error durante la importación de materiales a un viaje,
    Para que el equipo del cliente esté informado sobre los errores y pueda tomar acciones para resolverlos.
  
  Background:
    Given que existe un proceso de importación de materiales a un viaje a través de un Endpoint en el sistema GM Transport ERP
      And el sistema está preparado para enviar correos electrónicos en caso de errores durante el proceso de importación de materiales

  Scenario: Generar un correo cuando exista un error al importar materiales a un viaje porque no se encontró el viaje en el sistema
    Given que el cliente ejecutó el Endpoint de Importación de Materiales proporcionando un token válido
      And se validó que el viaje escrito por el cliente no existe en el sistema GM Transport ERP
     When el endpoint muestre la respuesta de error 
     Then se generará un correo electrónico dirigido al equipo del cliente "documentos@sersal.mx" con el asunto "Error en la importación de materiales" y el siguiente mensaje en el cuerpo del correo, por ejemplo:
       '''
       Buen día,

       Se ha detectado un error durante el proceso de importación de materiales a un viaje. El error se debe a que el viaje especificado no existe en el sistema GM Transport ERP.

       Detalles del error:
       - Viaje especificado: [Viaje]
       - Fecha y hora del intento de importación: [Fecha y hora]

       Se adjunta a este correo el archivo con la información de los materiales que se intentaron importar para que puedan registrarlos manualmenten en el sistema.

       Atentamente,
       Equipo de GM Transport
       '''
      And se adjuntará al correo un archivo en formato Excel con la información de los materiales que se intentaron importar, respetando la siguiente estructura:
        | Viaje       | FolioFactura       | Descripcion    | Cantidad   | UnidadEmbalaje   | Peso    | UnidadPeso   | ClaveProdServ  | ClaveUnidadMedida | ClaveUnidad |
        | ----------- | ------------------ | -------------- | ---------- | ---------------- | ------- | ------------ | -------------- | ----------------- | ----------- |
        | MXL-12345   | SULTANA-949393     | ARTICULO 1     | 1.000      | CAJAS            | 250.000 | KILOGRAMOS   | 15151515       | 151515151         | 2051560     |
        | MXL-12345   | SULTANA-949393     | ARTICULO 2     | 1.000      | CAJAS            | 250.000 | KILOGRAMOS   | 15151515       | 151515151         | 2051560     |

