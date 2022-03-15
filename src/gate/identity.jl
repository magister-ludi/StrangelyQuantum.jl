
struct Identity <: AbstractSingleQubitGate
    idx::Int
    inverse::Bool
    matrix::Matrix{ComplexF64}
    Identity(idx = 1) = new(idx, false, [1 0; 0 1])
end

getMatrix(gate::Identity) = gate.matrix

getCaption(::Identity) = "I"
