# L4Re tutorial recipes

This package provides recipes to build a variety of L4Re demos. It consists of
the main L4Re components and a number of guests, namely Linux, Zephyr and
FreeRTOS.

# Build instructions

To build the demos you need the
[BobBuildTool](https://bob-build-tool.readthedocs.io). The recommended way is
to install via pip:

    $ pip3 install --user BobBuildTool

Make sure that `~/.local/bin` is on your `$PATH`.

As first-time setup, you must fetch the layers that this repsitory is using:

    $ bob layers update

To view the available example plaforms, do a `bob ls`:

    $ bob ls
    examples-amd64
    examples-arm-fvp_base_r
    examples-arm-qemu_virt
    examples-arm64-fvp_base_r
    examples-arm64-qemu_virt
    examples-arm64-sbsa
    ...

Under each of the platforms, a number of examples are available:

    $ bob ls -d "examples-amd64/examples::*"
    examples-amd64/examples::hello
    examples-amd64/examples::ipcbench
    examples-amd64/examples::linux-vm-multi
    examples-amd64/examples::linux-vm-single

The demos are built by invoking bob, e.g.:

    $ bob dev --dev-sandbox examples-amd64/examples::hello -j

# Running the demos

If the example can be run in an emulator, there will be a "launch" file next to
it. Just execute it to run the demo:

    $ bob dev --dev-sandbox examples-amd64/examples::hello -j
    [...]
    Build result is in dev/dist/examples/hello/1/workspace
    $ dev/dist/examples/hello/1/workspace/bootx64.efi.launch

In this particular example, Qemu is supposed to be installed on your computer.
Other demos require that the the Arm Fixed Virtual Platform emulator is
available in `$PATH`. The FVP can be downloaded for free from the [Arm
Architecture Models
website](https://developer.arm.com/downloads/-/arm-ecosystem-models). Make sure
to download the *Armv8-R AEM FVP* model. Just extract the archive somewhere and
add the `models/Linux64_GCC-9.3` directory to your `$PATH`.

# License

Detailed licensing and copyright information can be found in
the [LICENSE](LICENSE.spdx) file.
