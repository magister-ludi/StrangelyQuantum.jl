
abstract type AbstractInformalGate <: Gate end

struct InformalGate <: AbstractInformalGate
    affected::Vector{Int}
    mainIndex::Int
    InformalGate(idx = 1) = new([idx], idx)
end

setMainQubitIndex(::AbstractInformalGate, idx) = nothing

getMainQubitIndex(::AbstractInformalGate) = 1

setAdditionalQubit(::AbstractInformalGate, idx, cnt) = nothing

getHighestAffectedQubitIndex(gate::AbstractInformalGate) = maximum(gate.affected)

getAffectedQubitIndexes(gate::AbstractInformalGate) = gate.affected

getGroup(gate::AbstractInformalGate) = "informal"

getMatrix(::AbstractInformalGate) = ComplexF64[0;;]
