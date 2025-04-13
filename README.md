# DSP-Design
Through this project I aim to continue my learning within hardware architectures and to start exploring the world of digital signal processing. I aim to provide a weekly update highlighting the new things learned.


Update #1 :
Being the first update, it's not even a week since I started the documentation. Being impatient to "launch" this project online, I chose to write this after only 3 hours of work.

The main objectives of the project are the following:

• Understanding the architecture of a DSP

• Understanding the differences between a DSP and a regular microprocessor 

• Discovering the specific aspects of DSPs

What is a DSP?

A DSP is just a microprocessor with small adjustments to be able to perform mathematical operations on digital signals. DSP architectures must be optimized to be able to process information in real time, thus improving parameters such as: computing speed, and computing capacity are essential.
DSP architectures are not at all different from those of regular microprocessors, the Von Neumann architecture being used in low-performance DSPs where cost is the main concern, but some applications require performance at the expense of cost, in these applications the Harvard architecture is preferred, the latter offering simultaneous access to data memories and instruction memory. Improved versions of the Harvard architecture are being developed by major players in the DSP market. ARM offers the Cortex-M version with DSP extension and Analog Devices offers SHARC (Super Harvard Architecture). 
As a case study for this project I will use the SHARC architecture from Analog Devices.

What is SHARC?
SHARC is basically a Harvard architecture but, unlike the classic version, it also offers a cache memory for instructions within the CPU and a DSP-specific I/O Controller.

