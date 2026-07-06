Feature: Generar acceso al Portal IA en el menú del ERP
    Yo como usuario de GM Transport ERP,
    Quiero una opción en el menú para acceder al portal de IA,
    Para poder acceder inmediatamente con mis datos y utilizar la IA para mis tareas.

  Background:
    Given que ya se encuentra desarrollado el portal de IA
      And se encuentra en el portal del ADMON para poder permitir el acceso desde el ERP

  Scenario: Entrar al sistema del ERP y observar la nueva opción para acceder al portal de IA
    Given que el usuario ingresa al ERP
      And el módulo de "Portal IA" está habilitado en el menú del ERP desde el ADMON
     When esté consultando los módulos del menú
     Then deberá ver la opción de acceder al portal de IA
      And el nombre del módulo será "Portal IA"
      And tendrá un ícono representativo de IA para facilitar su identificación

  Scenario: Acceder al portal de IA desde el ERP
    Given que el usuario se encuentra en el menú del ERP
     When haga clic en la opción "Portal IA"
     Then deberá ser redirigido al portal de IA conservando el token de autenticación del ERP para evitar tener que iniciar sesión nuevamente
      And el portal de IA se abrirá en una nueva pestaña del navegador