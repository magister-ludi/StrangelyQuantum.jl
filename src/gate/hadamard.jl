
struct Hadamard <: AbstractSingleQubitGate
    idx::Int
    inverse::Bool
    matrix::Matrix{ComplexF64}
    Hadamard(idx) = new(idx, false, [HC HC; HC HCN])
end

getMatrix(gate::Hadamard) = gate.matrix

getCaption(::Hadamard) = "H"