![image](https://github.com/user-attachments/assets/b20148db-c50a-4234-82d8-1cb2d8b78372)

This super simplified block diagram shows the internal structure, introduced by Analog Devices with the ADSP-2106x and ADSP-211xx DSP families.
The general problem of the Harvard structure is the imbalance between data transfer on the PM BUS and the DM BUS. For each operation that needs 2 operands we must transfer: an instruction on the PM BUS and 2 values ​​on the DM BUS. 
To solve this problem, the following changes were made: 
1. Part of the program data will be stored in Program Memory, data necessary for the execution of the instructions, for example multiplication constants or coefficients for filters.
2. A Cache memory was introduced within the CPU to store the most used instructions. 

Circular Buffering 

Due to the Circular Buffering concept, implementing a Cache memory to store the most used instructions is a very good idea, let me elaborate:

![image](https://github.com/user-attachments/assets/b5b2c48a-6ccf-4a85-99d0-3abbb67f9f06)

Because DSPs usually work with real-time data, the processing of information fragments must take place quickly and efficiently, processing one segment being necessary before receiving another segment. The way in which this data is stored is similar to using a stack: Each segment of received information is placed at the top of the buffer to be processed and interpreted, these steps being performed for each segment separately, while the previous segment is pushed to the "base" of the stack. 
Thus, because the same instructions are always executed for each segment, it makes sense to introduce a Cache memory in which the CPU stores the necessary instructions.


Update #2 : 
After a very busy second week, I only managed to study the main blocks of the DSP architecture. At the same time, I realized that I overestimated my knowledge last week in trying to create a circular buffer (the intention was good, the execution was bad), being overwhelmed by the ecstasy of a new beginning I did not realize that Circular Buffering is a feature of the data memory, not a feature of the buffer itself. 
Anyway, I'm happy that I have now achieved this on my own. That being said, let's move on to the really important part, the currently text-only description of the components.


Cache memory 

In modern DSPs there is a very good memory separation, this separation provides an access time of the order of nanoseconds. Cache memories can also be separated depending on the access time or their purpose. For example:
As I specified when I presented the SHARC architecture, the introduction of a cache memory was a very smart move in terms of streamlining the calculations performed by the microprocessor. But to push the performance as far as possible, the introduction of a cache memory for data was a necessity, so important data for performing instructions ended up being moved according to the needs of the microprocessor to the newly implemented cache memory by a DMAC from the data memory or even the code memory (memory in which we know that within the SHARC architecture certain important data were also stored), the data stored in the Cache memory could be, for example, filter coefficients or other constants relevant to the calculations that follow.

DMA Controller

The DMA controller is another essential block in any microprocessor. The DMA controller is another microprocessor that works in parallel with the main microprocessor, in our case the DSP. Its role is to free the main microprocessor from the task of transferring data. The DMAC is responsible for filling cache memories (for simplicity I will use direct mapping) but also for other data transfers. 
One of the tasks left to the main microprocessor is to correctly set the DMAC. This setting can be done in 2 main ways:
1. Register-based: when the internal registers of the DMAC are used directly for setting.
The advantages are: Simplicity and higher execution speed, since only registers are used 
The main disadvantage is the limitation of complexity, this configuration mode is only suitable for simple transfers.
2. RAM-based: in this mode the instructions dedicated to the DMAC are stored in the RAM memory in the form of "deciphers" (data structures containing all the transfer parameters.).
The advantages are: Scalability, unlike the Register Based configuration, here we are not limited by the small size of the registers, so the instructions can be more complex and numerous. But also the flexibility of implementing automated tasks.
The main disadvantage is the more complicated configuration but also the longer execution time, as it is necessary to access external memory.
*From now on I will use the "Register based" configuration mode.

MAC-centred Architecture 

For a correct and efficient optimization of the DSP it is also necessary to process data efficiently. For this a DSP needs:
1. Registers (as many as possible) – these are extremely fast memory blocks used either to transfer data or to store intermediate data. In general, their over-dimensioning is desired, as they are longer than the standard width of the word used by the DSP 
2. Multipliers – Used to multiply values ​​during processing, a practice used in the industry to reduce rounding errors is to equip them with a very wide accumulation register. Rounding or truncation errors occur at the end of processing when the value is multiplied in memory. 
3. ALU – performs logical and arithmetic operations 
4. Shifters – Shift values ​​by bits to the right or left, useful for implementing calculations with “floating point” values

Pipelining 

Pipelining is an extremely important feature of any computing system, the ability to divide the execution of an instruction into stages increases the performance of a system exponentially. The main stages of the execution of an instruction are:
• Fetch - the microprocessor calculates the address of the next instruction and returns an operation code
• Decode - The operation code is interpreted and sent to the unit to which it corresponds 
• Execute - The instruction is executed and the result is written to the registers

![image](https://github.com/user-attachments/assets/97ee2aa0-2768-4c7e-9444-5d88fbc97f72)

Parallel Architectures

Parallel architectures are divided into 2 major categories, both with advantages and disadvantages. They can be classified according to the type of parallelism they practice: Instruction-level parallelism and Data-level parallelism, let's take them one by one:
Instruction-level parallelism, also called (Very long Instruction Word (VLIW)) involves bringing a long word from the code memory, consisting of 8 instructions with a length of 256 bits, these 8 instructions are then divided between 8 different execution units.

![image](https://github.com/user-attachments/assets/8ddcf784-08cc-4934-a98b-fa1e7281b148)

An important advantage is the optimization it offers over a wide range of algorithms, for example: Fast Fourier Transform or Digital Filtering. But any algorithm that involves repetitive instructions will benefit from such an approach to parallel architecture.
Data-level parallelism, also called (Single Input Multiple-Data (SIMD)) involves executing the same instruction on multiple data sets. SIMD architectures are usually easy to use with data packets of different sizes, unlike VLIW architectures. 
The main advantage is the ability to operate with algorithms that require processing large data packets.

![image](https://github.com/user-attachments/assets/5392e69d-c978-4f4e-9038-ad90e9e03a27)

Within the ADI SHARC DSP, SIMD operation mode can be turned on or off as needed. Another unique feature of the ADI TigerSHARC DSP is the combination of both VLIW and SIMD features in a single DSP.

![image](https://github.com/user-attachments/assets/82a422ac-3718-43bb-bd8d-6b5f407cad3a)

Other main subcomponents of the architecture that are worth specifying are:
1. Program Memory / Data memory – both memories are accessible simultaneously thanks to separate BUSes. The memories are organized on 32 bits (resulting from this and the standard size of an instruction: 32 bits). Thanks to DMAC, the memories also allow Block Transfer transfers.
The data memory is of the FIFO type, applying the "Circular Buffering" principle
2. Program Sequencer - an advanced PC counter, responsible for the correct execution of instructions, a task not very simple due to the parallel processing of several blocks or instructions (Pipelining). Also responsible for jumps (caused by interrupts or conditional instructions).
3. AGU'S – address generators, one for each memory, work in parallel for the correct addressing of the data and code memory, respectively. In advanced DSPs they are capable of performing several types of addressing, for example: Direct (Through registers), Indirect (with offset and increment/decrement) and Circular. Operates on 32 bits

Until the next update my target is to begin studying each described component in more detail and to create a hardware description in the Verilog HDL language.




