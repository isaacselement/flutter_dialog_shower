# example

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Some Homeless Codes


    flutter create flutter_it_debug
    cd flutter_it_debug/
    flutter run --local-engine=ios_debug_sim_unopt --local-engine-src-path=/Workspaces/FlutterSDK/Compile_Sources/engine/src
    # the stop or CTRL-C the process
    # use Xcode open the flutter_it_debug/ios/Runner.xcworkspace project file
    # drag the /Users/xpeng/Workspaces/FlutterSDK/Compile_Sources/engine to Xcode and make a refrence
    # delete engin folder in Build Phase -> Copy Bundle Resources, for do not package it in to ipa
    # set a breakpoint on shell.cc:619 Shell::Setup method, the Run & Debug 


