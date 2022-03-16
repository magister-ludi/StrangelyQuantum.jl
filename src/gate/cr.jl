
mutable struct Cr <: AbstractTwoQubitGate
    first::Int
    second::Int
    highest::Int
    inverse::Bool
    matrix::Matrix{ComplexF64}
    pow::Int
    function Cr(a, b, exp)
        ai, ar = sincos(exp)
        if abs(π - exp) < 1e-6
            ar = -1.0
            ai = 0.0
        elseif abs(π / 2 - exp) < 1e-6
            ar = 0.0
            ai = 1.0
        end

        matrix = [
            1 0 0 0
            0 1 0 0
            0 0 1 0
            0 0 0 ComplexF64(ar, ai)
        ]
        return new(a, b, max(a, b), false, matrix, -1)
    end
end

function Cr(a, b, base, pow)
    gate = Cr(a, b, 2π / (base^pow))
    gate.pow = pow
    return gate
end

getMatrix(gate::Cr) = gate.matrix

function setInverse(gate::Cr, inv)
    if inv
        gate.matrix .= gate.matrix'
    end
end

getCaption(gate::Cr) = string("Cr", gate.pow > -1 ? gate.pow : "th")
