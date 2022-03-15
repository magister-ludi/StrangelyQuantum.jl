
struct Toffoli <: AbstractThreeQubitGate
    first::Int
    second::Int
    third::Int
    matrix::Matrix{ComplexF64}
    Toffoli(a, b, c) = new(
        a,
        b,
        c,
        [
            1 0 0 0 0 0 0 0
            0 1 0 0 0 0 0 0
            0 0 1 0 0 0 0 0
            0 0 0 1 0 0 0 0
            0 0 0 0 1 0 0 0
            0 0 0 0 0 1 0 0
            0 0 0 0 0 0 0 1
            0 0 0 0 0 0 1 0
        ],
    )
end

getMatrix(gate::Toffoli) = gate.matrix

setInverse(::Toffoli, v) = nothing

getCaption(::Toffoli) = "CCnot"
