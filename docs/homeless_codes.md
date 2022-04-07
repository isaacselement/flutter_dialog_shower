
# Some Homeless Codes



### Create the debug flutter project

    flutter create flutter_it_debug
    cd flutter_it_debug/
    flutter run --local-engine=ios_debug_sim_unopt --local-engine-src-path=/Workspaces/FlutterSDK/Compile_Sources/engine/src
    # the stop or CTRL-C the process
    # use Xcode open the flutter_it_debug/ios/Runner.xcworkspace project file
    # drag the /Users/xpeng/Workspaces/FlutterSDK/Compile_Sources/engine to Xcode and make a refrence
    # delete engin folder in Build Phase -> Copy Bundle Resources, for do not package it in to ipa
    # set a breakpoint on shell.cc:619 Shell::Setup method, the Run & Debug



### Python a simple https server

    from http.server import HTTPServer, SimpleHTTPRequestHandler
    import ssl, os
    os.system("openssl req -nodes -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -subj '/CN=mylocalhost'")
    port = 443
    httpd = HTTPServer(('0.0.0.0', port), SimpleHTTPRequestHandler)
    httpd.socket = ssl.wrap_socket(httpd.socket, keyfile='key.pem', certfile="cert.pem", server_side=True)
    print(f"Server running on https://0.0.0.0:{port}")
    httpd.serve_forever()


