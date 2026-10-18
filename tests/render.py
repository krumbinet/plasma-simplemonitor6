# Renders MonitorView.qml of the package with fake sensors into a PNG.
# usage: python3 -I render.py <package_ui_dir> <out.png> key=value ...
import sys, os, json, shutil, tempfile, faulthandler
faulthandler.dump_traceback_later(int(os.environ.get("FH", "0")) or 100000, exit=True)
os.environ.setdefault("QT_QPA_PLATFORM", "offscreen")
os.environ.setdefault("QT_QUICK_BACKEND", "software")
here = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, here)
from i18n import I18n
from PySide6.QtCore import QTimer, QUrl
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

ui_dir, out = sys.argv[1], sys.argv[2]
opts = dict(a.split("=", 1) for a in sys.argv[3:])
cfg = {"skin": 0, "bgColor": 0, "logo": 0, "logoScale": 1.0, "showGpuTemp": True, "showSwap": True,
       "showUptime": True, "tempUnit": 0, "cpuTempMode": 0, "cpuHighTemp": 70, "cpuCritTemp": 85,
       "coloredCpuLoad": True, "flatCpuLoad": True, "indicatorHeight": 10, "updateInterval": 1.0}
for k in list(cfg):
    if k in opts:
        v = opts[k]; cfg[k] = (v == "true") if isinstance(cfg[k], bool) else type(cfg[k])(v)
tmp = tempfile.mkdtemp()
stubs = os.path.join(tmp, "stubs"); shutil.copytree(os.path.join(here, "stubs"), stubs)
sp = os.path.join(stubs, "org/kde/ksysguard/sensors/Sensor.qml")
s = open(sp).read().replace("FAKE_CORES", opts.get("cores", "8")).replace("FAKE_OSNAME", opts.get("os", "Ubuntu")).replace("FAKE_LOGO", opts.get("oslogo", "ubuntu-logo"))
open(sp, "w").write(s)
harness = os.path.join(tmp, "harness.qml")
open(harness, "w").write('''
import QtQuick
import QtQuick.Window
import "file://%s"
Window {
    visible: true
    color: "%s"
    width: Math.max(50, view.implicitWidth + 20 + %d)
    height: Math.max(50, view.implicitHeight + 20 + %d)
    property var cfgObj: %s
    signal shotDone()
    Timer { interval: 1200; running: true; onTriggered: view.parent.grabToImage(function(r) { r.saveToFile("%s"); shotDone() }) }
    Item { anchors.fill: parent }
    MonitorView { id: view; x: 10; y: 10; width: parent.width - 20; height: parent.height - 20; cfg: cfgObj; logoEditMode: %s }
}
''' % (os.path.abspath(ui_dir), opts.get("bg", "#2a5a7a"), int(opts.get("extraw", 0)), int(opts.get("extrah", 0)), json.dumps(cfg), os.path.abspath(out), opts.get("edit", "false")))
app = QGuiApplication([])
eng = QQmlApplicationEngine()
eng.addImportPath(stubs)
eng.rootContext().setContextObject(I18n(app))
errors = []
eng.warnings.connect(lambda ws: errors.extend(w.toString() for w in ws))
eng.load(QUrl.fromLocalFile(harness))
if not eng.rootObjects():
    print("LOAD FAILED"); print("\n".join(errors)); sys.exit(1)
win = eng.rootObjects()[0]
def done():
    print("size", win.width(), win.height())
    for e in errors: print("WARN", e)
    app.quit()
win.shotDone.connect(done)
app.exec()
