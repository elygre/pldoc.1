@echo off
setlocal
cd iknowbase
rem call ../pldoc.bat -doctitle 'iKnowBase' -d iKnowBase e:/iknowbase_trunk/Database/source/dbapi/packages/*.pks
call ../pldoc.bat -doctitle 'iKnowBase' -d iKnowBase e:/iknowbase_trunk/Database/source/providers/common/ikb_htf.pks
rem call ikb
endlocal
