@echo off
PUSHD "%~dp0"
setlocal

call .venv\Scripts\activate.bat

:start
echo Starting the Gradio web server...
start "Gradio Web Server" cmd /c python gradio_app.py %*

set SERVER_URL=http://127.0.0.1:8080
echo Checking if the server is available at %SERVER_URL%...
powershell -WindowStyle Hidden -File check_gradio.ps1 -ServerUrl "%SERVER_URL%"

echo Opening browser at %SERVER_URL%...
start "" "%SERVER_URL%"

:ending
endlocal
exit /b