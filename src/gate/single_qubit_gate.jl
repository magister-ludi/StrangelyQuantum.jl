
abstract type AbstractSingleQubitGate <: Gate end

struct SingleQubitGate <: AbstractSingleQubitGate
    idx::Int
    inverse::Bool
    SingleQubitGate(idx) = new(idx, false)
end

getMainQubitIndex(gate::AbstractSingleQubitGate) = gate.idx

setAdditionalQubit(::AbstractSingleQubitGate, idx, cnt) =
    error("An AbstractSingleQubitGate can not have additional qubits")

getAffectedQubitIndexes(gate::AbstractSingleQubitGate) = [gate.idx]

getHighestAffectedQubitIndex(gate::AbstractSingleQubitGate) = gate.idx

getName(gate::AbstractSingleQubitGate) = replace(string(typeof(gate)), r"^.+\." => "")

getCaption(gate::AbstractSingleQubitGate) = getName(gate)

getGroup(::AbstractSingleQubitGate) = "SingleQubit"

getSize(::AbstractSingleQubitGate) = 1

getMatrix(::AbstractSingleQubitGate) = nothing

_setInverse(gate::AbstractSingleQubitGate, v) = gate.inverse = v

setInverse(gate::AbstractSingleQubitGate, v) = _setInverse(gate, v)

Base.show(io::IO, gate::AbstractSingleQubitGate) =
    print(io, "Gate with index ", gate.idx, " and caption ", getCaption(gate))
