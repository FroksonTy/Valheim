@echo off
setlocal enabledelayedexpansion

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
set "BACKUP_ROOT=%USERPROFILE%\Desktop\Valheim_Backups"
set INTERVAL=600
set MAX_BACKUPS=5

:: Создаем корневую папку для бэкапов
mkdir "%BACKUP_ROOT%" >nul 2>&1

:backup_loop
:: Генерация временной метки
for /f "tokens=2 delims==" %%G in ('wmic os get localdatetime /value') do set "datetime=%%G"
set "timestamp=!datetime:~0,4!-!datetime:~4,2!-!datetime:~6,2!_!datetime:~8,2!-!datetime:~10,2!-!datetime:~12,2!"

:: Создаем папку для нового бэкапа
set "CURRENT_BACKUP=%BACKUP_ROOT%\!timestamp!"
mkdir "!CURRENT_BACKUP!"

:: Копируем файлы мира
robocopy "%SERVER_FOLDER%" "!CURRENT_BACKUP!" * /E /NJH /NJS /NDL /NP /R:3 /W:5

:: Удаляем старые бэкапы (оставляем последние MAX_BACKUPS)
set count=0
for /f "delims=" %%i in ('dir "%BACKUP_ROOT%" /ad /b /o-d 2^>nul') do (
    set /a count+=1
    if !count! gtr %MAX_BACKUPS% (
        echo [%time%] Deleting old backup: %%i
        rmdir /s /q "%BACKUP_ROOT%\%%i"
    )
)

echo [%time%] Backup created: !timestamp!
echo [%time%] Next backup in %INTERVAL% seconds.
timeout /t %INTERVAL% /nobreak >nul
goto backup_loop

:exit
