Feature: Nuevo Endpoint para la autenticación del usuario que ejecutará la API
    Yo como Analista de Producto,
    Quiero que se cree un nuevo Endpoint para la autenticación del cliente que va a ejecutar una API de importación de materiales a un viaje,
    Para una mejor seguridad en el proceso de integración con otras plataformas.
  
  Background:
    Given que en el sistema GM Transport ERP se pueden registrar materiales dentro de un viaje
      And el sistema está preparado para recibir información de materiales a través de una API de integración con otras plataformas

  Scenario: El cliente se intenta autenticar para poder ejecutar la importación de materiales a un viaje con las credenciales correctas
    Given que el cliente tiene el nuevo Endpoint para autenticarse
      And el cliente tiene las credenciales que el endpoint requiere para la autenticación que son el RFC del cliente y una contraseña impartida por GM Transport
     When el cliente ejecute el Endpoint
      And se valide que las credenciales sean correctas
     Then se regresará al cliente un token único con una vigencia de 24 horas para que pueda ser utilizado en el otro Endpoint de importación de materiales
      And el endpoint regresará un mensaje de éxito indicando que la autenticación fue correcta y el token fue generado exitosamente, por ejemplo:
        '''
        Autenticación exitosa: El token ha sido generado correctamente. El token es: [token generado]
        '''

  Scenario: El cliente se intenta autenticar para poder ejecutar la importación de materiales a un viaje con credenciales incorrectas
    Given que el cliente tiene el nuevo Endpoint para autenticarse
      And el cliente tiene las credenciales que el endpoint requiere para la autenticación que son el RFC del cliente y una contraseña impartida por GM Transport
     When el cliente ejecute el Endpoint
      And se valide que las credenciales sean incorrectas
     Then no se generará ningún token para el cliente
      And el endpoint regresará un mensaje de error indicando que la autenticación fue incorrecta y que el token no pudo ser generado, por ejemplo:
        '''
        Error de autenticación: Las credenciales proporcionadas son incorrectas. No se pudo generar el token. Favor de verificar el RFC y la contraseña e intentar nuevamente.
        '''



