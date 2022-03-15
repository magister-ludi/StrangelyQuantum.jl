
struct MulModulus <: AbstractBlockGate
    block::Block
    idx::Int
    inverse::Bool
    #=
    Multiply the qubit in the x register with an integer mul
    x_0 ----- x_0 * mul (n qubits in and out)
    x_n-1 ----- x_1-1 * mul
    y_0 ----- 0 ( n + 2 qubits needed for addintmon)
    y_n+1 ----- 0
    =#
    MulModulus(x0, x1, mul, mod) = new(createBlock(0, x1 - x0, mul, mod), x0, false)
end

function createBlock(::Type{Mul}, y0, y1, mul, mod)
    x0 = y0
    x1 = y1 - y0
    size = x1 - x0 + 1
    n = size
    answer = Block("MulModulus", 2 * size + 2)
    for i = 1:n
        m = (mul * (1 << i)) % mod
        add = AddIntegerModulus(x0, x1 + 1, m, mod)
        cbg = AbstractControlledBlockGate(add, n, i)
        addStep(answer, Step(cbg))
    end
    for i = x0:x1
        addStep(answer, Step(Swap(i, i + size)))
    end
    invmul = getInverseModulus(mul, mod)
    for i = 1:n
        m = (invmul * (1 << i)) % mod
        add = AddIntegerModulus(x0, x1 + 1, m, mod)
        cbg = AbstractControlledBlockGate(add, n, i)
        setInverse(cbg, true)
        addStep(answer, Step(cbg))
    end
    return answer
end
