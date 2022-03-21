
const logFile = Ref("")

function dbg(s...)
    dbp = get(ENV, "dbg", "false")
    if dbp == "true"
        println("[DBG] ", s...)
    end
    if !isempty(logFile[])
        open(logFile[], "a") do out
            println(out, "[DBG] ", s...)
        end
    end
end

#dbg2(s...)= dbg(s...)
dbg2(s...) = nothing

function setLogfile(logname, replace = true)
    logFile[] = logname
    if replace
        open(logFile[], "w") do out
        end
    end
end

struct SimpleQuantumExecutionEnvironment <: QuantumExecutionEnvironment end

function runProgram(qee::SimpleQuantumExecutionEnvironment, p::Program)
    dbg("runProgram...")
    nQubits = getNumberQubits(p)
    qubit = [Qubit() for _ = 1:nQubits]
    dim = 1 << nQubits
    initalpha = getInitialAlphas(p)
    probs = ones(ComplexF64, dim)
    for i = 1:dim
        for j = 1:nQubits
            pw = nQubits - j
            pt = 1 << pw
            div = (i - 1) ÷ pt
            md = div % 2
            if md == 0
                probs[i] *= initalpha[j]
            else
                probs[i] *= sqrt(1.0 - initalpha[j] * initalpha[j])
            end
        end
    end
    steps = getSteps(p)
    simpleSteps = getDecomposedSteps(p)
    if simpleSteps === nothing
        simpleSteps = Step[]
        for step in steps
            append!(simpleSteps, decomposeStep(step, nQubits))
        end
        setDecomposedSteps(p, simpleSteps)
    end

    result = Result(nQubits, length(steps))
    cnt = 0
    setIntermediateProbability(result, 1, probs)
    dbg("START RUN, number of steps = ", length(simpleSteps))
    for step in simpleSteps
        if !isempty(getGates(step))
            cnt += 1
            dbg("RUN STEP ", cnt, " of ", length(simpleSteps), ": ", step)
            dbg("before this step, probs =")
            printProbs(probs)
            probs = applyStep(qee, step, probs, qubit)
            dbg("after this step, probs =")
            printProbs(probs)
            idx = getComplexStep(step)
            if idx > -1
                setIntermediateProbability(result, idx, probs)
            end
        end
    end
    dbg("DONE RUN, probability vector =")
    printProbs(probs)
    qp = calculateQubitStates(qee, probs)
    setProbability.(qubit, qp)
    #for  i = 0  i < nQubits  i++)
    #    qubit[i].setProbability(qp[i])
    #end
    measureSystem(result)
    setResult(p, result)
    return result
end

function printProbs(probs)
    for p in probs
        r, i = real(p), imag(p)
        if abs(r) < 1e-6
            r = 0.0
        elseif 1-abs(r) < 1e-6
            r = 1.0
        end
        if abs(i) < 1e-6
            i = 0.0
        elseif 1-abs(i) < 1e-6
            i = 1.0
        end
        dbg(" -> (", r, ", ", i, ")")
    end
end

function printMatrix(m)
    for row = 1:size(m, 1)
        s = ""
        for col = 1:size(m, 2)
            s *= @sprintf(" (%f, %f)", real(m[row, col]), imag(m[row, col]))
        end
        dbg(" |", s, " |")
    end
end

decomposeSteps(::SimpleQuantumExecutionEnvironment, steps) = steps

function applyStep(::SimpleQuantumExecutionEnvironment, step, vector, qubits)
    dbg("start applystep, vectorsize = ", length(vector), ", ql = ", length(qubits))
    gates = getGates(step)
    if !isempty(gates) && gates[1] isa ProbabilitiesGate
        return vector
    end
    if length(gates) == 1 && gates[1] isa PermutationGate
        pg = gates[1]
        return permutateVector(vector, getIndex1(pg), getIndex2(pg))
    end

    result = calculateNewState(gates, vector, length(qubits))
    dbg("done applystep ---------------")
    return result
end

function calculateQubitStates(::SimpleQuantumExecutionEnvironment, vectorresult)
    nq = round(Int, log2(length(vectorresult)))
    answer = zeros(nq)
    ressize = 1 << nq
    for i = 1:nq
        pw = i - 1
        div = 1 << pw
        for j = 1:ressize
            p1 = (j - 1) ÷ div
            if isodd(p1)
                answer[i] += abs2(vectorresult[j])
            end
        end
    end
    return answer
end

function createPermutationMatrix(first, second, n)
    swapMatrix = getMatrix(Swap())
    iMatrix = getMatrix(Identity())
    answer = iMatrix
    i = 2
    if first == 1
        answer = swapMatrix
        i += 1
    end
    while i ≤ n
        if i == first
            i += 1
            answer = kron(answer, swapMatrix)
        else
            answer = kron(answer, iMatrix)
        end
        i += 1
    end
    return answer
end
