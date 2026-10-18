from PySide6.QtCore import QObject, Slot
import re
def _fmt(s, args):
    return re.sub(r'%(\d)', lambda m: str(args[int(m.group(1))-1]) if int(m.group(1)) <= len(args) else m.group(0), s)
class I18n(QObject):
    @Slot(str, result=str)
    @Slot(str, 'QVariant', result=str)
    @Slot(str, 'QVariant', 'QVariant', result=str)
    @Slot(str, 'QVariant', 'QVariant', 'QVariant', result=str)
    def i18n(self, s, *a): return _fmt(s, a)
    @Slot(str, str, result=str)
    @Slot(str, str, 'QVariant', result=str)
    def i18nc(self, c, s, *a): return _fmt(s, a)
