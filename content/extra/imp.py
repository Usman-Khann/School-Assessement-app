"""Import a multi-book batch file: sections start with '#<key>'. usage: python -I imp.py file.txt"""
import re, subprocess, sys, os
sys.stdout.reconfigure(encoding="utf-8")
D = os.path.dirname(os.path.abspath(__file__))
s = open(sys.argv[1], encoding="utf-8").read()
parts = re.split(r"^#(\S+)\s*$", s, flags=re.M)
for i in range(1, len(parts), 2):
    r = subprocess.run([sys.executable, "-I", f"{D}/eq.py", parts[i]], input=parts[i + 1].encode("utf-8"), capture_output=True)
    print(r.stdout.decode("utf-8")[-400:], r.stderr.decode("utf-8")[-400:])
