
### Building Dart

    1. install python 3

    2.
    git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
    export PATH="$PATH:$PWD/depot_tools"

    3.
    mkdir dart-sdk
    cd dart-sdk
    # On Windows, this needs to be run in a shell with Administrator rights.
    # fetch command is on depot_tools we clone aboved
    fetch dart

    4.
    # From within the "dart-sdk" directory.
    cd sdk
    ./tools/build.py --no-goma --mode release --arch x64 create_sdk
    ls -al out/ReleaseX64/dart-sdk ; ls -al xcodebuild/ReleaseX64/dart-sdk
    file xcodebuild/ReleaseX64/dart-sdk/bin/dart

