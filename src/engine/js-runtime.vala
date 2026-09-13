public class Calcumon.JsRuntime : Object {
    public JSC.Context context { get; private set; }

    public JsRuntime () throws EngineError {
        context = new JSC.Context ();

        string source;
        try {
            var bytes = resources_lookup_data (
                "/dev/calcumon/Calcumon/vendor/math.min.js",
                ResourceLookupFlags.NONE
            );
            source = utf8_from_bytes (bytes);
        } catch (Error e) {
            throw new EngineError.INIT ("Could not load math.js: %s".printf (e.message));
        }

        context.evaluate (source, -1);
        var exc = context.get_exception ();
        if (exc != null) {
            var msg = exc.get_message ();
            context.clear_exception ();
            throw new EngineError.INIT ("math.js failed to load: %s".printf (msg));
        }

        var math = context.get_value ("math");
        if (math.is_undefined () || math.is_null ()) {
            throw new EngineError.INIT ("math.js loaded but global math is missing");
        }
    }

    public JSC.Value evaluate (string code) throws EngineError {
        context.clear_exception ();
        var result = context.evaluate (code, -1);
        var exc = context.get_exception ();
        if (exc != null) {
            var msg = exc.get_message ();
            context.clear_exception ();
            throw new EngineError.EVAL (msg);
        }
        return result;
    }

    public JSC.Value call (string name, JSC.Value[] args) throws EngineError {
        context.clear_exception ();
        var fn = context.get_value (name);
        var result = fn.function_callv (args);
        var exc = context.get_exception ();
        if (exc != null) {
            var msg = exc.get_message ();
            context.clear_exception ();
            throw new EngineError.EVAL (msg);
        }
        return result;
    }

    private static string utf8_from_bytes (Bytes bytes) {
        unowned uint8[] data = bytes.get_data ();
        if (data.length == 0) {
            return "";
        }
        var copy = new uint8[data.length + 1];
        Memory.copy (copy, data, data.length);
        copy[data.length] = 0;
        return (string) copy;
    }
}
