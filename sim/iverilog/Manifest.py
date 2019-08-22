action = "simulation"
sim_tool = "iverilog"
sim_top = "tb_74x153"

iverilog_opt = "-g2012"

sim_post_cmd = "vvp %s.vvp; gtkwave %s.vcd" % (sim_top, sim_top)

modules = {
  "local": ["../../tests/74x153"],
}
