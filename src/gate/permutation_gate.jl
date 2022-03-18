
struct PermutationGate <: Gate
    a::Int
    b::Int
    n::Int
    affected::Vector{Int}
    function PermutationGate(a, b, n)
        @assert 1 ≤ a ≤ n
        @assert 1 ≤ b ≤ n
        return new(a, b, n, collect(1:n))
    end
end

getMainQubitIndex(gate::PermutationGate) = gate.a

getIndex1(gate::PermutationGate) = gate.a

getIndex2(gate::PermutationGate) = gate.b

setMainQubitIndex(gate::PermutationGate, idx) = error("Not supported.")

setAdditionalQubit(gate::PermutationGate, idx, cnt) = error("Not supported.")

getAffectedQubitIndexes(gate::PermutationGate) = gate.affected

getHighestAffectedQubitIndex(gate::PermutationGate) = maximum(gate.affected)

getCaption(::PermutationGate) = "P"

getName(::PermutationGate) = "permutation gate"

getGroup(::PermutationGate) = "permutation"

getMatrix(gate::PermutationGate) = error("No matrix required for Permutation")

getSize(::PermutationGate) = 2

setInverse(gate::PermutationGate, v) = nothing

Base.show(io::IO, gate::PermutationGate) = print(io, "Perm ", gate.a, ", ", gate.b)
