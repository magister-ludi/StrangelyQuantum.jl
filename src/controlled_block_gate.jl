
abstract type AbstractControlledBlockGate <: AbstractBlockGate end

mutable struct ControlledBlockGate <: AbstractControlledBlockGate
    block::Block
    idx::Int
    inverse::Bool
    control::Int
    high::Int
    haq::Int
    low::Int
    matrix::Union{Nothing, Matrix{ComplexF64}}
    size::Int
    function ControlledBlockGate(block, idx, control)
        if control > idx
            haq = idx + getNQubits(block)
        else
            haq = idx + getNQubits(block) - 1
        end
        return new(block, idx, false, control, -1, haq, 0, nothing)
    end
end

ControlledBlockGate(bg::AbstractBlockGate, idx, control) =
    ControlledBlockGate(getBlock(bg), idx, control)

function getAffectedQubitIndexes(gate::AbstractControlledBlockGate)
    answer = _getAffectedQubitIndexes(gate)
    push!(answer, gate.control)
    return answer
end

function getHighestAffectedQubitIndex(gate::AbstractControlledBlockGate)
    high < 0 && calculateHighLow(gate)
    return gate.haq
end

getCaption(::AbstractControlledBlockGate) = "CB"

getName(::AbstractControlledBlockGate) = "CBlockGate"

getGroup(::AbstractControlledBlockGate) = "CBlockGroup"

getControlQubit(gate::AbstractControlledBlockGate) = gate.control

function calculateHighLow(gate::AbstractControlledBlockGate)
    gate.high = gate.control
    gap = gate.control - gate.idx
    bs = getNQubits(gate.block)
    gate.low = 0
    if gate.control > gate.idx
        gate.low = gate.idx
        if gap < bs
            error(
                "Can't have control at $(gate.control) for gate with size $bs starting at $(gate.idx)",
            )
        end
        if gap > bs
            gate.high = gate.control
        end
    else
        gate.low = gate.control
        gate.high = gate.idx + bs - 1
    end

    gate.size = gate.high - gate.low + 1
end

getLow(gate::AbstractControlledBlockGate) = gate.low

correctHigh(gate::AbstractControlledBlockGate, h) = gate.high = h

function getMatrix(gate::AbstractControlledBlockGate)
    if gate.matrix === nothing
        gmlow = 0
        gate.high = gate.control
        gate.size = _getSize(gate) + 1
        gap = gate.control - gate.idx
        perm = PermutationGate[]
        bs = getNQubits(gate.block)
        if gate.control > gate.idx
            if gap < bs
                error(
                    "Can't have control at $(gate.control) for gate with size $bs starting at $(gate.idx)",
                )
            end

            gmlow = gate.idx
            if gap > bs
                gate.high = gate.control
                size = gate.high - gmlow + 1
                pg = PermutationGate(
                    gate.control - gmlow,
                    gate.control - gmlow - gap + bs,
                    gate.size,
                )
                push!(perm, pg)
            end
        else
            gmlow = gate.control
            gate.high = gate.idx + bs - 1
            gate.size = gate.high - gmlow + 1
            for i = 1:(size - 1)
                pg = PermutationGate(i, i + 1, size)
                pushfirst!(perm, pg)
            end
        end

        part = getMatrix(gate.block)
        dim = length(part)
        gate.matrix = Matrix{ComplexF64}(I, 2 * dim, 2 * dim)
        for i = 1:dim
            for j = 1:dim
                gate.matrix[i + dim, j + dim] = part[i, j]
            end
        end
    else
        #System.err.println("Matrix was cached")
    end
    return gate.matrix
end

hasOptimization(::AbstractControlledBlockGate) = true

function applyOptimize(gate::AbstractControlledBlockGate, v)
    size = length(v)
    answer = Vector{ComplexF64}(undef, size)
    dim = size ÷ 2
    oldv = Vector{ComplexF64}(undef, dim)
    for i = 1:dim
        oldv[i] = v[i + dim]
    end
    p2 = applyOptimize(block, oldv, gate.inverse)
    for i = 1:dim
        answer[i] = v[i]
        answer[dim + i] = p2[i]
    end
    return answer
end

getSize(gate::AbstractControlledBlockGate) = getNQubits(gate.block) + 1

function Base.show(io::IO, gate::AbstractControlledBlockGate)
    print(io, "ControlledGate for ")
    _show(io, gate)
end
