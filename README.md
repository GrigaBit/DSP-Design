# DSP-Design
Through this project I aim to continue my learning within hardware architectures and to start exploring the world of digital signal processing. I aim to provide a weekly update highlighting the new things learned.


Update #1 :
Being the first update, it's not even a week since I started the documentation. Being impatient to "launch" this project online, I chose to write this after only 3 hours of work.

The main objectives of the project are the following:[Uploading CircularBuffer.v…]()

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

I also writed the code for the circular buffer module .
