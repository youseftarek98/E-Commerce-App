import 'dart:async';


import '../../../domain/model/models.dart';
import '../../base/base_view_model.dart';
import '../../resources/assets_manager.dart';
import '../../resources/strings_manager.dart';


class OnBoardingViewModel extends BaseViewModel
    with OnBoardingViewModelInputs, OnBoardingViewModelOutputs {
  /// stream controllers outputs
  final StreamController _streamController = StreamController<SliderViewObject>();

  late final List<SliderObject> _list;
  int _currentIndex = 0;

  ///OnBoarding View Model Inputs

  @override
  void dispose() {
    // TODO: implement dispose
    _streamController.close();
  }

  @override
  void start() {
    /// view model start your job
    _list = _getSliderData();
    _postDataToView() ;
  }

  @override
  int goNext() {
    int nextIndex = ++_currentIndex;

    if (nextIndex == _list.length) {
      nextIndex = 0;
    }
    return nextIndex;
  }

  @override
  int goPrevious() {
    int previousIndex = --_currentIndex;

    if (previousIndex == -1) {
      previousIndex = _list.length - 1;
    }
    return previousIndex;
  }

  @override
  void onPageChanged(int index) {
   _currentIndex = index ;
   _postDataToView() ;
  }

  @override
  Sink get inputSliderViewObject => _streamController.sink;

  /// onBoarding View model outputs
  @override
  Stream<SliderViewObject> get outputSliderViewObject =>
      _streamController.stream.map((sliderViewObject) => sliderViewObject);


  _postDataToView(){
   inputSliderViewObject.add(SliderViewObject(_list[_currentIndex] , _list.length , _currentIndex))  ;
  }


  /// onBoarding private function
  List<SliderObject> _getSliderData() => [
        SliderObject(AppStrings.onBoardingTitle1,
            AppStrings.onBoardingSubTitle1, ImageAssets.onBoardImageLogo1),
        SliderObject(AppStrings.onBoardingTitle2,
            AppStrings.onBoardingSubTitle2, ImageAssets.onBoardImageLogo2),
        SliderObject(AppStrings.onBoardingTitle3,
            AppStrings.onBoardingSubTitle3, ImageAssets.onBoardImageLogo3),
        SliderObject(AppStrings.onBoardingTitle4,
            AppStrings.onBoardingSubTitle4, ImageAssets.onBoardImageLogo4),
      ];
}

/// Inputs mean that 'that our view model will receive from view'
abstract class OnBoardingViewModelInputs {
  /// when user clicks on right arrow or swipe left
  int goNext();

  /// when user clicks on left arrow or swipe right
  int goPrevious();

  void onPageChanged(int index);

  /// stream controller input

  Sink get inputSliderViewObject;
}

abstract class OnBoardingViewModelOutputs {
  /// stream controller outputs
  Stream<SliderViewObject> get outputSliderViewObject;
}
