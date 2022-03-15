
#=
A Gate that operates on two qubits. In a single
`Step`, there should not be two Gates that act on the same qubit.
=#
abstract type AbstractTwoQubitGate <: Gate end

struct TwoQubitGate <: AbstractTwoQubitGate
    first::Int
    second::Int
    highest::Int
    inverse::Bool
    TwoQubitGate(first, second) = new(first, second, max(first, second, false))
end

setMainQubitIndex(gate::AbstractTwoQubitGate, idx) = gate.first = idx

getMainQubitIndex(gate::AbstractTwoQubitGate) = gate.first

setAdditionalQubit(gate::AbstractTwoQubitGate, idx, cnt) = gate.second = idx

getSecondQubitIndex(gate::AbstractTwoQubitGate) = gate.second

setHighestAffectedQubitIndex(gate::AbstractTwoQubitGate, v) = gate.highest = v

getAffectedQubitIndexes(gate::AbstractTwoQubitGate) = [gate.first, gate.second]

getHighestAffectedQubitIndex(gate::AbstractTwoQubitGate) = gate.highest

getName(gate::AbstractTwoQubitGate) = replace(string(typeof(gate)), r"^.*\." => "")

getCaption(gate::AbstractTwoQubitGate) = getName(gate)

getGroup(::AbstractTwoQubitGate) = "TwoQubit"

getSize(::AbstractTwoQubitGate) = 2

function setInverse(gate::AbstractTwoQubitGate, v)
    gate.inverse = v
end

Base.show(io::IO, gate::AbstractTwoQubitGate) = print(
    io,
    "Gate acting on qubits ",
    gate.first,
    " and ",
    gate.second,
    " and caption ",
    getCaption(gate),
)
