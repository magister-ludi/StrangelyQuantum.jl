
module StrangelyQuantum

using Dates
using LinearAlgebra
using Printf
using Random

export Classic, Block, Gate, AbstractBlockGate, BlockGate, ControlledBlockGate, Add, AddInteger
export AddIntegerModulus, AddModulus, Cnot, Cr, Cz, Fourier, Hadamard
export Identity, InformalGate, InvFourier, Measurement, Mul, MulModulus
export Oracle, PermutationGate, ProbabilitiesGate, R, Rotation, RotationX
export RotationY, RotationZ, SingleQubitGate, SingleQubitMatrixGate, Swap
export ThreeQubitGate, Toffoli, TwoQubitGate, X, Y, Z
export QuantumExecutionEnvironment, SimpleQuantumExecutionEnvironment
export Program, Qubit, Result, Step

export addGate, addGates, addStep, addSteps, applyOptimize
export calculateHighLow, calculateNewState, calculateQubitStates
export calculateStepMatrix, correctHigh, createBlock, createIdentity
export createPermutationMatrix, dbg, decomposeStep, findPeriod, fraction
export getAffectedQubitIndexes, getBlock, getCaption, getComplexStep
export getControlQubit, getDecomposedSteps, getGates, getGroup
export getHighestAffectedQubitIndex, getIndex, getIndex1, getIndex2
export getInitialAlphas, getIntermediateProbability, getIntermediateQubits
export getInverseModulus, getLow, getMainQubit, getMainQubitIndex, getMatrix
export getMeasuredProbability, getName, getNQubits, getNumberQubits, getProbability
export getProgram, getQubits, getResult, getSecondQubit, getSecondQubitIndex
export getSize, getSteps, getThirdQubit, getType, hasOptimization
export initializeQubit, inverse, isInformal, measure, measureSystem
export mmul, permutate, permutate0, permutateVector, printArray, printInfo
export printMemory, qfactor, qsum, randomBit, removeGate, runProgram
export search, searchProbabilities, setAdditionalQubit, setCaption
export setComplexStep, setDecomposedSteps, setHighestAffectedQubitIndex
export setIndex, setInformalStep, setIntermediateProbability, setInverse
export setMainQubitIndex, setMeasuredValue, setProbability, setProgram
export setQuantumExecutionEnvironment, setResult

const StrangeRNG = Xoshiro()
const HV = 1 / sqrt(2)
const HC = HV + 0.0im
const HCN = -HV + 0.0im

function __init__()
    Random.seed!(StrangeRNG, reinterpret(Int64,datetime2unix(now())))
end

abstract type AbstractProgram end
"""
A `QuantumExecutionEnvironment` is and abstract type.
Concrete subtypes are expected to provide

`Result` runProgram(qee(<:`QuantumExecutionEnvironment`), p::`Program`)

that will execute program `p`, returning a `Result`.
This probability
vector is well defined: every invocation of this method with the same
`Program p` will return a `Result` instance that has
the same probability vector.
Every invocation of `runProgram`, or of the `measureSystem(::Result)` method
may result in different values for `measuredValue` for the qubits in `Result`.
"""
abstract type QuantumExecutionEnvironment end

include("gate.jl")
include("step.jl")
include("qubit.jl")
include("result.jl")

include("program.jl")
include("block.jl")

include("gate/oracle.jl")
include("gate/permutation_gate.jl")

include("gate/informal_gate.jl")
include("gate/probabilities_gate.jl")

include("gate/single_qubit_gate.jl")
include("gate/hadamard.jl")
include("gate/identity.jl")
include("gate/measurement.jl")
include("gate/r.jl")
include("gate/rotation.jl")
include("gate/single_qubit_matrix_gate.jl")
include("gate/xyz.jl")

include("gate/two_qubit_gate.jl")
include("gate/cnot.jl")
include("gate/cr.jl")
include("gate/cz.jl")
include("gate/swap.jl")

include("gate/three_qubit_gate.jl")
include("gate/toffoli.jl")

include("block_gate.jl")
include("controlled_block_gate.jl")
include("gate/add.jl")
include("gate/add_integer.jl")
include("gate/add_integer_modulus.jl")
include("gate/add_modulus.jl")
include("gate/fourier.jl")
include("gate/mul.jl")
include("gate/mul_modulus.jl")

include("complex.jl")
include("local/simple_quantum_execution_environment.jl")
include("algorithm/classic.jl")
include("local/computations.jl")

end # module
