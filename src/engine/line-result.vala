public enum Calcumon.LineKind {
    ANSWER,
    EMPTY,
    ERROR
}

public class Calcumon.LineResult : Object {
    public int line { get; set; }
    public LineKind kind { get; set; }
    public string text { get; set; }

    public LineResult (int line, LineKind kind, string text) {
        Object (line: line, kind: kind, text: text);
    }
}
