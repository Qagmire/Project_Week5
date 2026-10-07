@echo off
setlocal
if /i "%~1"=="check" set "WALLET_CHECK=1"
cd /d "%~dp0"
if /i "%~1"=="ganache" goto ganache
if /i "%~1"=="wallet" goto wallet
where node.exe >nul 2>nul
if errorlevel 1 goto missing_node
where npm.cmd >nul 2>nul
if errorlevel 1 goto missing_node
if exist "node_modules\vite\bin\vite.js" if exist "node_modules\ganache\dist\node\cli.js" goto ready
echo Installing dependencies...
call npm.cmd install
if errorlevel 1 goto failed
:ready
echo Checking Ganache...
node -e "fetch('http://127.0.0.1:8545',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({jsonrpc:'2.0',id:1,method:'eth_chainId',params:[]})}).then(r=>r.json()).then(r=>process.exit(r.result==='0x539'?0:1)).catch(()=>process.exit(1))"
if not errorlevel 1 goto deploy
start "Token Wallet - Ganache" "%ComSpec%" /k ""%~f0" ganache"
node -e "let n=0;async function wait(){try{const r=await fetch('http://127.0.0.1:8545',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({jsonrpc:'2.0',id:1,method:'eth_chainId',params:[]})});if((await r.json()).result==='0x539')return process.exit(0);}catch{}if(++n>=30)return process.exit(1);setTimeout(wait,1000);}wait();"
if errorlevel 1 goto failed
:deploy
echo Deploying contracts and syncing addresses...
call npm.cmd run deploy
if errorlevel 1 goto failed
node -e "fetch('http://127.0.0.1:5173').then(async r=>process.exit(r.ok&&(await r.text()).includes('/src/main.jsx')?0:1)).catch(()=>process.exit(1))"
if not errorlevel 1 goto open_browser
start "Token Wallet - React" "%ComSpec%" /k ""%~f0" wallet"
node -e "let n=0;async function wait(){try{const r=await fetch('http://127.0.0.1:5173');if(r.ok&&(await r.text()).includes('/src/main.jsx'))return process.exit(0);}catch{}if(++n>=30)return process.exit(1);setTimeout(wait,1000);}wait();"
if errorlevel 1 goto failed
:open_browser
if defined WALLET_CHECK exit /b 0
start "" "http://127.0.0.1:5173"
echo Wallet ready: http://127.0.0.1:5173
echo MetaMask RPC: http://127.0.0.1:8545 - Chain ID: 1337
echo Keep Ganache and React windows open while using the wallet.
pause
exit /b 0
:ganache
call npm.cmd run ganache
exit /b %errorlevel%
:wallet
call npm.cmd run dev -- --port 5173 --strictPort
exit /b %errorlevel%
:missing_node
echo Node.js or npm was not found. Install Node.js and try again.
pause
exit /b 1
:failed
echo Startup failed. Read the errors above or check the Ganache/React windows.
echo Ports 8545 and 5173 must be available or used by this project.
pause
exit /b 1
