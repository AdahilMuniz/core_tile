global SCRIPT_DIR

if {![ info exists SCRIPT_DIR]} {
    set SCRIPT_DIR [ file normalize "[ file normalize [ info script ] ]/../" ] 
}

set SRC_DIR [ file normalize "$SCRIPT_DIR/../rtl/" ]
set SRC_CORE_DIR [ file normalize "$SCRIPT_DIR/../rtl/core/sargantana/rtl/" ]
set SRC_DATAPATH_DIR [ file normalize "$SCRIPT_DIR/../rtl/core/sargantana/rtl/datapath/rtl" ]
set INC_DIR [ file normalize "$SCRIPT_DIR/../includes/" ] 
set INC_CORE_DIR [ file normalize "$SCRIPT_DIR/../rtl/core/sargantana/includes/" ] 

#set CELL_LIB_DIR "/soft64/design-kits/ncsu/freepdk45/nangate/NangateOpenCellLibrary_PDKv1_3_v2010_12/Front_End/Liberty/NLDM/"

set CELL_LIB_DIR  /pdk/tsmc/PDK28/PDK_TSMC28_bv/tcbn28hpcplusbwp30p140_190a/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn28hpcplusbwp30p140_180a/
set CELL_LEL_DIR  /pdk/tsmc/PDK28/PDK_TSMC28_bv/tcbn28hpcplusbwp30p140_190a/TSMCHOME/digital/Back_End/

puts $INC_DIR
puts $SRC_DIR

read_lib $CELL_LIB_DIR/tcbn28hpcplusbwp30p140tt0p9v25c.lib
read_physical -lefs "${CELL_LEL_DIR}/lef/tsmcn28_9lm5X1Y1Z1UUTRDL.tlef  ${CELL_LEL_DIR}/lef/tcbn28hpcplusbwp30p140_110a/lef/tcbn28hpcplusbwp30p140.lef"
set_db init_hdl_search_path {"/home/adahil.muniz/develop/core_tile/includes/" "/home/adahil.muniz/develop/core_tile/rtl/core/sargantana/includes/" "/home/adahil.muniz/develop/core_tile/rtl/core/sargantana/rtl/" "/home/adahil.muniz/develop/core_tile/rtl/core/sargantana/rtl/mmu/includes"}
set_db auto_ungroup none
read_hdl -define {SARG_BYPASS_LSQ CONF_HPDCACHE_REQ_WORDS=8 CONF_HPDCACHE_WBUF_WORDS=1 CONF_HPDCACHE_ACCESS_WORDS=8 CONF_SARGANTANA_PHY_ADDR_SIZE=40 CONF_HPDCACHE_PA_WIDTH=40} -sv -f src_sargantana.f
elaborate simd_unit
syn_gen
syn_map
syn_opt
report area > area_report.txt
report gates > gates_report.txt
report power > power_report.txt
report timing -unconstrained > timing_report.txt
