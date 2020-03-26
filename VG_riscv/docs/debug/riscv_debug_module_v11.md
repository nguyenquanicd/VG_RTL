RISC-V Debug Module Implementation
----------------------------------

This gist discusses implementation of a Debug Module (DM) primarily per RISC-V [Debug Specification v0.11](https://static.dev.sifive.com/riscv-debug-spec-0.11nov12.pdf). The core ideas, though, apply to [Debug Specification v0.13](https://static.dev.sifive.com/riscv-debug-spec-0.13.4a0152d.pdf). Information presented here come from various sources, but mostly from Debug Specs, [riscv-isa-sim](https://github.com/riscv/riscv-isa-sim) and from reverse engineering [e200_opensource](https://github.com/SI-RISCV/e200_opensource). Relevant source of information is also [riscv-openocd](https://github.com/riscv/riscv-openocd).

### General Discussion ###

#### RV Debug Task Group ####

RISC-V Foundation established a [debug task group](https://github.com/riscv/debug-taskgroup) to propose and standardize mechanisms for external debugging of RISC-V (RV) cores. This effort resulted in drafting a *RISC-V External Debug Supprt* specification, early [v0.11](https://static.dev.sifive.com/riscv-debug-spec-0.11nov12.pdf) and present [v0.13](https://github.com/riscv/riscv-debug-spec/blob/master/riscv-debug-spec.pdf).

The proposal is not yet frozen and latest version is available in a Github repo, https://github.com/riscv/riscv-debug-spec/. Interested readers shall refer to reported issues (both open and closed) for discussion of certain grey areas and getting rationale of decisions being made.

Before coming to a proposal, the task group surveyed a number of existing solutions and analyzed two of the most prevalent debug mechanism. This [presentation](https://goo.gl/9abgZa) gives a summary of this effort and provides a good insight into the problem. Terminology introduced next comes mostly from this source.

#### Terminology ####

Debugging is usually understood as a method to monitor, inspect and interact with program execution. In terms of a processor core, the program execution aligns with the core procesing. Terms used in this context are *run-control debugging* and *trace debugging*. The former aliases with the general understanding to inspect and interact with the core, while the latter is more about getting an aggregate information about the core's performance.

There are two main concepts of external debugging:

- *Halt debugging*: This aliases with the naive approach to stall the CPU pipeline and insert multiplexers into the datapath to alter the CPU state. Altering the control flow (i.e. instructions) is through a direct access to instruction memory (without CPU being involved).
  
  This method is "invasive" to the CPU and the complexity of debugging logic increases with the complexity of the CPU. 

- *Instruction feeding*: This method is based on redirecting CPU control flow (e.g. through a specific debug interrupt vector) and "feeding" it snippets of debug code to report or change the CPU status. That is, rather than being halted, the core remains active and executes a debug ISR (interrupt service routine), where it waits for commands from a debugger.

  The instruction feeding method is less invasive as it requires few extra rgisters and a specific debug mode, which slightly alters the normal CPU behavior (e.g. repsonses to interrupts and exceptions). This method also seems a bit more flexible and more agnostic to CPU complexity.

For simple cores, the complexity of both concepts is roughly equal.

### RV DM Architecture and Concepts ###

RV Debug Task Group decided for the instruction feeding concept. While now being obdelte, the spec v0.11 provides an excellent introduction into the concept as it goes down into describing a reference implementation. The updated v0.13 has become more abstract and focuses more on general requirements. The reference implementation then needs to be sought in other places such as `riscv-isa-sim`.

![Debug_sys_overview](https://gist.githubusercontent.com/brabect1/a39c5470b4cf49524919bfb3e3f20a5c/raw/33a8f35262572d5d5058efb69ecfd8faf181de10/x_riscv_debug_system_overview_v0p11.png)

The above figure (copied from debug spec v0.11) provides the overall RV debug system overview. For complete description refer to the debug spec as here we focus on the RV core and the Debug Module (DM). The figure shows the important components, their interaction and allocarion to modules. Later we will show and discuss a particular implementation.

#### Components ####

Components allocated to an RV core and a debug module are as follows:

- *Debug ROM (DROM)*: Implements the debug ISR and defines the way to transfer the control to DRAM. It may not neccessarily be a ROM, but it has to be non-volatile as the CPU may enter the debug mode right after reset.

  Since it provides an ISR code, it has to be mapped into CPU's address space (and be accessible from the instruction port). The DROM code implements a signaling scheme between CPU and a debugger.

- *Debug RAM (DRAM, or Program Buffer in v0.13)*: A small region of RAM, where a debugger may put code snippets and then instruct the CPU (through the code in DROM) to execute those snippets.

  Note that the debugger may instruct the CPU to go and execute code from wherever, but it always has to start in DRAM and go back to DROM (so that the whole principle works).
  
  DRAM (like DROM) has to be mapped into the CPU's address space and be accessible to the instruction port. It also needs (as per v0.11) to be accessible to the data port to exchange data back and forth between a debugger and the CPU. The latter requirement could be theoretically softened (and data exchanged by some other means), but existing Debug Translators do rely on it. 

- *Debug Module Registers*: These are registers through which a debugger gets control and status of CPU debugging features. Their main aspect is to make the CPU enter a debug mode and to monitor if the CPU stopped on a breakpoint. There are, of course, many other finer points (e.g. single stepping, feature discovery, hart selection, core reseting, etc.).

  These registers are inherent part of the Debug Module and are normally accessed through a *DMI (Debug Module Interface)*, a.k.a. *Debug Bus* in v0.11. CPU has normally no direct access to these registers, but have partial control through System *Bus Registers*.

- *Core Debug Registers (or Debug CSRs)*: These are extra CPU Control and Status Registers (CSRs) and hence accessible through RV `csr` instructions. Some of these registers are also afected by changes in the CPU debug state (e.g. by entering or leaving a Debug Mode).

  These registers normally reside in an RV core and are accessible only in the *Debug Mode*. While not being a considered a component, the *Debug Mode* is a special CPU mode other than the privilege modes.

- System *Bus Registers*: These registers are mapped into CPU's address space (through a system bus), along with DROM and DRAM. They provide a means to signal certain requests from CPU to DM (e.g. to clear the debug interrupt request). The actual signaling is coded in DROM (and hence a part of DM), so that CPU architecture is agnostic to that. However, a Debug Translator may need to be aware of this signaling scheme.

  The Bus Registers shall reside in DM due to their tight coupling to DROM, be mapped into CPU's address space and be accessible to the data port.
  
  Keep in mind that their existence is tightly coupled to the code in the Debug ROM. The signalling interface back from CPU to DM could be implemented differently (e.g. by DMI arbitrated between a Debug Transport Module and CPU) and then the code in Debug ROM would change accordingly (even thought the concept would remain the same).
  
- There can be other components in the system (e.g. *System Bus Access*, *Serial Ports*, *HW Breakpoints*, etc.), but these are optional and only enhance flexibility of the debug system. They do not change the debug concepts.

In v0.13 the overview figure changed somewhat; the Debug Module has become more abstract, terminology and component allocaion changed a bit. But most of the components are still there, the Debug Module Registers, Debug ROM, Program Buffer (even though it may reside externally to DM), even the Bus Registers.

#### Concepts ####

- Requests from a debugger to CPU: Any request starts by setting up a DRAM code (i.e. specifying what the debugger wants CPU to do) and rising a debug interrupt to CPU. The CPU responds by jumping to the DROM code (return address is saved into a Debug CSR, `dpc`).

- Clearing the debug interrupt/Leaving the debug mode: Once complete, DRAM code shall return back to DROM, which in turn signals to DM completion of debug interrupt servicing. Unless it shall remain halted, CPU leaves the debug mode (through `dret`) and resumes execution from the address stored in `dpc`.

- Halting on a breakpoint/Single step: When hitting a breakpoint (either HW one or `ebreak`) CPU jumps to a break vector in DROM and signals to DM (through Bus Registers) it has halted. A debugger polls the DM status and after noticing CPU halted will respond by some request.

### Implementation ###

![Block_diag](https://gist.githubusercontent.com/brabect1/a39c5470b4cf49524919bfb3e3f20a5c/raw/e4568e70b50537ff9fba267470191c6a40fa9dfb/x_riscv_dm_block_diag.png)

![Halt_seq_diag](https://gist.githubusercontent.com/brabect1/a39c5470b4cf49524919bfb3e3f20a5c/raw/2fbae75365f0e22b8a155b34f187e3df787a8b31/x_riscv_dm_seq_diag_halt.png)

![Resume_seq_diag](https://gist.githubusercontent.com/brabect1/a39c5470b4cf49524919bfb3e3f20a5c/raw/2fbae75365f0e22b8a155b34f187e3df787a8b31/x_riscv_dm_seq_diag_resume.png)

### DM v0.11 Implementation ###