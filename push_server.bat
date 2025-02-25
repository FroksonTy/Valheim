@echo off
setlocal

:: НАСТРОЙТЕ ЭТИ ПУТИ ПОД СЕБЯ
set GIT_REPO="https://github.com/FroksonTy/Valheim.git"
set GIT_CLONE_PARENT="E:\git"
set SERVER_FOLDER="%USERPROFILE%\AppData\LocalLow\IronGate\Valheim\worlds"

:: Удаляем старую временную папку
rmdir /s /q %GIT_CLONE_PARENT%\valheim-server 2>nul

:: Клонируем репозиторий
git clone %GIT_REPO% %GIT_CLONE_PARENT%\valheim-server

:: Копируем файлы из SERVER_FOLDER во временный репозиторий
robocopy %SERVER_FOLDER% %GIT_CLONE_PARENT%\valheim-server 4BROTHERS* /MIR /NJH /NJS /NDL /NP

:: Пушим изменения
cd /d %GIT_CLONE_PARENT%\valheim-server
git add .
set /p commit_msg="Write changes description: "
git commit -m "%commit_msg%"
git push origin main

:: Удаляем временную папку
rmdir /s /q %GIT_CLONE_PARENT%\valheim-server 2>nul

echo World files successfully pushed to Git!
pause

