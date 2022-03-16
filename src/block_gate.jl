
abstract type AbstractBlockGate <: Gate end

mutable struct BlockGate <: AbstractBlockGate
    block::Block
    idx::Int
    inverse::Bool
    BlockGate(block, idx) = new(block, idx, false)
end

setBlock(gate::AbstractBlockGate, b) = gate.block = b

getBlock(gate::AbstractBlockGate) = gate.block

setIndex(gate::AbstractBlockGate, idx) = gate.idx = idx

setMainQubitIndex(gate::AbstractBlockGate, idx) = error("Not supported.")

getMainQubitIndex(gate::AbstractBlockGate) = gate.idx

setAdditionalQubit(gate::AbstractBlockGate, idx, cnt) = error("Not supported.")

_getAffectedQubitIndexes(gate::AbstractBlockGate) =
    collect((gate.idx):getHighestAffectedQubitIndex(gate))

getAffectedQubitIndexes(gate::AbstractBlockGate) = _getAffectedQubitIndexes(gate)

getHighestAffectedQubitIndex(gate::AbstractBlockGate) = gate.idx + getNQubits(gate.block) - 1

getCaption(::AbstractBlockGate) = "B"

getName(::AbstractBlockGate) = "BlockGate"

getGroup(::AbstractBlockGate) = "BlockGroup"

function getMatrix(gate::AbstractBlockGate)
    answer = getMatrix(gate.block)
    if gate.inverse
        answer = answer'
    end
    return answer
end

setInverse(gate::AbstractBlockGate, inv) = gate.inverse = inv

function inverse(gate::AbstractBlockGate)
    setInverse(gate, !gate.inverse)
    return gate
end

_getSize(gate::AbstractBlockGate) = getNQubits(gate.block)

getSize(gate::AbstractBlockGate) = _getSize(gate)

hasOptimization(::AbstractBlockGate) = true

applyOptimize(gate::AbstractBlockGate, v) = applyOptimize(gate.block, v, gate.inverse)

_show(io::IO, gate::AbstractBlockGate) =
    print(io, "Gate for block ", gate.block, ", size = ", getSize(gate), ", inv = ", gate.inverse)

Base.show(io::IO, gate::AbstractBlockGate) = _show(io, gate)
