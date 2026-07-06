# Característica
@DobleCheck 
Feature: Sección Configuraciones en el menú lateral con submenú desplegable

  Como administrador de Doble Check
  Quiero que el menú lateral tenga una sección "Configuraciones" que al seleccionarla despliegue un submenú
  Para acceder de forma organizada a las opciones administrativas de la plataforma, incluyendo "Envío de Formularios"

  # Antecedentes
  Background:
    # Dado
    Given que el administrador tiene sesión iniciada en Doble Check
    # Y
    And que se encuentra en cualquier pantalla de la plataforma

  # ESCENARIO 1: LO QUE SÍ PASA (CASOS DE ÉXITO)

  @happy_path
  Scenario: El administrador ve la sección Configuraciones en el menú lateral
    # Dado
    Given que el administrador observa el menú lateral principal
    # Cuando
    When visualiza las opciones del menú lateral
    # Entonces
    Then el menú muestra la sección "Configuraciones" con un ícono de engrane
    # Y
    And la sección es visible junto a las demás opciones del menú como "Formularios" e "Inspecciones"

  @happy_path
  Scenario: Al seleccionar Configuraciones se despliega el submenú
    # Dado
    Given que el administrador visualiza el menú lateral con la sección "Configuraciones" contraída
    # Cuando
    When hace clic en "Configuraciones"
    # Entonces
    Then el sistema despliega el submenú debajo de la sección
    # Y
    And el submenú muestra la opción "Envío de Formularios"

  @happy_path
  Scenario: El administrador navega a Envío de Formularios desde el submenú
    # Dado
    Given que el submenú de "Configuraciones" está desplegado
    # Cuando
    When el administrador hace clic en "Envío de Formularios"
    # Entonces
    Then el sistema carga la pantalla de "Reglas de Envío"
    # Y
    And la opción "Envío de Formularios" queda resaltada como la sección activa en el menú

  @happy_path
  Scenario: El submenú se contrae al volver a seleccionar Configuraciones
    # Dado
    Given que el submenú de "Configuraciones" está desplegado
    # Cuando
    When el administrador hace clic nuevamente en "Configuraciones"
    # Entonces
    Then el submenú se contrae y las opciones internas dejan de ser visibles

