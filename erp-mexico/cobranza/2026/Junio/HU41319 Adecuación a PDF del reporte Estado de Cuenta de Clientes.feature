Feature: Generación del reporte Estado de Cuenta de Clientes
  Como usuario de cobranza
  Necesito poder generar el reporte Estado de Cuenta de Clientes
  Para visualizar la información completa y poder enviarla a las áreas correspondientes

  Scenario: Generar y visualizar el reporte Estado de Cuenta de Clientes
    Given que el usuario de cobranza se encuentra en el módulo de reportes
    When el usuario genera el reporte "Estado de Cuenta de Clientes"
    Then el sistema debe mostrar la información completa del estado de cuenta del cliente

  Scenario: Ajustar tamaño de letra al exportar el reporte a PDF
    Given que el usuario ha generado el reporte "Estado de Cuenta de Clientes"
    When el usuario exporta el reporte a formato PDF
    Then la información del listado de pagos y sus encabezados debe mostrarse con tamaño de letra 6
    And el resto del contenido del reporte debe conservar su formato original

  Scenario: Formatear la columna Documento al exportar el reporte a PDF
    Given que el usuario ha generado el reporte "Estado de Cuenta de Clientes"
    When el usuario exporta el reporte a formato PDF
    Then en la columna "Documento" debe mostrarse únicamente las primeras 3 letras del tipo de documento
    And el folio correspondiente debe mostrarse sin ceros a la izquierda

  Scenario: Validar formato combinado de la columna Documento en PDF
    Given que el reporte exportado a PDF contiene un documento de tipo "Factura" con folio "000045"
    When el usuario visualiza la columna "Documento" en el PDF generado
    Then debe mostrarse el texto "FAC45"