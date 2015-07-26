powershell -command "$f='miktex-installer.exe'; if (!(Test-Path $f)) {(new-object System.Net.WebClient).DownloadFile('http://mirrors.ctan.org/systems/win32/miktex/setup/basic-miktex-2.9.5105-x64.exe', $f)}"
powershell -command "$f='texmaker-installer.exe'; if (!(Test-Path $f)) {(new-object System.Net.WebClient).DownloadFile('http://www.xm1math.net/texmaker/texmakerwin32_install.exe', $f)}"
powershell -command "$f='r-installer.exe'; if (!(Test-Path $f)) {(new-object System.Net.WebClient).DownloadFile('https://cran.r-project.org/bin/windows/base/R-3.2.1-win.exe', $f)}"
powershell -command "$f='rstudio-installer.exe'; if (!(Test-Path $f)) {(new-object System.Net.WebClient).DownloadFile('https://download1.rstudio.org/RStudio-0.99.467.exe', $f)}"
powershell -command "$f='python-installer.msi'; if (!(Test-Path $f)) {(new-object System.Net.WebClient).DownloadFile('https://www.python.org/ftp/python/2.7.10/python-2.7.10.amd64.msi', $f)}"
powershell -command "$f='sumatrapdf-installer.exe'; if (!(Test-Path $f)) {(new-object System.Net.WebClient).DownloadFile('https://kjkpub.s3.amazonaws.com/sumatrapdf/rel/SumatraPDF-3.0-install.exe', $f)}"
powershell -command "$f='git-installer.exe'; if (!(Test-Path $f)) {(new-object System.Net.WebClient).DownloadFile('https://github.com/msysgit/msysgit/releases/download/Git-1.9.5-preview20150319/Git-1.9.5-preview20150319.exe', $f)}"
powershell -command "$f='kuleuven-templates.zip'; if (!(Test-Path $f)) {(new-object System.Net.WebClient).DownloadFile('https://github.com/exporl/kuleuven-templates/archive/master.zip', $f)}"

miktex-installer.exe
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install pdfcrop
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install koma-script
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install acronym
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install bigfoot
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install xstring
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install wasysym
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install microtype
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install booktabs
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install lipsum
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install paralist
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install csquotes
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install etoolbox
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install siunits
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install caption
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install footmisc
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install todonotes
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install xcolor
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install pgf
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install beamer
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install ms
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install url
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install ulem
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install biblatex
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install logreq
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install mptopdf
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install wasy
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install symbol
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install extsizes
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install setspace
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install colortbl
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install type1cm
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install fp
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install pdfpages
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install eso-pic
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install hanging
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install filehook
"C:\Program Files\MiKTeX 2.9\miktex\bin\x64\mpm" --install sansmathaccent

texmaker-installer.exe
r-installer.exe
rstudio-installer.exe
msiexec /passive /i python-installer.msi
c:\Python27\Scripts\pip install pandocfilters
powershell -command "$p=(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path + ';c:\Python27\'; Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $p"
sumatrapdf-installer.exe
git-installer.exe
powershell -command "$s=new-object -com shell.application; $s.namespace([environment]::getfolderpath('mydocuments')).CopyHere($s.namespace((join-path $pwd 'kuleuven-templates.zip')).items())"
