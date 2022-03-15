
struct Cnot <: AbstractTwoQubitGate
    first::Int
    second::Int
    highest::Int
    inverse::Bool
    matrix::Matrix{ComplexF64}
    Cnot(a, b) = new(
        a,
        b,
        max(a, b),
        false,
        [
            1 0 0 0
            0 1 0 0
            0 0 0 1
            0 0 1 0
        ],
    )
end

getMatrix(gate::Cnot) = gate.matrix

getCaption(::Cnot) = "Cnot"
