
mutable struct Oracle <: Gate
    mainQubit::Int
    affected::Vector{Int}
    caption::String
    span::Int
    matrix::Matrix{ComplexF64}
    Oracle(i::Integer) = new(i, [], "Oracle", 1)
end

function Oracle(matrix::AbstractMatrix{<:Complex})
    gate = Oracle(1)
    gate.matrix = matrix
    span = trunc(Int, log2(size(matrix, 1)))
    for i = 1:span
        setAdditionalQubit(gate, i, i)
    end
    return gate
end

getSize(gate::Oracle) = gate.span

setCaption(gate::Oracle, c) = gate.caption = c

setMainQubitIndex(gate::Oracle, idx) = gate.mainQubit = 1

getMainQubitIndex(gate::Oracle) = gate.mainQubit

setAdditionalQubit(gate::Oracle, idx, cnt) = push!(gate.affected, idx)

getQubits(gate::Oracle) = gate.span

getAffectedQubitIndexes(gate::Oracle) = gate.affected

getHighestAffectedQubitIndex(gate::Oracle) = maximum(getAffectedQubitIndexes(gate))

getCaption(gate::Oracle) = gate.caption

getName(::Oracle) = "Oracle"

getGroup(::Oracle) = "Oracle"

getMatrix(gate::Oracle) = gate.matrix

function setInverse(gate::Oracle, inv)
    if inv
        gate.matrix = gate.matrix'
    end
end
