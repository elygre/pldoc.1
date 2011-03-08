@echo off
setlocal
cd iknowbase
call ../pldoc.bat -doctitle 'iKnowBase' -d iKnowBase e:/iknowbase_trunk/Database/source/dbapi/packages/*.pks 
rem call ../pldoc.bat -doctitle 'iKnowBase' -d iKnowBase e:/iknowbase_trunk/Database/source/providers/common/ikb_htf.pks
rem call ikb
endlocal
