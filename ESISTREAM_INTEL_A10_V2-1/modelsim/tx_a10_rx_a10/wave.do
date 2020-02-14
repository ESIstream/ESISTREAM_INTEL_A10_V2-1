onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_tx_rx_esistream/sync_in_rx
add wave -noupdate /tb_tx_rx_esistream/sync_in_tx
add wave -noupdate /tb_tx_rx_esistream/sync_in_rx_pulse
add wave -noupdate /tb_tx_rx_esistream/sync_in_tx_pulse
add wave -noupdate /tb_tx_rx_esistream/tx_ip_ready
add wave -noupdate /tb_tx_rx_esistream/rx_ip_ready
add wave -noupdate /tb_tx_rx_esistream/rx_lanes_ready
add wave -noupdate -radix hexadecimal /tb_tx_rx_esistream/tx_data
add wave -noupdate -radix hexadecimal /tb_tx_rx_esistream/frame_out
add wave -noupdate -radix hexadecimal /tb_tx_rx_esistream/data_out
add wave -noupdate -radix hexadecimal /tb_tx_rx_esistream/valid_out
add wave -noupdate -radix hexadecimal /tb_tx_rx_esistream/ber_status
add wave -noupdate -radix hexadecimal /tb_tx_rx_esistream/cb_status
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1899909 ps} 0}
quietly wave cursor active 1
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {24786500 ps}
