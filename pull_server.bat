@echo off
setlocal

:: НАСТРОЙТЕ ЭТИ ПУТИ ПОД СЕБЯ
set GIT_REPO="https://github.com/FroksonTy/Valheim.git"
set GIT_CLONE_PARENT="E:\git"
set SERVER_FOLDER="%USERPROFILE%\AppData\LocalLow\IronGate\Valheim\worlds"
 
:: Удаляем старую временную папку (если есть)
rmdir /s /q %GIT_CLONE_PARENT%\valheim-server 2>nul

:: Клонируем репозиторий во временную папку
git clone %GIT_REPO% %GIT_CLONE_PARENT%\valheim-server

:: Копируем файлы мира в SERVER_FOLDER (с заменой)
robocopy %GIT_CLONE_PARENT%\valheim-server %SERVER_FOLDER% 4BROTHERS* /MIR /NJH /NJS /NDL /NP

:: Удаляем временную папку
rmdir /s /q %GIT_CLONE_PARENT%\valheim-server 2>nul

echo World files successfully updated from Git!
pause