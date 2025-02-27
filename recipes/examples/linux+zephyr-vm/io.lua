local Res = Io.Res
local Hw = Io.Hw

local add_children = Io.Dt.add_children

add_children(Io.system_bus(), function()
  eth0 = Hw.Device(function()
    Property.hid = "SMSC 91C111";
    compatible = {"smsc,lan91c111"};
    Resource.irq0 = Res.irq(32 + 15, Io.Resource.Irq_type_level_high);
    Resource.regs = Res.mmio(0x9a000000, 0x9affffff);
  end);
  rtc0 = Hw.Device(function()
    Property.hid = "PL031";
    compatible = {"arm,pl031"};
    Resource.irq0 = Res.irq(32 + 4, Io.Resource.Irq_type_level_high);
    Resource.regs = Res.mmio(0x9c170000, 0x9c17ffff);
  end);
end)

Io.add_vbusses
{ 
  linux_vm = Io.Vi.System_bus(function()
    eth0 = wrap(Io.system_bus().eth0);
  end);
  rtc = Io.Vi.System_bus(function()
    rtc0 = wrap(Io.system_bus().rtc0);
  end);
}
