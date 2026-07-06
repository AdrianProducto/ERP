Feature: Integracion de zonas horarias de guatemala dentro del sistema

    Yo como usuario del sistema
    Requiero que se tengan las zonas horarias correspondientes a los paises de centroamerica
    Para que el usuario pueda configurar sus sucursales de acuerdo a la actividad de su pais.

Background:
    Given que el usuario se encuentra dentro de una base de datos configurada con el pais de guatemala.

Scenario: Nuevas zonas horarias en el sistema
    When el usuario ingrese al catalogo de sucursales
    And abra el combo "Zona Horaria"
    Then el combo "Zona Horaria" debe mostrar las siguientes opciones:

    |Zonas horarias de CA            |
    |(UTC-06:00) CIUDAD DE GUATEMALA |
    |(UTC-06:00) SAN SALVADOR        |
    |(UTC-06:00) TEGUCIGALPA         |
    |(UTC-06:00) MANAGUA             |
    |(UTC-06:00) SAN JOSÉ            |
    |(UTC-06:00) BELMOPÁN            |
    |(UTC-05:00) CIUDAD DE PANAMÁ    |

Scenario Outline: Guardado de zona horaria en sucursal
  When el usuario selecciona <ZonaHoraria>
  And guarda la sucursal
  Then el sistema debe almacenar correctamente la zona horaria seleccionada

  Example:
  |Zona horarias de CA             |
  |(UTC-06:00) CIUDAD DE GUATEMALA |
  |(UTC-06:00) SAN SALVADOR        |
  |(UTC-06:00) TEGUCIGALPA         |
  |(UTC-06:00) MANAGUA             |

Scenario: Visualización actualizada del combo "Zona Horaria" en todos los módulos del sistema
  When el usuario accede a cualquier pantalla del sistema donde se encuentre disponible el combo "Zona Horaria"
  Then el combo debe mostrar las siguientes opciones actualizadas:

    | Zona horaria                    |
    | (UTC-06:00) CIUDAD DE GUATEMALA |
    | (UTC-06:00) SAN SALVADOR        |
    | (UTC-06:00) TEGUCIGALPA         |
    | (UTC-06:00) MANAGUA             |
    | (UTC-06:00) SAN JOSÉ            |
    | (UTC-06:00) BELMOPÁN            |
    | (UTC-05:00) CIUDAD DE PANAMÁ    |

Scenario: Procesos afectados por configuración de zona horaria
  When exista un proceso que utilice fecha u hora basada en la sucursal configurada
  Then el sistema debe tomar la zona horaria actualizada asignada a la sucursal

Scenario: Mantener zonas horarias de México para bases de datos de México
  Given que el usuario accede a una base de datos de México
  When el usuario consulte el combo "Zona Horaria"
  Then el sistema muestra las <zonasHorariasMexicanas>

  |zonasHorariasMexicanas           |
  |(UTC-05:00) Cancún, Quintana Roo |
  |(UTC-06:00) Bahía de Banderas    |
  |(UTC-06:00) Campeche, Yucatán    |
  |(UTC-06:00) Chihuahua            |