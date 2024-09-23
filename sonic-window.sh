@echo off

:: 색깔 정의 (윈도우에서는 기본적인 echo를 사용)
set "RED="
set "GREEN="
set "YELLOW="
set "NC="

echo Sonic 데일리 퀘스트 스크립트를 시작합니다...

:: 현재 경로 확인 및 사용자로부터 경로 입력받기
set "current_dir=%cd%"
echo 현재 경로: %current_dir%
set /p work="작업 디렉토리를 입력하세요 (예: C:\Users\사용자명\sonic-all): "

:: 작업 디렉토리 존재 확인 및 삭제
if exist "%work%" (
    echo 작업 디렉토리 '%work%'가 이미 존재하므로 삭제합니다.
    rmdir /S /Q "%work%"
)

:: Git 설치 확인
where git >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo Git이 설치되지 않았습니다. Git을 설치하세요: https://git-scm.com
    pause
    exit /b
)

:: Git 클론
echo Git 저장소 클론 중...
git clone https://github.com/KangJKJK/sonic-all "%work%"

:: 작업 디렉토리 이동
cd /d "%work%"

:: npm 설치 확인
where npm >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo npm이 설치되지 않았습니다. npm을 설치합니다...
    powershell -Command "Start-Process cmd -ArgumentList '/c npm install -g npm' -Verb runAs"
) else (
    echo npm이 이미 설치되어 있습니다.
)

:: Node.js 모듈 설치
echo 필요한 Node.js 모듈을 설치합니다...
npm install
npm install @solana/web3.js chalk bs58

:: 개인키 입력받기
set /p privkeys="Solana의 개인키를 쉼표로 구분하여 입력하세요: "

:: 개인키를 파일에 저장
echo %privkeys% > "%work%\private.txt"

:: 파일 생성 확인
if exist "%work%\private.txt" (
    echo 개인키 파일이 성공적으로 생성되었습니다.
) else (
    echo 개인키 파일 생성에 실패했습니다.
)

:: sonic.js 스크립트 실행
echo sonic.js 스크립트를 실행합니다...
node --no-deprecation sonic.js

echo 모든 작업이 완료되었습니다.
pause
