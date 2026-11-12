import 'package:next_bus/models/stop.dart';

/// Catálogo real de las 13 paradas del transporte interno (sección 4).
///
/// NOTA SOBRE COORDENADAS — no eliminar este comentario sin resolver el
/// problema de origen:
/// Los valores de latitud/longitud recibidos para estas 13 paradas llegaron
/// con formato corrupto, por ejemplo para GARE: lat "-2,15199E+15",
/// lon "-7,9953E+15". Usan coma como separador decimal Y notación
/// científica con exponentes (E+14 a E+16) que, al interpretarse, arrojan
/// magnitudes de ~10^14 a ~10^16 grados — completamente fuera de los rangos
/// válidos (latitud ±90, longitud ±180). No existe una única transformación
/// evidente que recupere el valor original sin adivinar (p. ej. truncar el
/// exponente da un valor plausible para latitud pero no para longitud), por
/// lo que, siguiendo la instrucción explícita de no inventar ni "corregir"
/// coordenadas sin justificación, se dejan en `null` hasta recibir datos
/// válidos desde el origen. Valores crudos recibidos, para referencia de
/// quien los valide:
///   GARE  lat -2,15199E+15  lon -7,9953E+15
///   FCV   lat -2,15154E+16  lon -7,9958E+15
///   BIB   lat -2,14868E+16  lon -7,9964E+15
///   FCSH  lat -2,14747E+15  lon -7,9968E+15
///   FIEC  lat -2,1445E+14   lon -7,9968E+15
///   EBUS  lat -2,14426E+16  lon -7,9966E+15
///   FAD   lat -2,14431E+16  lon -7,9962E+15
///   GYM   lat -2,14368E+16  lon -7,9968E+15
///   CELEX lat -2,14752E+15  lon -7,9968E+15
///   CEP   lat -2,14867E+16  lon -7,9965E+14
///   PSC   lat -2,15174E+16  lon -7,9958E+15
///   CTI   lat -2,14592E+16  lon -7,9949E+15
///   GARS  lat -2,15241E+16  lon -7,9953E+14
final List<Stop> mockStops = [
  const Stop(
    id: 'GARE',
    name: 'Garita Entrada',
    description: 'Acceso principal de ingreso al campus.',
  ),
  const Stop(
    id: 'FCV',
    name: 'Facultad Ciencias de la Vida',
    description: 'Facultad de Ciencias de la Vida.',
  ),
  const Stop(
    id: 'BIB',
    name: 'Biblioteca',
    description: 'Biblioteca central del campus.',
  ),
  const Stop(
    id: 'FCSH',
    name: 'Facultad de Ciencias Sociales y Humanística',
    description: 'Facultad de Ciencias Sociales y Humanística.',
  ),
  const Stop(
    id: 'FIEC',
    name: 'Facultad de Ingeniería en Computación y Electricidad',
    description: 'Facultad de Ingeniería en Computación y Electricidad.',
  ),
  const Stop(
    id: 'EBUS',
    name: 'Estación de buses',
    description: 'Estación central de buses del campus.',
  ),
  const Stop(
    id: 'FAD',
    name: 'Facultad de Arte, Diseño y Comunicación Audiovisual',
    description: 'Facultad de Arte, Diseño y Comunicación Audiovisual.',
  ),
  const Stop(
    id: 'GYM',
    name: 'Gimnasio Bienestar',
    description: 'Gimnasio de bienestar estudiantil.',
  ),
  const Stop(
    id: 'CELEX',
    name: 'Centro de Lenguas Extranjeras',
    description: 'Centro de Lenguas Extranjeras.',
  ),
  const Stop(
    id: 'CEP',
    name: 'Centro de Promoción y Empleo',
    description: 'Centro de Promoción y Empleo.',
  ),
  const Stop(
    id: 'PSC',
    name: 'Piscina',
    description: 'Piscina del campus.',
  ),
  const Stop(
    id: 'CTI',
    name: 'Centro de Tecnologías de Información',
    description: 'Centro de Tecnologías de Información.',
  ),
  const Stop(
    id: 'GARS',
    name: 'Garita Salida',
    description: 'Acceso de salida del campus.',
  ),
];
