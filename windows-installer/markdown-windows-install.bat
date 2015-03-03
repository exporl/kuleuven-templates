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
cygwin-setup-x86_64.exe -q --packages make,texlive,texlive-latex,texlive-latexextra,texlive-collection-fontutils,texlive-collection-fontsrecommended,texlive-collection-science,texlive-collection-genericrecommended,texlive-collection-bibtexextra,textlive-collection-fontutils,texlive-collection-binextra,texlive-collection-latexrecommended,texlive-collection-genericxextra,texlive-collection-humanities,texlive-collection-langenglish,texlive-collection-latexextra,texlive-collection-publishers,texlive-collection-plainextra,epstool,texlive-collection-binextra,texlive-collection-fontsextra,texlive-collection-mathextra
copy gpp.exe "C:\cygwin64\bin"

