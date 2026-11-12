const _ordinalLabels = ['Próximo bus', 'Segundo bus', 'Tercer bus'];

/// Etiqueta de orden de llegada ("Próximo bus", "Segundo bus"...) usada en
/// las tarjetas de ETA de Inicio y de Detalle de parada.
String ordinalBusLabel(int index) => index < _ordinalLabels.length
    ? _ordinalLabels[index]
    : '${index + 1}.º bus';
