@ECHO OFF
CALL :Trim %1
CALL :Trim %2
CALL :Trim %3
CALL :Trim %4
CALL :Trim %5
CALL :Trim %6
CALL :Trim %7
CALL :Trim %8
CALL :Trim %9

if not "%1"=="" (
  set server=%1 
) else ( 
  set server=mpos
)
if not "%2"=="" (
  set stratum=%2
) else ( 
  set stratum=stratum+tcp://bitzeny.mypool.tokyo:9334
)
if not "%3"=="" (
  set worker=%3 
) else ( 
  set worker=kazu0617.example
)
if not "%4"=="" (
  set workerpass=%4 
) else ( 
  set workerpass=hoge
)
if not "%5"=="" (
  set cthread=%5 
) else ( 
  set cthread=false
)
if not "%6"=="" (
  set cthreadnumber=%6 
) else ( 
  set cthreadnumber=0
)
if not "%7"=="" (
  set affinity=%7
) else (
  set affinity=55
)
if not "%8"=="" (set address=%8)

if "%server%"=="nomp-test" ( set server=nomp )
if "%server%"=="mpos-test" ( set server=mpos )

if "%8"=="1" (goto rapidstart)
if "%8"=="2" (goto rapidstart)
if "%9"=="1" (goto rapidstart)
if "%9"=="2" (goto rapidstart)

set lapool="jp.lapool.me"
echo BitZeny Starter v1.3.5 for minerd260 made by.kazu0617
echo このツールは、BitZeny Discordや、IRQチューニングによるハッシュレートの向上を最大限生かせ、かつ設定をなるべく楽に、
echo 対話式にできるように制作した調整ツールとなります。
echo 当ツールではLapoolの使用に関して制限をかけております。他のプールサイトを使用していただくようお願いします。
echo このメッセージは10秒後に消えます。すぐに飛ばしたければ何かキーを入力してください。
timeout 10 >nul
:repeat
cls
TITLE "BitZeny-Starter ( CustomThread:%cthread% Num:%cthreadnumber% | pool:%server% / %stratum% / %worker% / %workerpass% | Affinity:%affinity% )"
echo set custom thread= %cthread%
if %cthread%==true (echo thread number= %cthreadnumber%)
echo servertype= %server%
echo serveraddress= %stratum%
echo worker= %worker%
echo workerpass= %workerpass%
echo affinity= %affinity%
if not "%server%"=="" (echo address= %address%)
echo この設定は次のような値をショートカットで設定することで直接設定可能です。
if not "%address%"=="" (
  echo %0 %server% %stratum% %worker% %workerpass% %cthread% %cthreadnumber% %affinity% %address% %9
) else (
  echo %0 %server% %stratum% %worker% %workerpass% %cthread% %cthreadnumber% %affinity% %address%
)
if "%8"=="" (
  echo なお、affinityの後ろにスペースを空けて1を入力するとラピッドスタートがかかります。
  echo この際、このダイアログを飛ばして実行が可能になります。
) else if "%9"=="" (
  echo なお、addressの後ろにスペースを空けて1を入力するとラピッドスタートがかかります。
  echo この際、このダイアログを飛ばして実行が可能になります。
)

echo この設定でOKですか？
echo [0] OK
echo [1] OK(QuietMode)
echo [2] NG (修正する)
set /p input=
if defined input set input=%input:"=%
if /i "%input%" == "0" (goto starter)
if /i "%input%" == "1" (goto starter)
if /i "%input%" == "2" (goto change)
goto repeat

:starter
set dt=%date%
set tm=%time%
if "%tm:~0,5%"==" 0:00" set dt=%date%
set FName=minerd-%dt:~-10,4%-%dt:~-5,2%-%dt:~-2,2%_%tm:~-11,2%.%tm:~-8,2%

if /i "%input%" == "1" (
  TITLE "BitZeny-Starter ( QuietMode | CustomThread:%cthread% Num:%cthreadnumber% | pool:%server% / %stratum% / %worker% / %workerpass% | Affinity:%affinity% )"
)

if defined server (
  goto %server% 
) else ( 
  goto error 
)

