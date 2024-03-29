
struct ProbabilitiesGate <: AbstractInformalGate
    affected::Vector{Int}
    mainIndex::Int
    ProbabilitiesGate(idx = 1) = new([idx], idx)
end

getCaption(::ProbabilitiesGate) = "P"

getSize(::ProbabilitiesGate) = -1

getName(::ProbabilitiesGate) = "Probabilities"

setInverse(::ProbabilitiesGate, v) = nothing

Base.show(io::IO, gate::ProbabilitiesGate) =
    print(io, getName(gate), "(idx=", getMainQubitIndex(gate), ")")
