@echo off
REM pldoc.bat

REM Resolve the directory of pldoc
set pldir=%~d0%~p0

REM Set bootclasspath.
REM NB: this is needed to make JDK1.4 use our Xerces version instead of internal parser
set bcp=%pldir%xalan\bin\xalan.jar;%pldir%xalan\bin\xml-apis.jar;%pldir%xalan\bin\xercesImpl.jar
REM Set classpath
REM NB: classpath must contain the pldoc directory to be able to locate .xsl files
set cp=%pldir%;%pldir%\pldoc.jar
set cp=%pldir%;%pldir%\target\pldoc-0.9.1-SNAPSHOT.jar

:arg
if "%1" == "" goto call
if "%1" == "-url" goto oracle
shift
goto arg

:oracle
rem Include Oracle jars in the classpath 
if "%ORACLE_HOME%" == "" ( echo ERROR: Environment variable ORACLE_HOME not set. 1>&2 && exit /b 1 )
set cp=%cp%;%ORACLE_HOME%\jdbc\lib\ojdbc14.jar;%ORACLE_HOME%\jdbc\lib\classes12.jar

:call
REM Call PLDoc
rem java -Xbootclasspath/p:"%bcp%" -cp "%cp%" net.sourceforge.pldoc.PLDoc %*

set xalandir=%pldir%xalan\bin
set bcp=%xalandir%\xalan.jar;%xalandir%\xml-apis.jar;%xalandir%\xercesImpl.jar;%xalandir%\serializer.jar
java -Xbootclasspath/p:"%bcp%" -cp "%cp%" net.sourceforge.pldoc.PLDoc %*