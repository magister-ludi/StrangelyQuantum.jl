
mutable struct SingleQubitMatrixGate <: AbstractSingleQubitGate
    idx::Int
    inverse::Bool
    matrix::Matrix{ComplexF64}
    SingleQubitMatrixGate(idx, m) = new(idx, false, m)
end

getMatrix(gate::SingleQubitMatrixGate) = gate.matrix

function setInverse(gate::SingleQubitMatrixGate, v)
    _setInverse(gate, v)
    gate.matrix .= gate.matrix'
end

Base.show(io::IO, gate::SingleQubitMatrixGate) =
    print(io, "SingleQubitMatrixGate with index ", gate.idx)
