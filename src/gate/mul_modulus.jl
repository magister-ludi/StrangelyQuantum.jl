
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
    MulModulus(x0, x1, mul, mod) = new(createBlock(MulModulus, x0, x1, mul, mod), x0, false)
end

function createBlock(::Type{MulModulus}, x0, x1, mul, modulus)
    x1 -= x0 - 1
    x0 = 1
    n = x1 - x0 + 1
    answer = Block("MulModulus", 2 * n + 2)
    for i = 1:n
        fct = 1 << (i - 1)
        m = mod(mul * fct, modulus)
        add = AddIntegerModulus(x0, x1 + 1, m, modulus)
        cbg = ControlledBlockGate(add, n + 1, i)
        addStep(answer, Step(cbg))
    end
    for i = x0:x1
        addStep(answer, Step(Swap(i, i + n)))
    end
    invmul = getInverseModulus(mul, modulus)
    for i = 1:n
        fct = 1 << (i - 1)
        m = mod(invmul * fct, modulus)
        add = AddIntegerModulus(x0, x1 + 1, m, modulus)
        cbg = ControlledBlockGate(add, n + 1, i)
        setInverse(cbg, true)
        addStep(answer, Step(cbg))
    end
    return answer
end
