
Feature: Integración EDI 540
Como usuario de EDI
Quiero realizar la integración del EDI 540
Para automatizar el envío de archivos EDI al concluir un viaje entre patios
Nombre del EDI: Stellantis 540 
 
Scenario: El EDI 540 se ejecuta únicamente cuando remitente y destinatario son Patio
Given que el remitente tiene el campo "Es Patio" activo
And que el destinatario tiene el campo "Es Patio" activo
And el viaje se marca como "Terminado"
When se ejecuta el proceso de envío EDI al concluir el viaje
Then se genera y envía el archivo EDI 540
 
Scenario: No generar EDI 540 cuando remitente y destinatario son Dealer
Given que el remitente tiene el campo "Es Patio" inactivo
And que el destinatario tiene el campo "Es Patio" inactivo
And el viaje se marca como "Terminado"
When se ejecuta el proceso de envío EDI al concluir el viaje
Then no se genera ni envía el archivo EDI 540

Scenario: No generar EDI 540 cuando el remitente es Dealer y el destinatario es Patio
Given que el remitente tiene el campo "Es Patio" inactivo
And que el destinatario tiene el campo "Es Patio" activo
And el viaje se marca como "Terminado"
When se ejecuta el proceso de envío EDI al concluir el viaje
Then no se genera ni envía el archivo EDI 540
 
Scenario: No generar EDI 540 cuando el remitente es Patio y el destinatario es Dealer
Given que el remitente tiene el campo "Es Patio" activo
And que el destinatario tiene el campo "Es Patio" inactivo
And el viaje se marca como "Terminado"
When se ejecuta el proceso de envío EDI al concluir el viaje
Then no se genera ni envía el archivo EDI 540