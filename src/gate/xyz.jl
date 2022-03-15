
struct X <: AbstractSingleQubitGate
    idx::Int
    inverse::Bool
    matrix::Matrix{ComplexF64}
    X(idx) = new(idx, false, [0 1; 1 0])
end

getMatrix(gate::X) = gate.matrix

getCaption(::X) = "X"

struct Y <: AbstractSingleQubitGate
    idx::Int
    inverse::Bool
    matrix::Matrix{ComplexF64}
    Y(idx) = new(idx, false, [0 -im; im 0])
end

getMatrix(gate::Y) = gate.matrix

getCaption(::Y) = "Y"

struct Z <: AbstractSingleQubitGate
    idx::Int
    inverse::Bool
    matrix::Matrix{ComplexF64}
    Z(idx) = new(idx, false, [1 0; 0 -1])
end

getMatrix(gate::Z) = gate.matrix

getCaption(::Z) = "Z"
