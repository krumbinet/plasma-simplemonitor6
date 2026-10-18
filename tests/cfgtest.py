import sys, os, shutil, tempfile, re
os.environ["QT_QPA_PLATFORM"]="offscreen"; os.environ["QT_QUICK_BACKEND"]="software"
here=os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, here)
from i18n import I18n
from PySide6.QtCore import QUrl, QTimer
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
pkg=sys.argv[1]; tmp=tempfile.mkdtemp()
shutil.copytree(pkg, tmp+"/pkg")
stubs=tmp+"/stubs"; shutil.copytree(here+"/stubs", stubs)
sp=stubs+"/org/kde/ksysguard/sensors/Sensor.qml"
_s=open(sp).read(); open(sp,"w").write(_s.replace("FAKE_CORES","8").replace("FAKE_OSNAME","Ubuntu").replace("FAKE_LOGO","ubuntu-logo"))
for f in os.listdir(tmp+"/pkg/contents/ui/config"):
    p=tmp+"/pkg/contents/ui/config/"+f; t=open(p).read()
    t=re.sub(r"Kirigami\.FormData\.\w+:[^\n;}]*", "", t); open(p,"w").write(t)
app=QGuiApplication([])
for f, props in [("ConfigGeneral.qml", "cfg_logo: 0; cfg_bgColor: 1; cfg_tempUnit: 0; cfg_cpuHighTemp: 70; cfg_cpuCritTemp: 85; cfg_showGpuTemp: true"),
                 ("ConfigSkins.qml", "cfg_skin: 2"), ("ConfigMisc.qml", "cfg_updateInterval: 0.5; cfg_indicatorHeight: 10")]:
    h=tmp+"/h_"+f
    out=os.path.join(os.getcwd(),"cfg_"+f.replace(".qml",".png"))
    open(h,"w").write('''import QtQuick
import QtQuick.Window
import "file://%s/pkg/contents/ui/config" as C
Window { visible: true; width: 520; height: 760
  C.%s { id: page; anchors.fill: parent; %s }
  Timer { interval: 800; running: true; onTriggered: page.grabToImage(function(r){ r.saveToFile("%s"); Qt.quit() }) }
}''' % (tmp, f[:-4], props, out))
    eng=QQmlApplicationEngine(); eng.addImportPath(stubs); eng.rootContext().setContextObject(I18n(app))
    errs=[]; eng.warnings.connect(lambda ws: errs.extend(w.toString() for w in ws))
    eng.load(QUrl.fromLocalFile(h))
    print(f, "OK" if eng.rootObjects() else "FAILED")
    for e in errs: print("  WARN", e)
    if eng.rootObjects(): app.exec()
    del eng
