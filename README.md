# -Upsampling-and-Filtering-for-a-64QAM-modulator
Create the Verilog RTL for the combined upsampling and filtering blocks of the modulator Upsampler specs: Upsample rate: x13 Zero padding Clock rate: 108.333 MHz Input symbol rate: 8.333 sym/sec Input data width: 4-bit Output data width: 4-bit Filter specs: x[n] data width: 4-bit Coefficients data width: 8-bit Output data width: 12-bit FIR structure 71 total coefficients – need to be stored in registers with filter module Clock rate: 108.333 MHz 
Upsampler Module
Specification: The upsampler should increase the input symbol rate by a factor of 13 through zero-padding, meaning for every input symbol, 12 zeros are inserted between symbols.
Filter Module
Specification: Implement a FIR filter with 71 coefficients, x[n] input data width of 4 bits, coefficient width of 8 bits, and an output data width of 12 bits.
My Implementation:
Zero Padding: Implemented zero-padding logic, possibly using a counter to manage the insertion of zeros between symbols.
Register Array for Coefficients: Design a 71-address register array to store the filter coefficients. This could be initialized with a parameter array or loaded dynamically.
FIR Logic: Implement the FIR filter logic using the DSP slice module designed earlier. Use a generate block to instantiate 71 DSP slices, connecting them according to the FIR structure.
