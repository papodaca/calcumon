public class Calcumon.PageStore : Object {
    public File base_dir { get; construct; }
    public string? active_id { get; private set; }

    public PageStore () {
        var path = Path.build_filename (Environment.get_user_data_dir (), "calcumon");
        Object (base_dir: File.new_for_path (path));
    }

    public PageStore.with_base (File base_dir) {
        Object (base_dir: base_dir);
    }

    public File pages_dir () {
        return base_dir.get_child ("pages");
    }

    public File session_file () {
        return base_dir.get_child ("session.json");
    }

    public void ensure_dirs () throws Error {
        try {
            pages_dir ().make_directory_with_parents ();
        } catch (Error e) {
            if (!(e is IOError.EXISTS)) {
                throw e;
            }
        }
    }

    public Page[] load_all () {
        try {
            ensure_dirs ();
        } catch (Error e) {
            warning ("Could not create page directory: %s", e.message);
            return {};
        }

        active_id = null;
        var ids = new GenericArray<string> ();
        var session = session_file ();
        if (session.query_exists ()) {
            try {
                parse_session (session, ids);
            } catch (Error e) {
                warning ("Could not read session.json: %s", e.message);
            }
        }

        var pages = new GenericArray<Page> ();
        if (ids.length > 0) {
            for (int i = 0; i < ids.length; i++) {
                var page = load_page (ids[i]);
                if (page != null) {
                    page.order = i;
                    pages.add (page);
                }
            }
            return copy_pages (pages);
        }

        try {
            var enumerator = pages_dir ().enumerate_children (
                FileAttribute.STANDARD_NAME,
                FileQueryInfoFlags.NONE
            );
            FileInfo? info = null;
            while ((info = enumerator.next_file ()) != null) {
                var name = info.get_name ();
                if (!name.has_suffix (".json") || name.has_suffix (".tmp")) {
                    continue;
                }
                var id = name.substring (0, name.length - 5);
                var page = load_page (id);
                if (page != null) {
                    pages.add (page);
                }
            }
        } catch (Error e) {
            warning ("Could not list pages: %s", e.message);
        }

        pages.sort ((a, b) => a.order - b.order);
        return copy_pages (pages);
    }

    public void save (Page page) throws Error {
        ensure_dirs ();
        var obj = new Json.Object ();
        obj.set_string_member ("id", page.id);
        obj.set_string_member ("title", page.title);
        obj.set_string_member ("text", page.text);
        obj.set_int_member ("order", page.order);
        write_atomic (pages_dir ().get_child (page.id + ".json"), object_to_string (obj));
    }

    public void delete_id (string id) throws Error {
        var file = pages_dir ().get_child (id + ".json");
        try {
            file.delete ();
        } catch (Error e) {
            if (!(e is IOError.NOT_FOUND)) {
                throw e;
            }
        }
    }

    public void save_session (string? active, string[] ids) throws Error {
        ensure_dirs ();
        active_id = active;
        var obj = new Json.Object ();
        if (active != null) {
            obj.set_string_member ("active_id", active);
        } else {
            obj.set_null_member ("active_id");
        }
        var list = new Json.Array ();
        foreach (var id in ids) {
            list.add_string_element (id);
        }
        obj.set_array_member ("ids", list);
        write_atomic (session_file (), object_to_string (obj));
    }

    private Page? load_page (string id) {
        var file = pages_dir ().get_child (id + ".json");
        if (!file.query_exists ()) {
            return null;
        }
        try {
            uint8[] data;
            file.load_contents (null, out data, null);
            var parser = new Json.Parser ();
            parser.load_from_data ((string) data, data.length);
            var root = parser.get_root ();
            if (root == null || root.get_node_type () != Json.NodeType.OBJECT) {
                warning ("Skipping corrupt page %s: root is not an object", file.get_path ());
                return null;
            }
            var obj = root.get_object ();
            var page_id = obj.get_string_member_with_default ("id", id);
            var title = obj.get_string_member_with_default ("title", "Page");
            var text = obj.get_string_member_with_default ("text", "");
            int order = (int) obj.get_int_member_with_default ("order", 0);
            return new Page (page_id, title, text, order);
        } catch (Error e) {
            warning ("Skipping corrupt page %s: %s", file.get_path (), e.message);
            return null;
        }
    }

    private void parse_session (File file, GenericArray<string> ids) throws Error {
        uint8[] data;
        file.load_contents (null, out data, null);
        var parser = new Json.Parser ();
        parser.load_from_data ((string) data, data.length);
        var root = parser.get_root ();
        if (root == null || root.get_node_type () != Json.NodeType.OBJECT) {
            throw new IOError.INVALID_DATA ("session.json is not an object");
        }
        var obj = root.get_object ();
        if (obj.has_member ("active_id") && obj.get_null_member ("active_id") == false) {
            active_id = obj.get_string_member ("active_id");
        }
        if (!obj.has_member ("ids")) {
            return;
        }
        var array = obj.get_array_member ("ids");
        array.foreach_element ((arr, i, node) => {
            if (node.get_node_type () == Json.NodeType.VALUE) {
                ids.add (node.get_string ());
            }
        });
    }

    private static string object_to_string (Json.Object obj) {
        var node = new Json.Node (Json.NodeType.OBJECT);
        node.set_object (obj);
        var generator = new Json.Generator ();
        generator.pretty = true;
        generator.indent = 2;
        generator.set_root (node);
        size_t length;
        return generator.to_data (out length);
    }

    private static void write_atomic (File dest, string contents) throws Error {
        var tmp = File.new_for_path (dest.get_path () + ".tmp");
        tmp.replace_contents (contents.data, null, false, FileCreateFlags.NONE, null);
        tmp.move (dest, FileCopyFlags.OVERWRITE, null, null);
    }

    private static Page[] copy_pages (GenericArray<Page> pages) {
        var result = new Page[pages.length];
        for (int i = 0; i < pages.length; i++) {
            result[i] = pages[i];
        }
        return result;
    }
}
