Feature: Proceso de agregar nuevo reporte de KPIs al Dashboard de KPIs para el usuario Administrador
    Yo como Administrador del Dashboard de KPIs,
    Quiero que se implemente un proceso para agregar un nuevo reporte de KPIs al dashboard,
    Para que los usuarios puedan visualizar nuevos indicadores clave de desempeño relacionados con sus operaciones de transporte.

  Background:
    Given que existe un nuevo dashboard de KPIs 
      And el usuario administrador tiene acceso al dashboard de KPIs con funcionalidades de administración para los reportes de KPIs

  Scenario: Crear un nuevo reporte de KPIs
    Given que el usuario administrador se encuentra en el Dashboard de KPIs
     When el usuario haga clic en el botón "Agregar nuevo reporte" ubicado en la parte superior del listado de reportes de KPIs
     Then el sistema mostrará un formulario para crear un nuevo reporte de KPIs con los siguientes campos:
        '''
        - Nombre del reporte (campo obligatorio)
        - Link de Power BI del reporte (campo obligatorio, con validación para asegurar que el enlace sea correcto y esté activo)
        - Descripción del reporte (campo obligatorio)
        - Categoría del reporte (campo obligatorio, con opciones predefinidas: "Operacionales", "Análisis Estratégico", "Finanzas y Costos")
        - Ícono del reporte (obligatorio, permitirá archivos de imagen en formato PNG, SVG, o JPG, con un tamaño máximo de 2MB)
        - Botones para "Guardar" y "Cancelar" la creación del nuevo reporte
        '''
      And el usuario podrá observar el reporte registrado en el listado de reportes de KPIs, mostrando el nombre del reporte, la categoría a la que pertenece, una breve descripción y el ícono seleccionado para el reporte
      And el nuevo reporte de KPIs estará disponible para que los usuarios puedan seleccionarlo y abrirlo en una nueva pestaña del navegador al hacer clic en el reporte registrado

  Scenario: Editar un reporte de KPIs existente
    Given que el usuario administrador se encuentra en el Dashboard de KPIs
      And el usuario selecciona un reporte de KPIs existente del listado de reportes
     When el usuario haga clic en el botón "Editar" ubicado en la tarjeta del reporte seleccionado
     Then el sistema mostrará un formulario con los campos previamente llenados con la información del reporte seleccionado, permitiendo al usuario modificar cualquiera de los campos mencionados en el escenario anterior para crear un nuevo reporte de KPIs
      And el usuario podrá guardar los cambios realizados al reporte, y el sistema actualizará la información del reporte en el listado de reportes de KPIs para que los usuarios puedan visualizar la información actualizada del reporte al seleccionarlo y abrirlo en una nueva pestaña del navegador

