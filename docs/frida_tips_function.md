### Env: python is python3, pip is pip3

    pip install frida  # for `import frida` in *.py script files


### Part 1

`vim hello.c`

    #include <stdio.h>
    #include <unistd.h>
    
    void
    f (int n)
    {
    printf ("Number: %d\n", n);
    }
    
    int
    main (int argc,
    char * argv[])
    {
    int i = 0;
    
    printf ("f() is at %p\n", f);
    
    while (1)
    {
    f (i++);
    sleep (1);
    }
    }


    gcc -Wall hello.c -o hello && ./hello  # copy the ouput `function address`, do not ctrl-c



`vim hook.py`

    from __future__ import print_function
    import frida
    import sys
    
    session = frida.attach("hello")
    
    script = session.create_script("""
    Interceptor.attach(ptr("%s"), {
    onEnter: function(args) {
    send(args[0].toInt32());
    }
    });
    """ % int(sys.argv[1], 16))
    
    def on_message(message, data):
    print("message: %s, data: %s" % (message, data))
    
    script.on('message', on_message)
    script.load()
    sys.stdin.read()


    python hook.py [function address]  # pate the address you copied above



`vim modify.py`

    import frida
    import sys
    
    session = frida.attach("hello")
    script = session.create_script("""
    Interceptor.attach(ptr("%s"), {
    onEnter: function(args) {
    args[0] = ptr("1337");
    }
    });
    """ % int(sys.argv[1], 16))
    script.load()
    sys.stdin.read()


    python modify.py [function address]  # pate the address you copied above



`vim call.py`

    import frida
    import sys
    
    session = frida.attach("hello")
    script = session.create_script("""
    var f = new NativeFunction(ptr("%s"), 'void', ['int']);
    f(1911);
    f(1911);
    f(1911);
    """ % int(sys.argv[1], 16))
    script.load()


    python call.py [function address]  # pate the address you copied above





### Part 2

`vim hi.c`

    #include <stdio.h>
    #include <unistd.h>
    
    int
    f (const char * s)
    {
    printf ("String: %s\n", s);
    return 0;
    }
    
    int
    main (int argc,
    char * argv[])
    {
    const char * s = "Testing!";
    
    printf ("f() is at %p\n", f);
    printf ("s is at %p\n", s);
    
    while (1)
    {
    f (s);
    sleep (1);
    }
    }


    gcc -Wall hi.c -o hi && ./hi  # copy the function address 



`vim stringhook.py`

    from __future__ import print_function
    import frida
    import sys
    
    session = frida.attach("hi")
    script = session.create_script("""
    var st = Memory.allocUtf8String("TESTMEPLZ!");
    var f = new NativeFunction(ptr("%s"), 'int', ['pointer']);
    // In NativeFunction param 2 is the return value type,
    // and param 3 is an array of input types
    f(st);
    """ % int(sys.argv[1], 16))
    def on_message(message, data):
    print(message)
    script.on('message', on_message)
    script.load()


    python stringhook.py 0x106ef9ec0  # 0x106ef9ec0 is the function address you copied above




### Gadget on iOS simulator

    1. Go to https://github.com/frida/frida/releases/
    2. Download frida-gadget-15.1.17-ios-universal.dylib.xz and unzip it
    3. mkdir Frameworks/ && mv frida-gadget-15.1.17-ios-universal.dylib Frameworks/FridaGadget.dylib
    4. Drag Frameworks/ folder into a sample project with `Copy items if needed` & `Create folder references`
    5. `Build Phases` -> drag Frameworks/FridaGadget.dylib to `Link Binary With Libraries`
    6. `Copy Bundle Resours` -> ensure that Frameworks/ folder is in this section
    7. Just Build & Run and see if `Frida: Listening on 127.0.0.1 TCP port 27042` occurs and the process is on pending state
    8. Terminal -> `frida-ps -Rai` -> `frida-trace -R -f re.frida.Gadget -i "open*"` then the process resume



### Build frida gadget on Macos

    1. Xcode with command-line tools
    2. brew install node
    3. brew install python@3.8

    4. Open Keychain Access.app -> Create a Certificate... and named it to frida-cert, set it with Keychain to System, not Login.
    5. When created, then select Get Info on it, open the Trust item, and set Code Signing to Always Trust. 

    export MACOS_CERTID=frida-cert
    export IOS_CERTID=frida-cert

    git clone --recurse-submodules https://github.com/frida/frida.git
    cd frida
    make
    make gadget-ios

    otool -L build/frida-ios-arm64/usr/lib/frida/frida-gadget.dylib  # @executable_path/Frameworks/FridaGadget.dylib autually name is 'FridaGadget.dylib'

