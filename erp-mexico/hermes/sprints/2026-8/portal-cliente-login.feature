# language: es

# NOTA DE IMPLEMENTACIÓN:
# El mecanismo de inicio de sesión reutiliza el login existente de Hermes (Azure MSAL).
# No se desarrolla un login nuevo. El alcance de esta historia es extender el acceso
# para que los clientes del ERP puedan autenticarse en el Portal Cliente con sus
# credenciales corporativas, igual que los usuarios internos de GM Transport.

@portal-cliente @autenticacion
Característica: Inicio de Sesión en el Portal Cliente Hermes
  Como cliente de GM Transport registrado en el ERP
  Quiero iniciar sesión en el Portal Hermes usando las mismas credenciales corporativas que uso en el ERP
  Para consultar y enviar solicitudes de cotización sin necesidad de una cuenta adicional

  Antecedentes:
    Dado que el cliente tiene una cuenta corporativa registrada en el ERP de GM Transport

  Escenario: Cliente del ERP inicia sesión exitosamente en el portal
    Dado que el cliente está en la pantalla de inicio de sesión del Portal Hermes
    Cuando ingresa su correo y contraseña corporativa del ERP y presiona "Iniciar sesión"
    Entonces el sistema valida sus credenciales usando el mismo mecanismo de autenticación de Hermes
    Y lo redirige a "Mis Cotizaciones"
    Y su nombre aparece en la barra superior del portal

  Escenario: Cliente ingresa credenciales incorrectas
    Dado que el cliente está en la pantalla de inicio de sesión
    Cuando ingresa un correo o contraseña incorrectos y presiona "Iniciar sesión"
    Entonces el sistema muestra un mensaje de error indicando credenciales inválidas
    Y el cliente permanece en la pantalla de inicio de sesión sin quedar bloqueado

  Escenario: Cliente cierra sesión
    Dado que el cliente está autenticado en el portal
    Cuando presiona "Cerrar sesión"
    Entonces el sistema termina su sesión y lo redirige a la pantalla de inicio de sesión
