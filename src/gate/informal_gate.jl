
abstract type AbstractInformalGate <: Gate end

struct InformalGate <: AbstractInformalGate
    affected::Vector{Int}
    mainIndex::Int
    InformalGate(idx = 1) = new([idx], idx)
end

setMainQubitIndex(::InformalGate, idx) = nothing

getMainQubitIndex(::InformalGate) = 1

setAdditionalQubit(::InformalGate, idx, cnt) = nothing

getHighestAffectedQubitIndex(gate::InformalGate) = maximum(gate.affected)

getAffectedQubitIndexes(gate::InformalGate) = gate.affected

getGroup(gate::InformalGate) = "informal"

getMatrix(::InformalGate) = ComplexF64[0;;]
