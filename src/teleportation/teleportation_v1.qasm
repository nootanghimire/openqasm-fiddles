OPENQASM 2.0;
include "qelib1.inc";
qreg q[3];
creg c0[1];
creg c1[1];
creg ans[1];

// Apply a not gate to q[2]
x q[2];

// Entangle q[0] and q[1]
h q[0];
cx q[0], q[1];

barrier q;
// q[2] is the data
// q[0] is what Alice has
// q[1] is what bot has
cx q[2], q[0];
h q[2];

// This means that we have now measured the classical bit that we can send to Bob, which can use this information to get the state that q[2] was in by reconstructing it 
measure q[2] -> c1[0];
measure q[0] -> c0[0];

barrier q;

// On Bob side

// X . Ebit if lsb is 1
// Z . Ebit if msb is 1
if (c0 == 1) x q[1];
if (c1 == 1) z q[1];
// cx c0[0], q[1];
// Should be zero.
// Try Running q[2] through other gates, and see the effect on this measurement
measure q[1] -> ans[0];
