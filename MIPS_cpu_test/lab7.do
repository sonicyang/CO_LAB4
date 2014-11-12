onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {interrupt module} /testbench/u_cpu_top/u_cpu_core/u_interrupt_module/irq
add wave -noupdate -expand -group {interrupt module} /testbench/u_cpu_top/u_cpu_core/u_interrupt_module/rst_n
add wave -noupdate -expand -group {interrupt module} /testbench/u_cpu_top/u_cpu_core/u_interrupt_module/clk
add wave -noupdate -expand -group {interrupt module} /testbench/u_cpu_top/u_cpu_core/u_interrupt_module/if_pc
add wave -noupdate -expand -group {interrupt module} /testbench/u_cpu_top/u_cpu_core/u_interrupt_module/id2intctl_status
add wave -noupdate -expand -group {interrupt module} /testbench/u_cpu_top/u_cpu_core/u_interrupt_module/intctl_epc
add wave -noupdate -expand -group {interrupt module} /testbench/u_cpu_top/u_cpu_core/u_interrupt_module/intctl_cause
add wave -noupdate -expand -group {interrupt module} /testbench/u_cpu_top/u_cpu_core/u_interrupt_module/intctl_status
add wave -noupdate -expand -group {interrupt module} /testbench/u_cpu_top/u_cpu_core/u_interrupt_module/iack
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg00
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg01
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg02
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg03
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg04
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg05
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg06
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg07
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg08
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg09
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg10
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg11
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg12
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg13
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg14
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg15
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg16
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg17
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg18
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg19
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg20
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg21
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg22
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg23
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg24
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg25
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg26
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg27
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg28
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg29
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg30
add wave -noupdate -expand -group reg.&cp0_reg -radix decimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/reg31
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr00
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr01
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr02
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr03
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr04
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr05
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr06
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr07
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr08
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr09
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr10
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr11
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr12
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr13
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr14
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr15
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr16
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr17
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr18
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr19
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr20
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr21
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr22
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr23
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr24
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr25
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr26
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr27
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr28
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr29
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr30
add wave -noupdate -expand -group reg.&cp0_reg -radix hexadecimal /testbench/u_cpu_top/u_cpu_core/u_cpuid/u_regbank/cpr31
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {60017 ps} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {196352 ps}
