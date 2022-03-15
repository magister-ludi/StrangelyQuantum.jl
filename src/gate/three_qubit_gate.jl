
#=
A Gate that operates on three qubits. In a single
`Step`, there should not be two Gates that act on the same qubit.
@author johan
@version $Id: $Id
 =#
abstract type AbstractThreeQubitGate <: Gate end

struct ThreeQubitGate <: AbstractThreeQubitGate
    first::Int
    second::Int
    third::Int
    AbstractThreeQubitGate(first, second, third) = new(first, second, third)
end

setMainQubitIndex(gate::AbstractThreeQubitGate, idx) = gate.first = idx

getMainQubitIndex(gate::AbstractThreeQubitGate) = gate.first

getSize(::AbstractThreeQubitGate) = 3

function setAdditionalQubit(gate::AbstractThreeQubitGate, idx, cnt)
    if cnt < 1 || cnt > 2
        error("Can't set qubit $cnt as additional on a three qubit gate")
    end
    if cnt == 1
        gate.second = idx
    elseif cnt == 2
        gate.third = idx
    end
end

getMainQubit(gate::AbstractThreeQubitGate) = gate.first

getSecondQubit(gate::AbstractThreeQubitGate) = gate.second

getThirdQubit(gate::AbstractThreeQubitGate) = gate.third

getAffectedQubitIndexes(gate::AbstractThreeQubitGate) = [gate.first, gate.second, gate.third]

getHighestAffectedQubitIndex(gate::AbstractThreeQubitGate) = maximum(getAffectedQubitIndexes(gate))

getName(gate::AbstractThreeQubitGate) = replace(string(typeof(gate)), r"^.*\." => "")

getCaption(gate::AbstractThreeQubitGate) = getName(gate)

getGroup(::AbstractThreeQubitGate) = "ThreeQubit"

Base.show(io::IO, gate::AbstractThreeQubitGate) = print(
    io,
    "Gate acting on qubits ",
    gate.first,
    ", ",
    gate.second,
    " and ",
    gate.third,
    " and caption ",
    getCaption(gate),
)
