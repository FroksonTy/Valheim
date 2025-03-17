@echo off
setlocal

:: НАСТРОЙТЕ ЭТИ ПУТИ ПОД СЕБЯ
set GIT_REPO="https://github.com/FroksonTy/Valheim.git"
set GIT_CLONE_PARENT="E:\git"
set SERVER_FOLDER="%USERPROFILE%\AppData\LocalLow\IronGate\Valheim\worlds_local"

:: Запрос подтверждения
:confirm
set "choice="
set /p choice="Are you sure you want to pull world from GitHub? [Y/N]: "
if /i "%choice%"=="Y" goto git_pull
if /i "%choice%"=="N" goto exit
goto confirm

:: Удаляем старую временную папку (если есть)
:git_pull
rmdir /s /q %GIT_CLONE_PARENT%\valheim-server 2>nul

:: Клонируем репозиторий во временную папку
git clone %GIT_REPO% %GIT_CLONE_PARENT%\valheim-server

:: Копируем файлы мира в SERVER_FOLDER (с заменой)
robocopy %GIT_CLONE_PARENT%\valheim-server %SERVER_FOLDER% 4BROTHERS* /MIR /NJH /NJS /NDL /NP

:: Удаляем временную папку
rmdir /s /q %GIT_CLONE_PARENT%\valheim-server 2>nul

echo World files successfully updated from Git!
echo - - - - - - - - - - - - - - - - - - - - - 
echo Backups creating started. Don't close this window while playing Valheim.

:: Настройки бэкапов
set BACKUP_DIR="%USERPROFILE%\Desktop\Valheim_Backups"
set INTERVAL=600

:backup_loop
echo [%time%] Deleting old backups...
rmdir /s /q %BACKUP_DIR% 2>nul

echo [%time%] Creating a new backup...
mkdir %BACKUP_DIR% >nul 2>&1
robocopy %SERVER_FOLDER% %BACKUP_DIR% * /E /NJH /NJS /NDL /NP

if %errorlevel% leq 7 (
    echo [%time%] Backup created succsessfully in %BACKUP_DIR%
) else (
    echo [%time%] Error while backup creating!
)

echo [%time%] Next backup in %INTERVAL% seconds.
timeout /t %INTERVAL% /nobreak >nul
goto backup_loop

::pause
:exit
