import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/views/custom_indicators/custom_first_page_exception_indicator.dart';

class CustomNoItemsFoundIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const CustomFirstPageExceptionIndicator(
    title: 'No se han encontrado noticias',
    message: 'Intente de nuevo cambiando los parámetros de búsqueda.',
  );
}
