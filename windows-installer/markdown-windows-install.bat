cd %~dp0
msiexec /passive /i pandoc-1.13.2-windows.msi ALLUSERS=1
sublime-2-x64.exe
"C:\Program Files\Sublime Text 2\sublime_text.exe"
copy "Package Control.sublime-package"  "%APPDATA%\\Sublime Text 2\Installed Packages"
unzip SublimeOnSaveBuild.zip -d "%APPDATA%\\Sublime Text 2\Packages"
copy SublimeOnSaveBuild.sublime-settings "%APPDATA%\\Sublime Text 2\Packages\User"
copy markdown-pandoc.sublime-build "%APPDATA%\Sublime Text 2\Packages\User"
SumatraPDF-3.0-install.exe
unzip latex-markdown-templates.zip -d "%USERPROFILE%\Documents"
texmakerwin32_install.exe
