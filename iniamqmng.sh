#
export CAPLIC=amqmng
export APL=/home/amqmng
#
#
# OpenCobol
#
# COB_PRE_LOAD : is an environment variable that controls what dynamic link modules are included in a run.
# COB_LIBRARY_PATH  :  To find <program>.so --> cobcrun <program>.so
#
echo  "CONFIGURANDO VARIBALES OPENCOBOL ... "
export COB_PRE_LOAD=libstomp
export COB_LIBRARY_PATH=$APL/lib
export LD_LIBRARY_PATH=/opt/opencobol/lib:$APL/lib:$LD_LIBRARY_PATH
export LD_RUN_PATH=/opt/opencobol/lib:$LD_RUN_PATH
export COBCPY=$APL/copy:$COBCPY
export PATH=/opt/opencobol/bin:$DB2_HOME/BIN:$PATH
export DEBUG=NODEBUG
export FILEDAT=$APL/data/filedat.out
#
cd $APL
