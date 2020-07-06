OPENQASM 2.0;
include "qelib1.inc";

// Init 4-bit quantum register
qreg q[4];

// Init 2 bit classical register to measure value into
creg c[2];

// Bit 1 of information needed to be encoded
creg d1[1];
// Bit 2 of information needed to be encoded
creg d2[1];

// Entangle two qubits, so that their state looks like ((|00> + |11>)/sqrt(2)) 
// Which can be performed by running first wire (q[0]) through hadamard gate,
// and applying CNOT with q[0] as control and q[1] as target
h q[0];
cx q[0],q[1];


// Add barrier so that the transpiler does not try to combine gates, etc..
barrier q[0];
barrier q[1];


// measure Use q[2] and (NOT . q[3]) to d1 and d2, so that I can assign value to classical bits
// I did this because I didn't know how to assign input to classical registers,  you can change this
// depending on what data you want to send. 
x q[3];
measure q[2] -> d1[0];
measure q[3] -> d2[0];

// Add barrier just for (maybe un-necessary) precaution
barrier q[2];
barrier q[3];

// Apply x transformation if last bit is 1, and z if the first bit is 1. 
if (d2 == 1) x q[0];
if (d1 == 1) z q[0];

// Add barrier as we have completed encoding the e-bit that ALICE has
barrier q[0];
barrier q[1];

// ... q[0] is sent to BOB, q[1] is with him already

// Apply cnot and hamarard gate to decode the information sent
cx q[0], q[1];
h q[0];

// Measure the value of quantum bits to the classical bits, (irreversible) 
// Try changing input (the measure q[n] -> dN[0] and see if the information is preserved.
measure q[0] -> c[0];
measure q[1] -> c[1];
