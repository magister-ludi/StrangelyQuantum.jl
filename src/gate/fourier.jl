
abstract type AbstractFourier <: AbstractBlockGate end

mutable struct Fourier <: AbstractFourier
    block::Block
    idx::Int
    inverse::Bool
    dim::Int
    size::Int
    matrix::Union{Nothing, Matrix{ComplexF64}}
    Fourier(name, dim, idx) = new(Block(name, dim), idx, false, dim, 1 << dim, nothing)
end

Fourier(dim, idx) = Fourier("Fourier", dim, idx)

function getMatrix(gate::AbstractFourier)
    if gate.matrix === nothing
        omega = 2π / gate.size
        den = sqrt(gate.size)
        gate.matrix = Matrix{ComplexF64}(undef, gate.size, gate.size)
        for i = 1:(gate.size)
            for j = i:(gate.size)
                alpha = omega * (i - 1) * (j - 1)
                s, c = sincos(alpha)
                gate.matrix[i, j] = ComplexF64(c / den, s / den)
                if i != j
                    gate.matrix[j, i] = gate.matrix[i, j]
                end
            end
        end
    end
    return gate.matrix
end

function setInverse(gate::AbstractFourier, v)
    if v
        m = getMatrix(gate)
        gate.matrix .= m'
    end
end

function inverse(gate::AbstractFourier)
    m = getMatrix(gate)
    gate.matrix .= m'
    return gate
end

#getAffectedQubitIndexes(gate::AbstractFourier)=
#    collect(gate.idx:gate.idx+gate.dim)

getHighestAffectedQubitIndex(gate::AbstractFourier) = gate.dim + gate.idx - 1

hasOptimization(::AbstractFourier) = false      # for now, we calculate the matrix

mutable struct InvFourier <: AbstractFourier
    block::Block
    idx::Int
    inverse::Bool
    dim::Int
    size::Int
    matrix::Union{Nothing, Matrix{ComplexF64}}
    InvFourier(name, dim, idx) = new(Block(name, dim), idx, false, dim, 1 << dim, nothing)
end

InvFourier(size, idx) = InvFourier("InvFourier", size, idx)

function getMatrix(gate::InvFourier)
    if gate.matrix === nothing
        omega = 2π / gate.size
        den = sqrt(gate.size)
        gate.matrix = Matrix{ComplexF64}(undef, gate.size, gate.size)
        for i = 1:(gate.size)
            for j = i:(gate.size)
                alpha = omega * (i - 1) * (j - 1)
                tpd = trunc(Int, alpha / (2π))
                if tpd > 0
                    alpha -= 2π * tpd
                end

                ai, ar = sincos(alpha)
                if abs(alpha) < 1e-6
                    ar = 1.0
                    ai = 0.0
                elseif abs(π - alpha) < 1e-6
                    ar = -1.0
                    ai = 0.0
                elseif abs(π / 2 - alpha) < 1e-6
                    ar = 0.0
                    ai = 1.0
                elseif abs(3 * π / 2 - alpha) < 1e-6
                    ar = 0.0
                    ai = -1.0
                end

                gate.matrix[i, j] = ComplexF64(ar / den, -ai / den)
                if i != j
                    gate.matrix[j, i] = gate.matrix[i, j]
                end
            end
        end
    end
    return gate.matrix
end
