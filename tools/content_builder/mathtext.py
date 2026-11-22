"""Convert the maths markup used on eLearn (HTML sub/sup, MathML, simple LaTeX)
into plain Unicode text that any phone can display. Returns (text, ok)."""
import html
import re
import xml.etree.ElementTree as ET

SUP = str.maketrans("0123456789+-=()nixyabct", "⁰¹²³⁴⁵⁶⁷⁸⁹⁺⁻⁼⁽⁾ⁿⁱˣʸᵃᵇᶜᵗ")
SUB = str.maketrans("0123456789+-=()aeoxhklmnpst", "₀₁₂₃₄₅₆₇₈₉₊₋₌₍₎ₐₑₒₓₕₖₗₘₙₚₛₜ")
SUP_OK = set("0123456789+-=()nixyabct")
SUB_OK = set("0123456789+-=()aeoxhklmnpst")


def sup(s):
    s = s.strip()
    if s in ("o", "∘", "\\circ", "0") and False:
        return "°"
    if s and all(c in SUP_OK for c in s):
        return s.translate(SUP)
    return "^(" + s + ")" if len(s) > 1 else "^" + s


def sub(s):
    s = s.strip()
    if s and all(c in SUB_OK for c in s.lower()) and s == s.lower():
        return s.translate(SUB)
    return "_" + s if len(s) == 1 else "_(" + s + ")"


def _mml(e):
    tag = e.tag.split("}")[-1]
    kids = list(e)
    t = lambda x: _mml(x)
    if tag in ("mi", "mn", "mo", "mtext", "ms"):
        return (e.text or "").replace("\u00a0", " ")
    if tag in ("math", "mrow", "mstyle", "mpadded", "semantics", "mphantom"):
        return "".join(t(k) for k in kids)
    if tag == "msup" and len(kids) == 2:
        return t(kids[0]) + sup(t(kids[1]))
    if tag == "msub" and len(kids) == 2:
        return t(kids[0]) + sub(t(kids[1]))
    if tag == "msubsup" and len(kids) == 3:
        return t(kids[0]) + sub(t(kids[1])) + sup(t(kids[2]))
    if tag == "mfrac" and len(kids) == 2:
        a, b = t(kids[0]), t(kids[1])
        wrap = lambda x: x if re.fullmatch(r"[\w.]+", x) else "(" + x + ")"
        return wrap(a) + "/" + wrap(b)
    if tag == "msqrt":
        inner = "".join(t(k) for k in kids)
        return "√" + (inner if re.fullmatch(r"[\w.]+", inner) else "(" + inner + ")")
    if tag == "mroot" and len(kids) == 2:
        return sup(t(kids[1])) + "√(" + t(kids[0]) + ")"
    if tag == "mfenced":
        return (e.get("open", "(") + ",".join(t(k) for k in kids) + e.get("close", ")"))
    if tag in ("mover", "munder", "munderover"):
        return "".join(t(k) for k in kids)
    if tag in ("mspace",):
        return " "
    if tag == "mtable":
        return "[" + "; ".join(t(k) for k in kids) + "]"
    if tag == "mtr":
        return " ".join(t(k) for k in kids)
    if tag == "mtd":
        return "".join(t(k) for k in kids)
    raise ValueError(tag)


LATEX = [
    (r"\\left|\\right|\\displaystyle|\\,|\\;|\\!|\\quad", ""),
    (r"\\times", "×"), (r"\\div", "÷"), (r"\\cdot", "·"), (r"\\pm", "±"), (r"\\mp", "∓"),
    (r"\\leq?", "≤"), (r"\\geq?", "≥"), (r"\\neq?", "≠"), (r"\\approx", "≈"),
    (r"\\pi", "π"), (r"\\theta", "θ"), (r"\\alpha", "α"), (r"\\beta", "β"), (r"\\gamma", "γ"),
    (r"\\delta", "δ"), (r"\\Delta", "Δ"), (r"\\lambda", "λ"), (r"\\mu", "μ"), (r"\\omega", "ω"),
    (r"\\Omega", "Ω"), (r"\\sigma", "σ"), (r"\\phi", "φ"), (r"\\infty", "∞"), (r"\\circ", "°"),
    (r"\\degree", "°"), (r"\\angle", "∠"), (r"\\triangle", "△"), (r"\\in", "∈"),
    (r"\\notin", "∉"), (r"\\subseteq", "⊆"), (r"\\subset", "⊂"), (r"\\cup", "∪"),
    (r"\\cap", "∩"), (r"\\emptyset|\\phi", "∅"), (r"\\rightarrow|\\to", "→"),
    (r"\\Rightarrow", "⇒"), (r"\\leftrightarrow", "↔"), (r"\\perp", "⊥"), (r"\\parallel", "∥"),
    (r"\\%", "%"), (r"\\\{", "{"), (r"\\\}", "}"), (r"\\ ", " "),
    (r"\\(sin|cos|tan|cot|sec|csc|log|ln)", r"\1"),
]