:mpos-old
set quiet=
if /i "%input%" == "1" ( set quiet=-q) 
if %cthread%==true (
  call cmd /c start "BitZeny-Miner ( %quiet% CustomThread:%cthread% | pool:%server% / %stratum% / %worker% / %workerpass% | Affinity:%affinity% )" /high /affinity %affinity% minerd260.exe %quiet% -a yescrypt -t %cthreadnumber% -o %stratum% -u %worker% -p %workerpass%
) else (
  call cmd /c start "BitZeny-Miner ( %quiet% CustomThread:%cthread% Num:%cthreadnumber% | pool:%server% / %stratum% / %worker% / %workerpass% | Affinity:%affinity% )" /high /affinity %affinity% minerd260.exe %quiet% -a yescrypt -o %stratum% -u %worker% -p %workerpass%
)
echo 実行されました。数秒後に設定画面に戻ります
set input=3
timeout 5 > nul
goto repeat
:nomp-old
set quiet=
if /i "%input%" == "1" ( set quiet=-q )
if %cthread%==true (
  call cmd /c start "BitZeny-Miner ( %quiet% CustomThread:%cthread% | pool:%server% / %stratum% / %address% | Affinity:%affinity% )" /high /affinity %affinity% minerd260.exe %quiet% -t %cthreadnumber% -a yescrypt -o %stratum% -u %address%
) else (
  call cmd /c start "BitZeny-Miner ( %quiet% CustomThread:%cthread% Num:%cthreadnumber% | pool:%server% / %stratum% / %address% | Affinity:%affinity% )" /high /affinity %affinity% minerd260.exe %quiet% -a yescrypt -o %stratum% -u %address%
)
echo 実行されました。数秒後に設定画面に戻ります
set input=3
timeout 5 > nul
goto repeat

:mpos
set quiet=
if /i "%input%" == "1" ( set quiet=-q) 
if %cthread%==true (
  call cmd /c start "BitZeny-Miner ( %quiet% CustomThread:%cthread% | pool:%server% / %stratum% / %worker% / %workerpass% | Affinity:%affinity% )" /high minerd260.exe %quiet% -a yescrypt -t %cthreadnumber% -o %stratum% -u %worker% -p %workerpass% --cpu-affinity %affinity%
) else (
  call cmd /c start "BitZeny-Miner ( %quiet% CustomThread:%cthread% Num:%cthreadnumber% | pool:%server% / %stratum% / %worker% / %workerpass% | Affinity:%affinity% )" /high minerd260.exe %quiet% -a yescrypt -o %stratum% -u %worker% -p %workerpass% --cpu-affinity %affinity%
)
echo 実行されました。数秒後に設定画面に戻ります
set input=3
timeout 5 > nul
goto repeat
:nomp
set quiet=
if /i "%input%" == "1" ( set quiet=-q )
if %cthread%==true (
  call cmd /c start "BitZeny-Miner ( %quiet% CustomThread:%cthread% | pool:%server% / %stratum% / %address% | Affinity:%affinity% )" /high /affinity %affinity% minerd260.exe %quiet% -t %cthreadnumber% -a yescrypt -o %stratum% -u %address% --cpu-affinity %affinity%
) else (
  call cmd /c start "BitZeny-Miner ( %quiet% CustomThread:%cthread% Num:%cthreadnumber% | pool:%server% / %stratum% / %address% | Affinity:%affinity% )" /high minerd260.exe %quiet% -a yescrypt -o %stratum% -u %address% --cpu-affinity %affinity%
)
echo 実行されました。数秒後に設定画面に戻ります
set input=3
timeout 5 > nul
goto repeat

:change
cls
echo どの項目を編集しますか？
echo [0] スレッド数
echo [1] ワークサーバータイプ/ワークサーバ
echo [2] ワーカー名
echo [3] ワーカーPass
echo [4] アフィニティ（上級者向け！）
echo [5] マイナーアドレス (一部環境のみ)
echo [9] 編集を終了する
echo ---簡易表示---
echo set custom thread= %cthread%
if "%cthread%"=="true" (echo thread number= %cthreadnumber%)
echo server= %server%
echo serveraddress= %stratum%
echo worker= %worker%
echo workerpass= %workerpass%
echo affinity= %affinity%
if not "%server%"=="" (echo address= %address%)

set /p input=
if defined input set input=%input:"=%
if /i "%input%" == "0" (goto change-t)
if /i "%input%" == "1" (goto change-ws)
if /i "%input%" == "2" (goto change-wn)
if /i "%input%" == "3" (goto change-wp)
if /i "%input%" == "4" (goto change-af)
if /i "%input%" == "5" (goto change-ad)
if /i "%input%" == "9" (goto repeat)
goto change

:change-t
cls
echo スレッド数は指定しますか？
echo [0] する
echo [1] しない
set /p input=
if defined input set input=%input:"=%
if /i "%input%" == "0" (
  set cthread=true
  goto change-ct
)
if /i "%input%" == "1" (
  set cthread=false
  set cthreadnumber=0
  goto change
)
:change-ct
echo スレッド数を入力してください(チェックはしないので注意！)... 
set /P cthreadnumber=
goto change

:change-ws
cls
echo サーバー名を選択してください（2018/02/03現在）
echo （ここのプリセットに用意されているのは高難易度のもののみです。）
echo （中難易度、低難易度のものはその他を設定の上URLをコピーしてきて下さい）
echo ---MPOS(Mining Fee:0%%のサーバーのみ記載)---
echo [0] 俺のプール＠東京鯖
echo [1] Happy Miner
echo [2] ココアプール
echo [3] ぷりぷりぷーる（bitzeny）
echo [4] Knyacki pool
echo [5] powerpool for BitZeny
echo [6] Bunnymining
echo [7] BitZenyPool　寛 永 通 宝
echo [49] その他(MPOS)
echo ---ここからNOMP(Mining Fee逆順)---
echo [50] WPOOL(Fee:0.1%%)
echo [51] kruptos:BitZeny Pool(Fee:0.1%%)
echo [52] Daddy-pool(Fee:1%%)
echo [53] Bluepool(Fee:1%%)
echo [99] その他(NOMP)

