
struct Cz <: AbstractTwoQubitGate
    first::Int
    second::Int
    highest::Int
    inverse::Bool
    matrix::Matrix{ComplexF64}
    Cz(a, b) = new(
        a,
        b,
        max(a, b),
        false,
        [
            1 0 0 0
            0 1 0 0
            0 0 1 0
            0 0 0 -1
        ],
    )
end

getMatrix(gate::Cz) = gate.matrix

getCaption(::Cz) = "Cz"
