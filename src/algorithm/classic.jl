
const qee = Ref{QuantumExecutionEnvironment}(SimpleQuantumExecutionEnvironment())

setQuantumExecutionEnvironment(val::QuantumExecutionEnvironment) = qee[] = val

function randomBit()
    program = Program(1, Step(Hadamard(1)))
    result = runProgram(qee[], program)
    qubits = getQubits(result)
    return measure(qubits[1])
end

"""
    qsum(a::Integer, b::Integer)
Use a quantum addition algorithm to compute the sum of `a` and `b`.
"""
function qsum(a::Integer, b::Integer)
    y = a > b ? a : b
    x = a > b ? b : a
    m = y < 2 ? 1 : 1 + ceil(Int, log2(y))
    n = x < 2 ? 1 : 1 + ceil(Int, log2(x))
    program = Program(m + n)
    prep = Step()
    y0 = y
    for i = 1:m
        p = 1 << (m - i - 2)
        if y0 >= p
            addGate(prep, X(m - i - 2))
            y0 -= p
        end
    end
    x0 = x
    for i = 1:n
        p = 1 << (n - i - 2)
        if x0 >= p
            addGate(prep, X(m + n - i - 2))
            x0 -= p
        end
    end
    addStep(program, prep)
    addStep(program, Step(Fourier(m, 1)))
    for i = 1:m
        for j = 1:(m - i)
            cr0 = 2 * m - j - i - 2
            if cr0 ≤ m + n
                s = Step(Cr(i, cr0, 2, 1 + j))
                addStep(program, s)
            end
        end
    end
    addStep(program, Step(InvFourier(m, 1)))
    res = runProgram(qee[], program)
    qubits = getQubits(res)
    answer = 0
    for i = 1:m
        if measure(qubits[i]) == 1
            answer += (1 << (i - 1))
        end
    end
    return answer
end

"""
    search(func::Function, list::AbstractVector{T}) where {T}
Apply Grover's search algorithm to find the element `list`
that would evaluate the provided function to 1
`func` is a function that, when evaluated, returns 0 for all
elements except for the element that this method returns, which evaluation
leads to 1.
Return the single element from the provided list that, when evaluated
by the function, returns 1.
"""
function search(func::Function, list::AbstractVector{T}) where {T}
    probability = searchProbabilities(func, list)
    wv, winner = findmax(probability)
    println(stderr, "winner = ", winner, " with prob ", wv)
    return list[winner]
end

"""
Apply Grover's search algorithm to find the element from `list`
that would evaluate the provided function to 1
`func` is a function that, when evaluated, returns 0 for all
elements except for the element that this method returns, which evaluation
leads to 1.
Return the single element from the provided list that, when evaluated
by the function, returns 1.
"""
function searchProbabilities(func::Function, list::AbstractVector{T}) where {T}
    size = length(list)
    n = ceil(Int, log2(size))
    nn = 1 << n
    cnt = π * sqrt(nn) / 4

    oracle = createGroverOracle(func, n, list)
    p = Program(n)
    s0 = Step()
    for i = 1:n
        addGate(s0, Hadamard(i))
    end
    addStep(p, s0)
    setCaption(oracle, "O")
    dif = createDiffMatrix(n)
    difOracle = Oracle(dif)
    setCaption(difOracle, "D")
    for i = 2:cnt
        s1 = Step("Oracle $i")
        addGate(s1, oracle)
        s2 = Step("Diffusion $i")
        addGate(s2, difOracle)
        s3 = Step("Prob $i")
        addGate(s3, ProbabilitiesGate(1))
        addSteps(p, s1, s2, s3)
    end
    println(" n = ", n, ", steps = ", cnt)

    res = runProgram(qee[], p)
    probability = getProbability(res)
    return abs2.(probability)
end

"""
    findPeriod( a::Integer,  nn::Integer)
Find the periodicity of a^x mod nn
"""
function findPeriod(a::Integer, mod::Integer)
    maxtries = 2
    tries = 0
    p = 0
    while p == 0 && tries < maxtries
        p = measurePeriod(a, mod)
        if p == 0
            println(stderr, "We measured a periodicity of 0, and have to start over.")
        end
    end
    p == 0 && return -1
    return fraction(p, mod)
end

function qfactor(nn::Integer)
    nn = Int(nn)
    println("We need to factor ", nn)
    a = 1 + trunc(Int, (nn - 1) * rand(StrangeRNG))
    println("Pick a random number a, a < nn: ", a)
    gcdan = gcd(nn, a)
    println("calculate gcd(a, nn):", gcdan)
    gcdan != 1 && return gcdan

    p = findPeriod(a, nn)
    if p == -1
        println(stderr, "After too many tries with ", a, ", we need to pick a new random number.")
        return qfactor(nn)
    end

    println("period of f = ", p)
    if isodd(p)
        println("bummer, odd period, restart.")
        return qfactor(nn)
    end

    md = trunc(Int, a^(p ÷ 2) + 1)
    m2 = md % nn
    if m2 == 0
        println("bummer, m^p/2 + 1 = 0 mod nn, restart")
        return qfactor(nn)
    end

    f2 = trunc(Int, a^(p ÷ 2)) - 1
    factor = gcd(nn, f2)
    return factor
end

function measurePeriod(a::Integer, mod::Integer)
    len = ceil(Int, log2(mod))
    offset = len
    p = Program(2 * len + 2 + offset)
    prep = Step()
    for i = 1:offset
        addGate(prep, Hadamard(i))
    end
    prepAnc = Step(X(offset + 1))
    addStep(p, prep)
    addStep(p, prepAnc)
    for i = len:-1:(len - offset)
        m = 1
        for _ = 1:((1 << (i - 1)) + 1)
            m = m * a % mod
        end
        mul = MulModulus(len + 1, 2 * len, m, mod)
        cbg = AbstractControlledBlockGate(mul + 1, offset, i)
        addStep(p, Step(cbg))
    end
    addStep(p, Step(InvFourier(offset, 1)))
    result = runProgram(qee[], p)
    q = getQubits(result)
    answer = 0
    for i = 1:offset
        answer += measure(q[i]) * (1 << (i - 1))
    end
    return answer
end

function createGroverOracle(func::Function, n, list)
    nn = 1 << n
    listSize = length(list)
    matrix = zeros(ComplexF64, nn, nn)
    for i = 1:nn
        matrix[i, i] = ((i - 1) >= listSize || func(list[i]) == 0) ? 1 : -1
    end
    return Oracle(matrix)
end

function createDiffMatrix(n)
    nn = 1 << n
    g = Hadamard(1)
    matrix = getMatrix(g)
    h2 = matrix
    for i = 2:n
        h2 = kron(h2, matrix)
    end
    I2 = Matrix{ComplexF64}(I, nn, nn)
    I2[1, 1] = -1

    return h2 * I2 * h2
end
