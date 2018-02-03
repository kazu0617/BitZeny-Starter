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
echo ���̃c�[���́ABitZeny Discord��AIRQ�`���[�j���O�ɂ��n�b�V�����[�g�̌�����ő���������A���ݒ���Ȃ�ׂ��y�ɁA
echo �Θb���ɂł���悤�ɐ��삵�������c�[���ƂȂ�܂��B
echo ���c�[���ł�Lapool�̎g�p�Ɋւ��Đ����������Ă���܂��B���̃v�[���T�C�g���g�p���Ă��������悤���肢���܂��B
echo ���̃��b�Z�[�W��10�b��ɏ����܂��B�����ɔ�΂�������Ή����L�[����͂��Ă��������B
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
echo ���̐ݒ�͎��̂悤�Ȓl���V���[�g�J�b�g�Őݒ肷�邱�ƂŒ��ڐݒ�\�ł��B
if not "%address%"=="" (
  echo %0 %server% %stratum% %worker% %workerpass% %cthread% %cthreadnumber% %affinity% %address% %9
) else (
  echo %0 %server% %stratum% %worker% %workerpass% %cthread% %cthreadnumber% %affinity% %address%
)
if "%8"=="" (
  echo �Ȃ��Aaffinity�̌��ɃX�y�[�X���󂯂�1����͂���ƃ��s�b�h�X�^�[�g��������܂��B
  echo ���̍ہA���̃_�C�A���O���΂��Ď��s���\�ɂȂ�܂��B
) else if "%9"=="" (
  echo �Ȃ��Aaddress�̌��ɃX�y�[�X���󂯂�1����͂���ƃ��s�b�h�X�^�[�g��������܂��B
  echo ���̍ہA���̃_�C�A���O���΂��Ď��s���\�ɂȂ�܂��B
)

echo ���̐ݒ��OK�ł����H
echo [0] OK
echo [1] OK(QuietMode)
echo [2] NG (�C������)
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
echo ���s����܂����B���b��ɐݒ��ʂɖ߂�܂�
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
echo ���s����܂����B���b��ɐݒ��ʂɖ߂�܂�
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
echo ���s����܂����B���b��ɐݒ��ʂɖ߂�܂�
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
echo ���s����܂����B���b��ɐݒ��ʂɖ߂�܂�
set input=3
timeout 5 > nul
goto repeat

:change
cls
echo �ǂ̍��ڂ�ҏW���܂����H
echo [0] �X���b�h��
echo [1] ���[�N�T�[�o�[�^�C�v/���[�N�T�[�o
echo [2] ���[�J�[��
echo [3] ���[�J�[Pass
echo [4] �A�t�B�j�e�B�i�㋉�Ҍ����I�j
echo [5] �}�C�i�[�A�h���X (�ꕔ���̂�)
echo [9] �ҏW���I������
echo ---�ȈՕ\��---
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
echo �X���b�h���͎w�肵�܂����H
echo [0] ����
echo [1] ���Ȃ�
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
echo �X���b�h������͂��Ă�������(�`�F�b�N�͂��Ȃ��̂Œ��ӁI)... 
set /P cthreadnumber=
goto change

:change-ws
cls
echo �T�[�o�[����I�����Ă��������i2018/02/03���݁j
echo �i�����̃v���Z�b�g�ɗp�ӂ���Ă���͍̂���Փx�̂��݂̂̂ł��B�j
echo �i����Փx�A���Փx�̂��̂͂��̑���ݒ�̏�URL���R�s�[���Ă��ĉ������j
echo ---MPOS(Mining Fee:0%%�̃T�[�o�[�̂݋L��)---
echo [0] ���̃v�[���������I
echo [1] Happy Miner
echo [2] �R�R�A�v�[��
echo [3] �Ղ�Ղ�Ձ[��ibitzeny�j
echo [4] Knyacki pool
echo [5] powerpool for BitZeny
echo [6] Bunnymining
echo [7] BitZenyPool�@�� �i �� ��
echo [49] ���̑�(MPOS)
echo ---��������NOMP(Mining Fee�t��)---
echo [50] WPOOL(Fee:0.1%%)
echo [51] kruptos:BitZeny Pool(Fee:0.1%%)
echo [52] Daddy-pool(Fee:1%%)
echo [53] Bluepool(Fee:1%%)
echo [99] ���̑�(NOMP)

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
echo �T�[�o�[�A�h���X����͂��Ă�������(Lapool���w�肷�邱�Ƃ͂ł��܂���B��낵�����肢���܂��B)... 
set /P stratum=
echo %stratum% | find %lapool% >nul
if not errorlevel 1 (
  echo Lapool���g�p���邱�Ƃ͂ł��܂���B
  echo �l���m�F�̏�ŁA�ē��͂��肢���܂��c
  echo 10�b��ɍēx���͉�ʂɈڍs���܂�
  timeout 10 > nul
  cls
  goto change-sa
)
goto change

:change-wn
cls
echo ���[�J�[������͂��Ă�������(�`�F�b�N�͂��Ȃ��̂Œ��ӁI)... 
set /P worker=
goto change

:change-wp
cls
echo ���[�J�[Pass����͂��Ă�������(�`�F�b�N�͂��Ȃ��̂Œ��ӁI)... 
set /P workerpass=
goto change

:change-af
cls
echo �A�t�B�j�e�B�̒l����͂��Ă�������(16�i���ł��肢���܂��B�܂��Aminerd260+nomp-test,mpos-test�g�p����0x���擪�ɕK�v�ƂȂ�܂��B�`�F�b�N�͂��Ȃ��̂Œ��ӁI)...
echo TIPS: �A�t�B�j�e�B�̒l�Ɋւ��ẮA��{�I�ɂ�[IRQ�`���[�j���O]�Ƃ��������t�Ō������Ă��炦���OK�ł��B
echo �܂��A�ꉞ�ȈՓI�ɐ������܂��ƁAWindows��̎d�l�Ƃ���1/2����1/3�̕��̃X���b�h����ݒ肷��悤�ɃA�t�B�j�e�B�ɐݒ肷��
echo �i������A�����R�A�̂ݎw��j���s���Ƒ����Ȃ�A�Ƃ������f�[�^�͏o�Ă��܂��B
echo �ۏ؂ł�����̂ł��Ȃ��ł����A�����Q�l�ɂȂ�΂Ǝv���܂��B(�ݒ肷��ꍇ��[55....5] or [0x55....5] or [AA....A] or [0xAA...A]�ƂȂ�܂�)
set /P affinity=
goto change

:change-ad
cls
echo �}�C�i�[�A�h���X�̒l����͂��Ă�������(�`�F�b�N�͂��Ȃ��̂Œ��ӁI)... 
set /P address=
goto change

:rapidstart
echo ���݂̐ݒ�͎��̂悤�ɂȂ��Ă��܂��B
echo ���s�b�h�X�^�[�g���[�h�Ȃ̂ł��̐ݒ�Ŏ��s���܂��B
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
echo ���炩�̗��R�Ŏ��s�ł��܂���ł����B����҂ɕ񍐂��邩�A�t�B�j�e�B�E�X���b�h�����m�F���ĉ������B
echo �m���̂������Bat�t�@�C���̒��g���������Ă������ł����A�������琻��҂ɕ񍐂��Ă����Ə�����܂��B

:exit
exit

:Trim
SET TRIM=%*
