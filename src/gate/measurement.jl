
mutable struct Measurement <: AbstractSingleQubitGate
    idx::Int
    inverse::Bool
    matrix::Matrix{ComplexF64}
    Measurement(idx) = new(idx, false, [1 0; 0 1])
end

getMatrix(gate::Measurement) = gate.matrix

getCaption(::Measurement) = "M"
