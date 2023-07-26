@ECHO ON
echo "Opening the AXI Files."
start gvim -p ..\RTL\*.sv ..\ENV\*.sv ..\TEST\*.sv ..\TOP\*.sv 
call gvim -p ..\ENV\MAS_AXI_ENV\*.sv 
call gvim -p ..\ENV\SLV_AXI_ENV\*.sv 
call gvim -p ..\SIM\*.do ..\SIM\*.log
exit