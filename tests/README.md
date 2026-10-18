QML tests without Plasma
========================

Renders the widget and the settings pages with Qt 6 (PySide6) and fake
sensor values, so layouts can be checked on any machine – also in CI.
The KDE modules (`org.kde.ksysguard.sensors`, `org.kde.kirigami`,
`org.kde.kcmutils`) are replaced by small stubs in `stubs/`.

```sh
pip install PySide6
python3 tests/render.py package/contents/ui out.png skin=0           # Default skin
python3 tests/render.py package/contents/ui out.png skin=1 cores=16 tempUnit=1 cpuTempMode=1
python3 tests/render.py package/contents/ui out.png skin=2 os=Fedora oslogo=fedora-logo-icon
python3 tests/cfgtest.py package      # loads the three settings pages
```

Options: every key of `package/contents/config/main.xml` (`skin=`, `bgColor=`,
`tempUnit=`, ...), plus `cores=`, `os=`, `oslogo=`, `bg=` (window colour) and
`edit=true` (logo resize handle). QML warnings are printed as `WARN`.

This does not replace a test in a real Plasma session (`./test.sh`).
