Feature: Nuevo parámetro para generar R41 en el catálogo de clientes
    Yo como usuario de Tráfico,
    Quiero que exista un nuevo parámetro en el catálogo de clientes que permita generar un reporte R41 en formato JSON al viaje de ese cliente,
    Para facilitar la integración con otros sistemas.

  Scenario: Entrar al catálogo de clientes y configurar el nuevo parámetro para generar R41
    Given que el usuario se encuentra en el catálogo de clientes del módulo de Tráfico,
      And el usuario quiere registrar o modificar un cliente
     When el usuario se encuentre en la pestaña de "Procesos Especiales" al registrar o modificar un cliente
     Then apacererá un nuevo parámetro llamado "Generar R41 detallado de VINs por JSON"
      And el parámetro se encontrará deshabilitado por default

  Scenario: Activar el nuevo parámetro
    Given que el usuario se encuentra en el catálogo de clientes del módulo de Tráfico
      And el usuario está registrando o modificando un cliente
      And el usuario haya encontrado el nuevo parámetro "Generar R41 detallado de VINs por JSON" en la pestaña de "Procesos Especiales"
     When el usuario habilite el nuevo parámetro
     Then aparecerá un campo de texto en donde se podrá ingresar el Endpoint hacia donde se quiera enviar el archivo JSON con el R41 de los viajes creados con este cliente



