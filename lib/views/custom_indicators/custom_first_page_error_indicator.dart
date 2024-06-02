import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/views/custom_indicators/custom_first_page_exception_indicator.dart';

class CustomFirstPageErrorIndicator extends StatelessWidget {
  const CustomFirstPageErrorIndicator({
    this.onTryAgain,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) => CustomFirstPageExceptionIndicator(
    title: 'Ha ocurrido un error',
    message: 'La aplicación ha encontrado un error.\n'
        'Por favor intente de nuevo.',
    onTryAgain: onTryAgain,
  );
}
