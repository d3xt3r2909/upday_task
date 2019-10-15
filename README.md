# Shutterstock demo app

##### Powered by [![Flutter](https://flutter.dev/assets/flutter-lockup-4cb0ee072ab312e59784d9fbf4fb7ad42688a7fdaea1270ccf6bbf4f34b7e03f.svg)](https://flutter.dev)

*Shutterstock demo app* is application which is fetching photos from external Shutterstock API and showing them in mobile app in format of infinitive scroll grid view. User also have possibility to use "Go to top" button in case that he want to see again pictures on top of the list. This application can run on Android and iOS devices. In near future, most probably will be available for web.

This app is used only for demo purpose and shows my knowledge of using flutter framework. It includes aspects of architectural ideas, testing and writing dart code.

## Technical aspects of project

#### Tech & resources
- Like already mentioned, this app is using [Flutter SDK](https://flutter.dev/) framework to make a build on different platforms.
- For fetching data (images), I had use this API [point](https://api-explorer.shutterstock.com/#/images/searchImages) from [Shutterstock](https://www.shutterstock.com/home)

#### Code style
- For correct writing of code I had used rules that are defined in analysis_options.yaml file, which are recommended from flutter and google it self https://dart.dev/guides/language/analysis-options.

#### Architectural

Because this is very small and I would say simple project I would say that best fitting pattern for this type of project is BLoC or provider. But, because I would love to show my knowledge, I have used two patterns on this project.

First one is Redux, which is responsible for global state management and handling API calls through middleware methods. Other one is called BLoC which I have used to separate business logic from UI file. Also, in this way we are able to make testing of app easier. And on the end, I had use reactive programming to "connect" business logic with UI pages.

Structure of project files are based on some kind of combination between MVVM and MVC (These are Microsoft patterns - do not forget that it is almost impossible to implement these on mobile programming). On other hand, I think that with this structure of directories and files, every developer will fit in short period of time.

#### 3th party libraries that are used in project

- flutter_redux - global state management
- flutter_i18n & intl - helper library for translation
- shimmer - animate loading for images - common animation of loading things on mobile
- rxdart - library for reactive programming mostly used for connection between bloc file and UI pages

#### Dev plugins

- mockito - used for mocking server response, to resolve issue with images on widget test
- transparent_image - gives a fake images during widget testing
- flutter_drive - needed for integration tests
- test - needed for integration tests

##### if ( Not implemented || Not tested || Can be better )

- I didn't test this app on tablets, iOS devices (mostly test on pixel 3 device)
- Implementation of handling errors that are coming from API point's are covered, and every error response that is retrieve from API point will show also some kind of warning to user. But my opinion that this part of project, can be better in way to show user more detailed and not so general messages
- Golden file tests are not covered because flutter has some problem with testing of images in widget test that are downloading from internet. Of course this can be implemented, but consume more time for something that is just comparing two images. Of course, these test can be crucial in production mode

## Links

- Check my [library](https://github.com/d3xt3r2909/linkedin_login) for OAuth LinkedIn also implemented in flutter framework. It has more than 90 score on https://pub.dev/packages/linkedin_login.
- My [LinkedIn](https://www.linkedin.com/in/nihaddelic/)
- For my CV or any other question you can contact me via nihad.delic91@gmail.com
