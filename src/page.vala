public class Calcumon.Page : Object {
    public string id { get; set; }
    public string title { get; set; }
    public string text { get; set; }
    public int order { get; set; }

    public Page (string id, string title, string text, int order) {
        Object (id: id, title: title, text: text, order: order);
    }

    public static Page empty (int order) {
        string title = order <= 0 ? "Page" : "Page %d".printf (order + 1);
        return new Page (Uuid.string_random (), title, "", order);
    }
}
