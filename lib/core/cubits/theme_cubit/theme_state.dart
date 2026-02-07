// ignore_for_file: public_member_api_docs, sort_constructors_first


part of 'theme_cubit.dart';


class ThemeState extends Equatable {

  final Color primaryColor;


  final List<Color> gradientColor;


  final Color textColor;


  ThemeState({

    required this.primaryColor,

    required this.gradientColor,

    required this.textColor,

  });


  @override

  List<Object> get props => [primaryColor, textColor, gradientColor];


  ThemeState copyWith({

    Color? primaryColor,

    List<Color>? gradientColor,

    Color? textColor,

  }) {

    return ThemeState(
        primaryColor: primaryColor ?? this.primaryColor,
        textColor: textColor ?? this.textColor,
        gradientColor: gradientColor ?? this.gradientColor);

  }

}

