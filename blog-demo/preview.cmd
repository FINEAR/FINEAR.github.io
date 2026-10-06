@echo off
cd /d "%~dp0"
echo ==========================================================
echo   Local preview  --  http://localhost:4321/
echo   Folder: %CD%
echo ==========================================================
echo   Write your post, save it, then just REFRESH the browser.
echo   Press Ctrl+C in this window to stop the preview.
echo ==========================================================
echo.
call npx hexo server -p 4321
echo.
pause