def _latex(s):
    for a, b in LATEX:
        s = re.sub(a + (r"(?![A-Za-z])" if a[-1].isalpha() else ""), b, s)
    s = re.sub(r"\\begin\{?[bpvB]?matrix\}?(.*?)\\end\{?[bpvB]?matrix\}?",
               lambda m: "[" + "; ".join(" ".join(c.strip() for c in row.split("&"))
                                         for row in re.split(r"\\\\", m.group(1)) if row.strip()) + "]",
               s, flags=re.S)
    for _ in range(4):
        s = re.sub(r"\\[dt]?frac\s*\{([^{}]*)\}\s*\{([^{}]*)\}",
                   lambda m: (m.group(1) if re.fullmatch(r"[\w.]+", m.group(1)) else "(" + m.group(1) + ")")
                   + "/" + (m.group(2) if re.fullmatch(r"[\w.]+", m.group(2)) else "(" + m.group(2) + ")"), s)
        s = re.sub(r"\\sqrt\s*\[([^\]]*)\]\s*\{([^{}]*)\}", lambda m: sup(m.group(1)) + "√(" + m.group(2) + ")", s)
        s = re.sub(r"\\sqrt\s*\{([^{}]*)\}", lambda m: "√" + (m.group(1) if re.fullmatch(r"[\w.]+", m.group(1)) else "(" + m.group(1) + ")"), s)
        s = re.sub(r"\\(?:text|mathrm|mathbf|textbf|operatorname|overline|bar|vec|hat)\s*\{([^{}]*)\}", r"\1", s)
        s = re.sub(r"\^\s*\{\s*o\s*\}|\^\s*o(?![a-z])|\^\s*\{\s*0\s*\}(?=\s*$)", "°", s)
        s = re.sub(r"\^\s*\{([^{}]*)\}", lambda m: sup(m.group(1)), s)
        s = re.sub(r"_\s*\{([^{}]*)\}", lambda m: sub(m.group(1)), s)
    s = re.sub(r"\^\s*([A-Za-z0-9])", lambda m: sup(m.group(1)), s)
    s = re.sub(r"_\s*([A-Za-z0-9])", lambda m: sub(m.group(1)), s)
    s = s.replace("{", "").replace("}", "")
    return s


def convert(s):
    """Returns (plain_text, ok). ok is False when markup could not be converted."""
    if s is None:
        return "", True
    ok = True
    s = html.unescape(s)

    def mml(m):
        nonlocal ok
        frag = re.sub(r"&#x?[0-9A-Fa-f]+;|&nbsp;", " ", m.group(0))
        frag = re.sub(r"<math[^>]*>", "<math>", frag)
        try:
            return _mml(ET.fromstring(frag))
        except Exception:  # noqa
            ok = False
            return m.group(0)

    s = re.sub(r"<math.*?</math>", mml, s, flags=re.S)
    # eLearn sometimes "closes" tags with another opening tag: x<sup>2<sup>
    s = re.sub(r"<sup>([^<]*)<sup>", r"<sup>\1</sup>", s, flags=re.I)
    s = re.sub(r"<sub>([^<]*)<sub>", r"<sub>\1</sub>", s, flags=re.I)
    s = re.sub(r"\\mid(?![A-Za-z])", "|", s)
    s = re.sub(r"\\(?:ldots|cdots|dots)(?![A-Za-z])", "…", s)
    s = re.sub(r"\\Leftrightarrow(?![A-Za-z])", "⇔", s)
    s = re.sub(r"<sub>(.*?)</sub>", lambda m: sub(re.sub(r"<[^>]+>", "", m.group(1))), s, flags=re.S | re.I)
    s = re.sub(r"<sup>(.*?)</sup>", lambda m: sup(re.sub(r"<[^>]+>", "", m.group(1))), s, flags=re.S | re.I)
    s = re.sub(r"<br\s*/?>", " ", s, flags=re.I)
    s = re.sub(r"</?(b|i|u|strong|em|span|p|div|font)[^>]*>", "", s, flags=re.I)
    s = re.sub(r"\\\[(.*?)\\\]|\\\((.*?)\\\)|\$\$(.*?)\$\$", lambda m: " " + _latex(next(g for g in m.groups() if g is not None)) + " ", s, flags=re.S)
    if "\\" in s and re.search(r"\\[a-zA-Z]", s):
        s = _latex(s)
    s = re.sub(r"\^\s*\{([^{}]*)\}", lambda m: sup(m.group(1)), s)
    s = re.sub(r"_\s*\{([^{}]*)\}", lambda m: sub(m.group(1)), s)
    s = re.sub(r"\s+", " ", s).strip()
    s = re.sub(r"\s+([,.;:?)])", r"\1", s)
    if re.search(r"</?[a-z][^>]*>|\\[a-zA-Z]+", s):
        ok = False
    return s, ok


if __name__ == "__main__":
    tests = [
        r"\[(a+b)(a^2-ab+b^2)\]", "K<sub>c</sub> = 1/ K<sub>P</sub>",
        "<math><msqrt><msqrt><mn>2</mn></msqrt></msqrt></math> = ?",
        "<math><msup><mn>2</mn><mfrac><mn>1</mn><mn>4</mn></mfrac></msup></math>",
        r"Answer of \[sin 95.29^ o\] is:", r"\[\frac{L.C.M \times H.C.F }{first expression} =?\]",
        r"Methane\[CH_{4}\], carbon dioxide \[CO_{2}\]", r"\[A^{t} \] =",
    ]
    for t in tests:
        print(convert(t))
