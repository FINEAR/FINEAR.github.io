@echo off
cd /d "%~dp0"
echo ==========================================================
echo   Publish blog  --  cxh.net.cn
echo   Folder: %CD%
echo ==========================================================
echo   Steps: hexo clean  -^>  hexo generate  -^>  hexo deploy
echo ==========================================================
echo.
echo [1/3] npx hexo clean
call npx hexo clean
if errorlevel 1 goto fail
echo.
echo [2/3] npx hexo generate
call npx hexo generate
if errorlevel 1 goto fail
echo.
echo [3/3] npx hexo deploy
call npx hexo deploy
if errorlevel 1 goto fail
echo.
echo ==========================================================
echo   DONE.
echo   1) Wait 1-2 minutes for Vercel to redeploy.
echo   2) Open https://cxh.net.cn/ and press Ctrl+F5.
echo ==========================================================
goto end
:fail
echo.
echo **********************************************************
echo   FAILED. Read the messages above.
echo   Common causes:
echo     - Node.js not installed           (node -v should work)
echo     - Pandoc not installed            (pandoc -v should work)
echo     - SSH key not authorized on GitHub (ssh -T git@github.com)
echo     - Not running inside blog-demo
echo   Details: see README-blog-guide.md  section 9
echo **********************************************************
:end
echo.
pause
