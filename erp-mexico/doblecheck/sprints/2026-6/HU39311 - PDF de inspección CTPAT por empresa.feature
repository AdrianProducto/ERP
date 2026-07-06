# Característica
@DobleCheck @Inspecciones @CTPAT @FormatoPDF
Feature: PDF de inspección CTPAT por empresa

  Como administrador de Doble Check
  Quiero que el PDF generado para una inspección CTPAT varíe según la empresa
  Para que cada empresa reciba el formato de inspección que le corresponde

  # Antecedentes
  Background:
    # Dado
    Given que todas las empresas responden el mismo formulario "Inspección CTPAT"
    # Y
    And el formato PDF default para inspecciones CTPAT es "Formato General CTPAT"

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  @happy_path
  Scenario: Crear el nuevo formato PDF "Formato CTPAT 17 Puntos"
    # Dado
    Given que no existe un formato PDF llamado "Formato CTPAT 17 Puntos"
    # Cuando
    When el sistema registra el formato "Formato CTPAT 17 Puntos"
        para la empresa "LUM001213EF6"
    # Entonces
    Then el formato debe contener las siguientes secciones en este orden:
      | Orden | Sección                            |
      | 1     | Encabezado con datos generales     |
      | 2     | Inspección Tractocamión – 5 Puntos |
      | 3     | Inspección Remolque – 12 Puntos    |
      | 4     | Inspección Agrícola                |
      | 5     | Revisión de Sello de Seguridad     |
      | 6     | Resultado de Inspección            |
      | 7     | Acciones Tomadas                   |
      | 8     | Firmas                             |
    # Y
    And la estructura visual debe corresponder al documento de referencia
        "Formato_Inspeccion_CTPAT_17_Puntos_Con_Agricultura.pdf"
    # Y
    And el formato queda asignado al formulario "Inspección CTPAT"
        de la empresa "LUM001213EF6"

  @happy_path
  Scenario: PDF de inspección CTPAT para LUM001213EF6
    # Dado
    Given que la empresa "LUM001213EF6" completó una inspección CTPAT
    # Cuando
    When se genera el PDF de esa inspección
    # Entonces
    Then el PDF corresponde al formato "Formato CTPAT 17 Puntos"

  @happy_path
  Scenario: PDF de inspección CTPAT para cualquier otra empresa
    # Dado
    Given que una empresa distinta a "LUM001213EF6" completó una inspección CTPAT
    # Cuando
    When se genera el PDF de esa inspección
    # Entonces
    Then el PDF corresponde al formato "Formato General CTPAT"
    # Y
    And no usa el formato "Formato CTPAT 17 Puntos"
