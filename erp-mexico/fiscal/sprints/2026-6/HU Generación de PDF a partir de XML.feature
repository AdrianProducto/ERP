# Característica
Feature: Generación de PDF a partir de XML
  Como usuario de GM Fiscal
  Quiero obtener una representación PDF de un CFDI XML
  Para consultarlo, descargarlo y usarlo como soporte documental

  Background:
    Given que GM Fiscal cuenta con el XML timbrado del CFDI

  Scenario: Visualizar correctamente el PDF generado desde un XML válido
    Given que el XML del CFDI es válido
    When el usuario solicita visualizar el PDF
    Then el sistema genera el PDF del CFDI
    And muestra la representación del documento al usuario

  Scenario: Descargar el PDF generado
    Given que el PDF del CFDI fue generado exitosamente
    When el usuario solicita descargar el PDF
    Then el sistema entrega el archivo PDF correspondiente al XML consultado  

  Scenario Outline: Mostrar mensaje controlado cuando no es posible generar el PDF
    Given que el XML presenta la condición <condicion_error>
    When el usuario solicita generar el PDF
    Then el sistema no genera el documento
    And muestra el mensaje <mensaje_esperado>

    Examples:
      | condicion_error          | mensaje_esperado                                     |
      | XML inválido             | No fue posible generar el PDF a partir del XML       |
      | XML incompleto           | El XML no contiene información suficiente para el PDF |
      | CFDI no encontrado       | No se encontró el CFDI solicitado                    |
