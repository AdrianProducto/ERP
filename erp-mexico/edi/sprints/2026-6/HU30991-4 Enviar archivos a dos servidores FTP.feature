Feature: Enviar archivos EDI a servidores configurados
  Como cliente que utiliza archivos EDI para el envio de información
  Necesito que al denotarse el envio de alguno de dichos archivos el sistema los envie a los servidores que tiene configurado mi cliente
  Para que mi cliente cuente con la información necesaria para su operación

  Scenario: Envio de archivo con mas de un servidor configurado
    Given un cliente cuenta con mas de un servidor FTP configurado para un mismo carrier
    When se detone un evento que genera un archivo EDI del carrier configurado
    Then el sistema envia el archivo generado a los servidores FTP configurados

  Scenario: Envio de archivo con un solo servidor configurado
    Given un cliente cuenta con un servidor FTP configurado para un carrier
    When se detone un evento que genera un archivo EDI del carrier configurado
    Then el sistema envia el archivo generado al servidor FTP configurado
    