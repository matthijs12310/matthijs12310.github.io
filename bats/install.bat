@echo off
mkdir gameisfun
cd gameisfun
echo Bezig met downloaden dit kan een minuutje duren
curl.exe --output unzip.exe --url http://stahlworks.com/dev/unzip.exe
cls
curl.exe --output game.zip --url http://beppenow.tk/uploads/c40dafeb77639354591bd8ae2bae5ff4/Starbound_Bounty_Hunter.zip
cls
echo Nu wordt het bestand geunzipped.
echo Dit kan ook ff duren.
unzip.exe game.zip
cls
echo Klaar.
echo druk op enter om het spel te starten
pause >NUL
cd "Starbound Bounty Hunter"
cd win32
start "" "starbound.exe"