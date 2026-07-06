Feature: Parámetro para enviar correo al facturar viaje desde el listado de viajes 
  Yo como usuario de Tráfico,
  Quiero tener una opción para poder enviar un correo de la factura al crearla desde el listado de viajes,
  Para una mejor usabilidad en el sistema.
  
  Background:
    Given que el usuario haya entrado al sistema
    And se encuentre en el módulo de Tráfico
    And sabe que existen parámetros en el módulo de Facturación que afectan al proceso de generación de facturas de viajes como "Envío automático de factura" y "Facturar automáticamente desde Viajes"
  
  Rule: El parámetro "Envío automático de factura" solicita al usuario enviar un correo de la factura si la factura está timbrada
    And El parámetro "Facturar automáticamente desde Viajes" crea una factura y la timbra automáticamente sin consultar confirmación del usuario

  Scenario: Mostrar nuevo parámetro en el menú de parámetros del módulo
    Given que el usuario está en la configuración de parámetros del módulo de Tráfico
     Then debe existir el nuevo parámetro llamado "Poder enviar correo al facturar viaje desde el listado de viajes"
      And el parámetro debe estar inactivo por default
      And el parámetro debe describir lo siguiente en el tooltip:
      '''
        Solicitará al usuario enviar un correo de la factura al facturar un viaje desde el listado de viajes sin depender si está timbrada.
      '''

  Scenario Outline: Creación de factura y envío de correo dependiendo del estatus de los parámetros
    Given que el usuario tiene un viaje registrado en el listado de viajes
     When el usuario facture un viaje y <estatusNuevoParámetro> está activo
      And el parámetro "Envío automático de factura" esté <estatusParámetro1>
      And el parámetro "Facturar automáticamente desde Viajes" esté <estatusParámetro2>
      And el estatus de timbrado de la factura es <timbrado>
     Then el proceso del parámetro <nombreParámetro> se ejecutará
      And la pantalla de correo <mostrarpantalla> se mostrará
      And el correo <estatusEnvíoCorreo>

     Examples:
       | estatusNuevoParámetro | estatusParámetro1 | estatusParámetro2 | timbrado    | nombreParámetro                                                  | mostrarpantalla | estatusEnvíoCorreo |
       | activo                | inactivo          | inactivo          | timbrada    | Poder enviar correo al facturar viaje desde el listado de viajes | sí              | enviado            |
       | activo                | inactivo          | inactivo          | no timbrada | Poder enviar correo al facturar viaje desde el listado de viajes | sí              | enviado            |
       | inactivo              | inactivo          | inactivo          | timbrada    | Ninguno                                                          | no              | no enviado         |
       | activo                | activo            | inactivo          | timbrada    | Envío automático de factura                                      | no              | enviado            |
       | activo                | activo            | inactivo          | no timbrada | Poder enviar correo al facturar viaje desde el listado de viajes | sí              | enviado            |
       | inactivo              | activo            | activo            | timbrada    | Facturar automáticamente desde Viajes                            | no              | enviado            |
       | activo                | inactivo          | activo            | timbrada    | Facturar automáticamente desde Viajes                            | no              | enviado            |
       | activo                | activo            | activo            | timbrada    | Facturar automáticamente desde Viajes                            | no              | enviado            |
       | inactivo              | activo            | inactivo          | timbrada    | Envío automático de factura                                      | no              | enviado            |
       | inactivo              | activo            | inactivo          | no timbrada | Envío automático de factura                                      | no              | no enviado         |

  Scenario: Mandar correo desde la pantalla de correo de la factura teniendo sólamente el nuevo parámetro activo
    Given que el usuario ha creado una factura
      And el usuario decidio enviar un correo
      And aparece la pantalla de correo
     When el usuario quiera generar el correo para enviarlo al cliente
     Then el usuario podrá enviar el correo sin ningún problema y el correo se enviará correctamente
      And no podrá agregar más documentos al correo que no sean la factura del viaje



