
struct Swap <: AbstractTwoQubitGate
    first::Int
    second::Int
    highest::Int
    inverse::Bool
    matrix::Matrix{ComplexF64}
    Swap(a, b) = new(
        a,
        b,
        max(a, b),
        false,
        [
            1 0 0 0
            0 0 1 0
            0 1 0 0
            0 0 0 1
        ],
    )
end

Swap() = Swap(1, 1)

getMatrix(gate::Swap) = gate.matrix

getCaption(::Swap) = "S"
