import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:power_hour_flutter/api/authentication_service.dart';
import 'package:power_hour_flutter/pages/sign_up_screen.dart';
import 'package:power_hour_flutter/styles/theme.dart';
import 'package:power_hour_flutter/widgets/host_meeting_card.dart';
import '../app_content.dart';
import 'package:provider/provider.dart';

import 'main_screen.dart';
import '../config.dart' as config;

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  final List<Slide> slides = [];
  List<Widget> tabs = List.empty();

  @override
  void initState() {
    for (int i = 0; i < config.introContent.length; i++) {
      Slide slide = Slide(
        title: config.introContent[i]['title'],
        description: config.introContent[i]['desc'],
        marginTitle: EdgeInsets.only(
          top: 100.0,
          bottom: 50.0,
        ),
        maxLineTextDescription: 2,
        styleTitle: CustomTheme.screenTitle,
        backgroundColor: Colors.white,
        marginDescription: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
        styleDescription: CustomTheme.displayTextBoldBlackColor,
        foregroundImageFit: BoxFit.fitWidth,
      );

      slide.pathImage = config.introContent[i]['image'];
      slides.add(slide);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return IntroSlider(
      hideStatusBar: true,
      // shouldHideStatusBar: true,
      colorActiveDot: CustomTheme.primaryColor,
      showSkipBtn: true,
      // isShowSkipBtn: true,
      // isShowPrevBtn: true,
      showPrevBtn: true,
      slides: slides,
      backgroundColorAllSlides: Colors.white,
      // skipButtonStyle: CustomTheme.subTitleTextColored,
      // styleNameSkipBtn: CustomTheme.subTitleTextColored,
      // styleNameDoneBtn: CustomTheme.subTitleTextColored,
      listCustomTabs: this.renderListCustomTabs(authService),

      // nameNextBtn: AppContent.nextButton,
      // namePrevBtn: AppContent.preButton,
      // nameDoneBtn: AppContent.signup,
      onDonePress: () async {
        await Navigator.pushNamed(context, SignUpScreen.route);
      },
    );
  }

  List<Widget> renderListCustomTabs(authService) {
    List<Widget> tabs = new List.empty(growable: true);
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(Container(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          margin: EdgeInsets.only(bottom: 60.0, top: 60.0),
          child: ListView(
            children: <Widget>[
              Container(
                child: Text(
                  currentSlide.title!,
                  style: currentSlide.styleTitle,
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
              Container(
                child: Text(
                  currentSlide.description!,
                  style: currentSlide.styleDescription,
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.only(top: 20.0, bottom: 100.0),
              ),
              Container(
                child: GestureDetector(
                  child: Image.asset(
                    currentSlide.pathImage!,
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // if(!widget.isMandatoryLogin && i == 2)
              if (i == 2)
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
                  child: InkWell(
                    onTap: () {
                      print(authService.box);
                      Navigator.pushReplacementNamed(
                          context, SignUpScreen.route);
                    },
                    child: submitButton(300, "Register"),
                  ),
                )
            ],
          ),
        ),
      ));
    }
    return tabs;
  }
}
