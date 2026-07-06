Feature: Habilitar configuración del parámetro de "Timbrar de Pruebas" sólo para usuarios GM
    Yo como Analista del ERP,
    Quiero que se limite el uso del parámetro de "Timbrar de Pruebas" en la ventana de Parámetros Generales de Configuración solo para usuarios GM,
    Para evitar que usuarios no autorizados puedan realizar pruebas de timbrado en el sistema.

  Background:
    Given que el parámetro "Timbrar de Pruebas" está disponible en la ventana de Parámetros Generales de Configuración
     And el usuario tiene acceso a la ventana de Parámetros Generales de Configuración

  Scenario: Entrar a la ventana de Parámetros Generales de Configuración como usuario GM
    Given que el usuario es un usuario GM
     When accede a la ventana de Parámetros Generales de Configuración
     Then puede ver y modificar el parámetro "Timbrar de Pruebas"

    Scenario: Entrar a la ventana de Parámetros Generales de Configuración como usuario que no es GM
    Given que el usuario no es un usuario GM
     When accede a la ventana de Parámetros Generales de Configuración
     Then verá el parámetro "Timbrar de Pruebas" como deshabilitado y no podrá modificarlo