set /p input=
if defined input set input=%input:"=%
if /i "%input%" == "0" (
  set server=mpos
  set stratum=stratum+tcp://bitzeny.mypool.tokyo:9334
  goto change
)

if /i "%input%" == "1" (
  set server=mpos
  set stratum=stratum+tcp://miner.happy-miner.cc:3333
  goto change
)
if /i "%input%" == "2" (
  set server=mpos
  set stratum=stratum+tcp://s.cocoapool.net:14943
  goto change
)
if /i "%input%" == "3" (
  set server=mpos
  set stratum=stratum+tcp://puripuripool.tk:18001
  goto change
)
if /i "%input%" == "4" (
  set server=mpos
  set stratum=stratum+tcp://pool.knyacki.xyz:8888
  goto change
)
if /i "%input%" == "5" (
  set server=mpos
  set stratum=stratum+tcp://m.powerpool.jp:33333
  goto change
)
if /i "%input%" == "6" (
  set server=mpos
  set stratum=stratum+tcp://bunnymining.work:19334
  goto change
)
if /i "%input%" == "7" (
  set server=mpos
  set stratum=stratum+tcp://bitzenypool.work:19668
  goto change
)

if /i "%input%" == "50" (
  set server=nomp
  set stratum=stratum+tcp://wpool.work:15022
  goto change
)
if /i "%input%" == "51" (
  set server=nomp
  set stratum=stratum+tcp://mining.bit-univ.jp:43333
  goto change
)
if /i "%input%" == "51" (
  set server=nomp
  set stratum=stratum+tcp://mining.bit-univ.jp:43333
  goto change
)
if /i "%input%" == "52" (
  set server=nomp
  set stratum=stratum+tcp://daddy-pool.work:15022
  goto change
)
if /i "%input%" == "53" (
  set server=nomp
  set stratum=stratum+tcp://bitzeny.bluepool.info:9999
  goto change
)

if /i "%input%" == "99" (
  set server=nomp
  goto change-sa
)
if /i "%input%" == "49" (
  set server=mpos
  goto change-sa
)

cls
goto change-ws

:change-sa
cls
echo サーバーアドレスを入力してください(Lapoolを指定することはできません。よろしくお願いします。)... 
set /P stratum=
echo %stratum% | find %lapool% >nul
if not errorlevel 1 (
  echo Lapoolを使用することはできません。
  echo 値を確認の上で、再入力お願いします…
  echo 10秒後に再度入力画面に移行します
  timeout 10 > nul
  cls
  goto change-sa
)
goto change

:change-wn
cls
echo ワーカー名を入力してください(チェックはしないので注意！)... 
set /P worker=
goto change

:change-wp
cls
echo ワーカーPassを入力してください(チェックはしないので注意！)... 
set /P workerpass=
goto change

:change-af
cls
echo アフィニティの値を入力してください(16進数でお願いします。また、minerd260+nomp-test,mpos-test使用時は0xが先頭に必要となります。チェックはしないので注意！)...
echo TIPS: アフィニティの値に関しては、基本的には[IRQチューニング]といった言葉で検索してもらえればOKです。
echo また、一応簡易的に説明しますと、Windows上の仕様として1/2から1/3の分のスレッド数を設定するようにアフィニティに設定する
echo （いわゆる、物理コアのみ指定）を行うと早くなる、といったデータは出ています。
echo 保証できるものでもないですが、もし参考になればと思います。(設定する場合は[55....5] or [0x55....5] or [AA....A] or [0xAA...A]となります)
set /P affinity=
goto change

:change-ad
cls
echo マイナーアドレスの値を入力してください(チェックはしないので注意！)... 
set /P address=
goto change

:rapidstart
echo 現在の設定は次のようになっています。
echo ラピッドスタートモードなのでこの設定で実行します。
echo set custom thread= %cthread%
if %cthread%==true (echo thread number= %cthreadnumber%)
echo server= %server%
echo serveraddress= %stratum%
echo worker= %worker%
echo workerpass= %workerpass%
echo affinity= %affinity%
if not "%server%"=="" (echo address= %address%)

if "%8"=="2" (
  echo QuietMode Enable
  set input=1
)
if "%9"=="2" (
  echo QuietMode Enable
  set input=1
)

goto starter

:error
echo 何らかの理由で実行できませんでした。製作者に報告するかアフィニティ・スレッド数を確認して下さい。
echo 知識のある方はBatファイルの中身書き換えてもいいですが、治ったら製作者に報告してくれると助かります。

:exit
exit

:Trim
SET TRIM=%*
