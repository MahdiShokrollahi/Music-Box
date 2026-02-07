import 'dart:ui';


import 'package:bloc/bloc.dart';


import 'package:equatable/equatable.dart';


import 'package:flutter/material.dart';


import 'package:music_box/core/utils/app_colors.dart';


import 'package:palette_generator/palette_generator.dart';


part 'theme_state.dart';


class ThemeCubit extends Cubit<ThemeState> {

  ThemeCubit()

      : super(ThemeState(

            primaryColor: AppColors.primaryColor,

            gradientColor: [Colors.grey.shade900, Colors.black],

            textColor: AppColors.textColor));


  void setTheme(ImageProvider imageProvider) async {

    PaletteGenerator generator =

        await PaletteGenerator.fromImageProvider(imageProvider);


    //final colorList = generator.colors;


    final paletteColor = generator.dominantColor ??

        generator.darkMutedColor ??

        generator.darkVibrantColor ??

        generator.lightMutedColor ??

        generator.lightVibrantColor;


    if (paletteColor!.color.computeLuminance() > 0.10) {

      emit(state.copyWith(

          primaryColor: paletteColor.color.withOpacity(0.10),

          textColor: Colors.white54));

    } else {

      emit(state.copyWith(

          primaryColor: paletteColor.color,

          textColor: paletteColor.bodyTextColor));

    }

  }


  getColors({

    required ImageProvider imageProvider,

  }) async {

    PaletteGenerator paletteGenerator;


    paletteGenerator = await PaletteGenerator.fromImageProvider(imageProvider);


    final Color dominantColor =

        paletteGenerator.dominantColor?.color ?? Colors.black;


    final Color darkMutedColor =

        paletteGenerator.darkMutedColor?.color ?? Colors.black;


    final Color lightMutedColor =

        paletteGenerator.lightMutedColor?.color ?? dominantColor;


    if (dominantColor.computeLuminance() < darkMutedColor.computeLuminance()) {

      emit(state.copyWith(gradientColor: [

        darkMutedColor,

        dominantColor,

      ]));

    } else if (dominantColor == darkMutedColor) {

      emit(state.copyWith(gradientColor: [

        lightMutedColor,

        darkMutedColor,

      ]));

    } else {

      emit(state.copyWith(gradientColor: [dominantColor, darkMutedColor]));

    }

  }

}

