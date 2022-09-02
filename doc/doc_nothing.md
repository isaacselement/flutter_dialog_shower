
# Some Homeless Codes

### Mount writable NTFS USB-device on Macos

    cd ~/Desktop/ && mkdir Temp && ls -al /Volumes/ && diskutil list 
    sudo umount /Volumes/XXXXX
    sudo mount -t ntfs -o rw,auto,nobrowse /dev/diskXXX Temp/ && open Temp/

### Publish Steps

    flutter packages pub publish --dry-run
    flutter packages pub publish
    # Then open the google link and login to authorize.


### Python a simple https server

    from http.server import HTTPServer, SimpleHTTPRequestHandler
    import ssl, os
    os.system("openssl req -nodes -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -subj '/CN=mylocalhost'")
    port = 443
    httpd = HTTPServer(('0.0.0.0', port), SimpleHTTPRequestHandler)
    httpd.socket = ssl.wrap_socket(httpd.socket, keyfile='key.pem', certfile="cert.pem", server_side=True)
    print(f"Server running on https://0.0.0.0:{port}")
    httpd.serve_forever()



### Jail Broken iOS

    # 1
    iPhone 6S. iOS 13.3
    checkra1n [iPhone SE/6S~iPhone X]

    #####1 Install checkra1n application on your macosx, and open it.
    #####2 Connect your iPhone with USB to your mac, checkra1n will display device info.
    #####3 Click 'Start' button on checkra1n, read the instructions and click 'Next' to rec mode.
    #####4 Continue follow the instruction, click 'Start'. Hold 'Side' & 'Home' button on device. 
    #####5 Then release 'Side' button after 6 seconds but keep holding on 'Home' button.
    #####6 Finally the device enter DFU mode, and the less jobs will automatically done. 

    # 2
    brew install usbmuxd
    iproxy 2222 22
    ssh -p 2222 root@127.0.0.1
    # enter default password: alpine
    whoami  # check if i'm root or not :P
    ls -al /Developer/usr/bin/    # checkout the debugserver
    echo $PATH

    # 3
    On Mac:
    # debugserver on device's path /Developer/usr/bin/debugserver, once you connect device with xcode 
    ls -al /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/DeviceSupport/13.3/DeveloperDiskImage.dmg # also have a debugserver in it.
    scp -r -P2222 root@localhost:/Developer/usr/bin/debugserver $HOME/Desktop/
    cd $HOME/Desktop/ && file debugserver && lipo -thin arm64 debugserver -output debugserver_arm64

    ---------------------------- vim en.plist ----------------------------
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>com.apple.springboard.debugapplications</key>
        <true/>
        <key>run-unsigned-code</key>
        <true/>
        <key>get-task-allow</key>
        <true/>
        <key>task_for_pid-allow</key>
        <true/>
    </dict>
    </plist>
    ---------------------------- vim en.plist ----------------------------
    OR 
    ---------------------------- vim en.plist ----------------------------
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>task_for_pid-allow</key>
        <true/>
        <key>run-unsigned-code</key>
        <true/>
        <key>platform-application</key>
        <true/>
        <key>get-task-allow</key>
        <true/>
        <key>com.apple.system-task-ports</key>
        <true/>
        <key>com.apple.frontboard.launchapplications</key>
        <true/>
        <key>com.apple.frontboard.debugapplications</key>
        <true/>
        <key>com.apple.springboard.debugapplications</key>
        <true/>
        <key>com.apple.backboardd.launchapplications</key>
        <true/>
        <key>com.apple.backboardd.debugapplications</key>
        <true/>
        <key>com.apple.private.memorystatus</key>
        <true/>
        <key>com.apple.private.cs.debugger</key>
        <true/>
        <key>com.apple.private.logging.diagnostic</key>
        <true/>
    </dict>
    </plist>
    ---------------------------- vim en.plist ----------------------------

    codesign -s - --entitlements en.plist -f debugserver_arm64
    scp -P 2222 debugserver_arm64 root@localhost:/usr/bin/debugserver

    # 4
    On iOS:
    ls -al /usr/bin/debugserver
    ps -A  # ps aux
    debugserver -x backboard *:12345 /Applications/MobileSMS.app/MobileSMS  # error: rejecting incoming connection from ::ffff:127.0.0.1 (expecting ::1)，change * to 127.0.0.1
    # debugserver localhost:12345 -p 768 # pid, debugserver *:12345 -a Cydia
    debugserver -x backboard 127.0.0.1:12345 /Applications/MobileSMS.app/MobileSMS
    debugserver -x backboard 127.0.0.1:12345  /var/containers/Bundle/Application/9BC5831A-1B80-40A2-AB2D-E39E31E088D4/Runner.app/Runner --enable-dart-profiling --disable-service-auth-codes 
    
    On Macosx:    
    iproxy 54321 12345
    lldb
    (lldb)process connect connect://127.0.0.1:54321
    (lldb)c
    (lldb)breakpoint set -name Precompiled__MyAppState_19445837_staticVarAIncrement_5749
    (lldb)br set -name '-[AppDelegate application:didFinishLaunchingWithOptions] '
    (lldb)br set -r '-\[PHCollection *'
    (lldb)breakpoint list
    (lldb)breakpoint disable/delete
    (lldb)process interrupt
    (lldb)bt
    (lldb)register read
    (lldb)po $x0
    (lldb)p (char *)$x1
    (lldb)c


    cd /
    find -name *.app
    ls -al /var/containers/Bundle/Application/
    ls -al /var/mobile/Containers/Data/Application
    ls -al /var/mobile/Library/FrontBoard/applicationState.db
    cat /var/mobile/Library/FrontBoard/applicationState.db | grep -a "com.ss"

    scp -P 2222 root@127.0.0.1:/var/mobile/Library/FrontBoard/applicationState.db  ./
    sqlite3 applicationState.db 