

## Some Homeless Codes


    flutter create flutter_it_debug
    cd flutter_it_debug/
    flutter run --local-engine=ios_debug_sim_unopt --local-engine-src-path=/Workspaces/FlutterSDK/Compile_Sources/engine/src
    # the stop or CTRL-C the process
    # use Xcode open the flutter_it_debug/ios/Runner.xcworkspace project file
    # drag the /Users/xpeng/Workspaces/FlutterSDK/Compile_Sources/engine to Xcode and make a refrence
    # delete engin folder in Build Phase -> Copy Bundle Resources, for do not package it in to ipa
    # set a breakpoint on shell.cc:619 Shell::Setup method, the Run & Debug



