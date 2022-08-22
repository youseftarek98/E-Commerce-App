
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../domain/model/models.dart';
import '../../resources/color_manager.dart';
import '../../resources/constant_manager.dart';
import '../../resources/routes.dart';
import '../../resources/strings_manager.dart';
import '../../resources/values_manager.dart';
import '../viewmodel/onboarding_viewmodel.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final PageController _pageController = PageController();

  final OnBoardingViewModel _viewModel = OnBoardingViewModel();

  final AppPreferences _appPreferences = instance<AppPreferences>() ;

  _bind() {
    _appPreferences.setOnBoardingScreen() ;
    _viewModel.start();
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SliderViewObject>(
        stream: _viewModel.outputSliderViewObject,
        builder: (_, snapshot) {
          return _getContentWidget(snapshot.data);
        });
  }

  Widget _getContentWidget(SliderViewObject? sliderViewObject) {
    if (sliderViewObject == null) {
      return Container();
    } else {
      return Scaffold(
        backgroundColor: ColorManager.white,
        appBar: AppBar(
          backgroundColor: ColorManager.white,
          elevation: AppSize.s0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ColorManager.white,
            statusBarBrightness: Brightness.dark,
          ),
        ),
        body: PageView.builder(
            controller: _pageController,
            itemCount: sliderViewObject.numOfSlides,
            onPageChanged: (index) {
              _viewModel.onPageChanged(index);
            },
            itemBuilder: (_, index) {
              return OnBoardingPage(sliderViewObject.sliderObject);
            }),
        bottomSheet: Container(
          color: ColorManager.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, Routes.loginRoute);
                    },
                    child: Text(
                      AppStrings.skip,
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.titleMedium,
                    )),
              ),

              /// Widget Indicator and arrows
              _getBottomSheetWidget(sliderViewObject),
            ],
          ),
        ),
      );
    }
  }

  Widget _getBottomSheetWidget(SliderViewObject sliderViewObject) {
    return Container(
      color: ColorManager.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppPadding.p14),
            child: GestureDetector(
              child: const SizedBox(
                  width: AppSize.s20,
                  height: AppSize.s20,
                  child: Icon(Icons.chevron_left_outlined)),
              onTap: () {
                /// go to previous slide
                _pageController.animateToPage(_viewModel.goPrevious(),
                    duration: const Duration(
                        microseconds: AppConstants.sliderAnimationTime),
                    curve: Curves.bounceOut);
              },
            ),
          ),

          /// circle indicator
          Row(
            children: [
              for (int i = 0; i < sliderViewObject.numOfSlides; i++)
                Padding(
                  padding: const EdgeInsets.all(AppPadding.p8),
                  child: _getProperCircle(i, sliderViewObject.currentIndex),
                )
            ],
          ),

          /// right arrow
          Padding(
            padding: const EdgeInsets.all(AppPadding.p14),
            child: GestureDetector(
              child: const SizedBox(
                width: AppSize.s20,
                height: AppSize.s20,
                child: Icon(Icons.chevron_right_outlined),
              ),
              onTap: () {
                /// go to previous slide
                _pageController.animateToPage(_viewModel.goNext(),
                    duration: const Duration(
                        microseconds: AppConstants.sliderAnimationTime),
                    curve: Curves.bounceOut);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getProperCircle(int index, int currentIndex) {
    if (index == currentIndex) {
      return const Icon(Icons.check_circle);
    } else {
      return const Icon(Icons.add_circle);
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}

class OnBoardingPage extends StatelessWidget {
  final SliderObject _sliderObject;

  const OnBoardingPage(this._sliderObject, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: AppSize.s40,
        ),
        Padding(
          padding: const EdgeInsets.all(AppPadding.p8),
          child: Text(
            _sliderObject.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppPadding.p8),
          child: Text(
            _sliderObject.subTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(
          height: AppSize.s60,
        ),

        ///SvgPicture.asset(_sliderObject.image),
        Image.asset(_sliderObject.image),
      ],
    );
  }
}
