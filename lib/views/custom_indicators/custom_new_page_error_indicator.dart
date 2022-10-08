import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/views/custom_indicators/custom_footer_tile.dart';

class CustomNewPageErrorIndicator extends StatelessWidget {
  const CustomNewPageErrorIndicator({
    Key? key,
    this.onTap,
  }) : super(key: key);
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: CustomFooterTile(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Un error ha ocurrido. Haga tap para intentar de nuevo.',
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 4,
          ),
          Icon(
            Icons.refresh,
            size: 16,
          ),
        ],
      ),
    ),
  );
}
