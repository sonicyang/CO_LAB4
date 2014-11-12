onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group IntCtl /testbench/u_cpu_top/u_cpu_core/u_interrupt_controller/irq
add wave -noupdate -expand -group IntCtl /testbench/u_cpu_top/u_cpu_core/u_interrupt_controller/rst_n
add wave -noupdate -expand -group IntCtl /testbench/u_cpu_top/u_cpu_core/u_interrupt_controller/clk
add wave -noupdate -expand -group IntCtl -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_interrupt_controller/if_pc
add wave -noupdate -expand -group IntCtl /testbench/u_cpu_top/u_cpu_core/u_interrupt_controller/in_isr
add wave -noupdate -expand -group IntCtl -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_interrupt_controller/intctl_epc
add wave -noupdate -expand -group IntCtl -radix binary /testbench/u_cpu_top/u_cpu_core/u_interrupt_controller/intctl_cause
add wave -noupdate -expand -group IntCtl -radix binary /testbench/u_cpu_top/u_cpu_core/u_interrupt_controller/intctl_status
add wave -noupdate -expand -group IntCtl /testbench/u_cpu_top/u_cpu_core/u_interrupt_controller/iack
add wave -noupdate -expand -group IntCtl /testbench/u_cpu_top/u_cpu_core/u_interrupt_controller/want2isr_n
add wave -noupdate -expand -group IF /testbench/u_cpu_top/u_cpu_core/u_cpuif/BS_OFF
add wave -noupdate -expand -group IF /testbench/u_cpu_top/u_cpu_core/u_cpuif/BS_FIRST
add wave -noupdate -expand -group IF /testbench/u_cpu_top/u_cpu_core/u_cpuif/BS_SECOND
add wave -noupdate -expand -group IF /testbench/u_cpu_top/u_cpu_core/u_cpuif/BS_NORMAL
add wave -noupdate -expand -group IF /testbench/u_cpu_top/u_cpu_core/u_cpuif/clk
add wave -noupdate -expand -group IF /testbench/u_cpu_top/u_cpu_core/u_cpuif/rst_n
add wave -noupdate -expand -group IF /testbench/u_cpu_top/u_cpu_core/u_cpuif/imem_databus
add wave -noupdate -expand -group IF /testbench/u_cpu_top/u_cpu_core/u_cpuif/irq
add wave -noupdate -expand -group IF /testbench/u_cpu_top/u_cpu_core/u_cpuif/stall_n
add wave -noupdate -expand -group IF /testbench/u_cpu_top/u_cpu_core/u_cpuif/id_pc_src
add wave -noupdate -expand -group IF /testbench/u_cpu_top/u_cpu_core/u_cpuif/if_intctl_epc
add wave -noupdate -expand -group IF /testbench/u_cpu_top/u_cpu_core/u_cpuif/id_add_out
add wave -noupdate -expand -group IF /testbench/u_cpu_top/u_cpu_core/u_cpuif/id_jump_pc
add wave -noupdate -expand -group IF /testbench/u_cpu_top/u_cpu_core/u_cpuif/id_rs_data
add wave -noupdate -expand -group IF /testbench/u_cpu_top/u_cpu_core/u_cpuif/imem_addr
add wave -noupdate -expand -group IF /testbench/u_cpu_top/u_cpu_core/u_cpuif/imem_read
add wave -noupdate -expand -group IF /testbench/u_cpu_top/u_cpu_core/u_cpuif/in_isr
add wave -noupdate -expand -group IF /testbench/u_cpu_top/u_cpu_core/u_cpuif/id_pca4
add wave -noupdate -expand -group IF /testbench/u_cpu_top/u_cpu_core/u_cpuif/id_ins
add wave -noupdate -expand -group IF /testbench/u_cpu_top/u_cpu_core/u_cpuif/iack
add wave -noupdate -expand -group IF /testbench/u_cpu_top/u_cpu_core/u_cpuif/bs_state
add wave -noupdate -expand -group IF /testbench/u_cpu_top/u_cpu_core/u_cpuif/if2id_r_en
add wave -noupdate -expand -group IF -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuif/if_pc
add wave -noupdate -expand -group IF /testbench/u_cpu_top/u_cpu_core/u_cpuif/if_npc
add wave -noupdate -expand -group IF /testbench/u_cpu_top/u_cpu_core/u_cpuif/if_pca4
add wave -noupdate -expand -group IF -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuif/if_ins
add wave -noupdate -expand -group IF /testbench/u_cpu_top/u_cpu_core/u_cpuif/want2isr
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg00
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg01
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg02
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg03
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg04
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg05
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg06
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg07
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg08
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg09
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg10
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg11
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg12
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg13
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg14
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg15
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg16
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg17
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg18
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg19
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg20
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg21
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg22
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg23
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg24
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg25
add wave -noupdate -expand -group REG -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg26
add wave -noupdate -expand -group REG -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg27
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg28
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg29
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg30
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg31
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr00
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr01
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr02
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr03
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr04
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr05
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr06
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr07
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr08
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr09
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr10
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr11
add wave -noupdate -expand -group REG -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr12
add wave -noupdate -expand -group REG -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr13
add wave -noupdate -expand -group REG -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr14
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr15
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr16
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr17
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr18
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr19
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr20
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr21
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr22
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr23
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr24
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr25
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr26
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr27
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr28
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr29
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr30
add wave -noupdate -expand -group REG /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr31
add wave -noupdate -radix hexadecimal /testbench/IDBUS
add wave -noupdate -radix hexadecimal /testbench/ic_rdatabus
add wave -noupdate -radix hexadecimal /testbench/ic_addr
add wave -noupdate -radix hexadecimal /testbench/m1_ic_addr
add wave -noupdate -radix hexadecimal /testbench/dc_addr
add wave -noupdate /testbench/ic_rdatabus
add wave -noupdate /testbench/m1_ic_rdatabus
add wave -noupdate /testbench/m2_ic_rdatabus
add wave -noupdate /testbench/m3_ic_rdatabus
add wave -noupdate /testbench/m4_ic_rdatabus
add wave -noupdate /testbench/u_code_memory/r_rden1
add wave -noupdate -radix hexadecimal /testbench/u_code_memory/MemAddr_R1
add wave -noupdate /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/clk
add wave -noupdate /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/rst_n
add wave -noupdate /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/iack
add wave -noupdate /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cp0_ins
add wave -noupdate -radix binary /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/mf_cp0_ins
add wave -noupdate -radix unsigned /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/read_reg1_num
add wave -noupdate -radix unsigned /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/read_reg2_num
add wave -noupdate -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/read_reg3_num
add wave -noupdate -radix unsigned /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/write_reg_num
add wave -noupdate /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/wb_w_cp0reg
add wave -noupdate -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/write_data
add wave -noupdate -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/read_data1
add wave -noupdate -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/read_data2
add wave -noupdate /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cs_regwrite
add wave -noupdate /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cs_write_mask
add wave -noupdate /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/id2intctl
add wave -noupdate /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/id_intctl_epc
add wave -noupdate /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/id_intctl_cause
add wave -noupdate /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/id_intctl_status
add wave -noupdate /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/addr_decode
add wave -noupdate /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg_enable
add wave -noupdate /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cp0_reg_enable
add wave -noupdate -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/read_data1_content
add wave -noupdate -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/read_data2_content
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {321028 ps} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 247
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {440930 ps}
