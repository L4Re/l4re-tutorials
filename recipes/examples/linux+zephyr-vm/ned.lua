-- vim: syntax=lua
local L4 = require "L4";

local l = L4.Loader.new({
    mem = L4.Env.user_factory,
    log_fab = L4.default_loader:new_channel(),
  });


L4.default_loader:start(
  {
    log = L4.Env.log,
    caps = {
      cons = l.log_fab:svr(),
      jdb  = L4.Env.jdb,
    },
  }, "rom/cons -a");


local platform_ctl = l:new_channel();
local linux_vbus = l:new_channel()
local rtc_vbus = l:new_channel()
l:startv(
  {
    caps = {
      sigma0        = L4.cast(L4.Proto.Factory, L4.Env.sigma0):create(L4.Proto.Sigma0);
      icu           = L4.Env.icu;
      iommu         = L4.Env.iommu;
      platform_ctl  = platform_ctl:svr(),
      jdb           = L4.Env.jdb,

      -- vbus capabilities
      linux_vm      = linux_vbus:svr(),
      rtc           = rtc_vbus:svr(),
    };
    log = {"io", "r", "keep"};
  }, "rom/io", "-vvv", "rom/io.lua")

local rtc = l:new_channel();
l:startv(
  {
    caps = {
      vbus = rtc_vbus;
      rtc = rtc:svr();
    };
    log = {"rtc", "g", "keep"};
  }, "rom/rtc");


local mem_flags = L4.Mem_alloc_flags.Continuous
                  | L4.Mem_alloc_flags.Pinned
                  | L4.Mem_alloc_flags.Super_pages;

local ram_zephyr = L4.Env.user_factory:create(L4.Proto.Dataspace,
                                              2 * 1024 * 1024,
                                              mem_flags, 20, 0x02000000):m("rw");

l:startv(
  {
    log = { "zephyr", "normal" },
    caps = {
      jdb = L4.Env.jdb,
      ram = ram_zephyr,
    },
  },
  "rom/uvmm", "-drom/virt-arm_r82-zephyr.dtb", "-krom/zephyr.elf")


local ram_linux = L4.Env.user_factory:create(L4.Proto.Dataspace,
                                             256 * 1024 * 1024,
                                             mem_flags, 20, 0x10000000):m("rw");

l:startv(
  {
    log = { "linux", "normal" },
    caps = {
      jdb = L4.Env.jdb,
      ram = ram_linux,
      vbus = linux_vbus,
      rtc = rtc,
    },
  },
  "rom/uvmm",
  "-drom/virt-arm_r82-linux.dtb", "-krom/vmlinux", "-rrom/initramfs.cpio.gz",
  "-cconsole=ttyAMA0"
  )
