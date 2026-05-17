// this was made by memozki, don't write to me to take this down for removing credits

const Libg = {
    init() {
        Libg.module = Process.findModuleByName("libg.so");

        if (!Libg.module) {
            console.log("libg.so not found");
            return;
        }

        Libg.size = Libg.module.size;
        Libg.begin = Libg.module.base;
        Libg.end = Libg.begin.add(Libg.size);

        console.log("libg loaded at: " + Libg.begin);
    },

    offset(value) {
        return Libg.begin.add(value);
    }
};

const FMZNkdv = {

    Hook() {
        Interceptor.attach(
            Module.findGlobalExportByName("getaddrinfo"),
            {
                onEnter(args) {
                    const port = args[1].readUtf8String();

                    if (port === "9339") {
                        console.log("Redirecting to localhost");

                        args[0].writeUtf8String("192.168.3.180");

                        PepperCrypto.Patch();
                    }
                }
            }
        );
    },

    Tid() {
        const ConnectTid = "BSF-V65";

        Memory.protect(
            Libg.offset(0x19EBAA),
            ConnectTid.length,
            "rwx"
        );

        Libg.offset(0x19EBAA)
            .writeUtf8String(ConnectTid);

        console.log("TID patched");
    },

    Offline() {
        Interceptor.attach(
            Libg.offset(0x897328),
            {
                onEnter(args) {
                    args[3] = ptr(3);
                    args[8] = ptr(1);
                }
            }
        );

        console.log("Offline patched");
    }
};

const PepperCrypto = {

    Patch() {

        Interceptor.replace(
            Libg.offset(0xB164D4),
            new NativeCallback(function () {
                return 1;
            }, 'int', [])
        );

        Interceptor.attach(
            Libg.offset(0xB16E28),
            {
                onEnter(args) {
                    this.messaging = args[0];

                    Memory.writeU32(
                        this.messaging.add(16),
                        5
                    );

                    args[1] = ptr(args[2]);
                },

                onLeave(retval) {
                    Memory.writeU32(
                        this.messaging.add(16),
                        5
                    );
                }
            }
        );

        Interceptor.attach(
            Libg.offset(0xB17634),
            {
                onEnter(args) {
                    this.context.r0 = ptr(0x2774);
                }
            }
        );

        console.log("PepperCrypto patched");
    }
};

setTimeout(function () {

    Libg.init();

    FMZNkdv.Offline();
    FMZNkdv.Tid();
    FMZNkdv.Hook();

}, 1000);
