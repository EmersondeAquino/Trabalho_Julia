using LinearAlgebra

function menu()
    # Solicita o tamanho da matriz
    print("Qual é o tamanho da matriz? ")
    valor = readline()
    tamanho_vetor = parse(Int, valor)
    # valida o tamanho
    try
        tamanho_vetor <= 0 && error("O tamanho deve ser um número positivo!")
    catch e
        error("Por favor, digite um número inteiro válido para o tamanho!")
    end

    # Cria a matriz
    matriz = zeros(tamanho_vetor, tamanho_vetor)

    # Preenche cada coluna
    for i in 1:tamanho_vetor
        println("\nDigite dois números para a coluna $i (separados por espaço, soma deve ser 1):")

        # Lê e valida a entrada
        while true
            try
                valor_coluna = readline()
                valorDaColuna = [parse(Float64, x) for x in split(valor_coluna)]

                # Verifica se tem exatamente 2 números
                if length(valorDaColuna) != 2
                    println("Erro: Digite exatamente dois números separados por espaço!")
                    continue
                end

                # Verifica se a soma é 1
                soma = round(valorDaColuna[1] + valorDaColuna[2])
                if soma != 1.0
                    println("Erro: A soma dos números deve ser igual a 1 (soma atual = $soma)")
                    continue
                end

                # Atribui os valores à coluna
                matriz[:, i] = valorDaColuna
                break  # Sai do loop while se tudo estiver correto

            catch e
                println("Erro: Por favor, digite números válidos!")
            end
        end
    end
    return matriz
end

function Calcular_Probabilidade(matriz::Matrix{Float64})

    #pegando a linha 1
    a = matriz[1,1] -1
    b = matriz[1,2]

    #calculando a porcentagem
    x = b / (b - a)
    y = 1 - x

    return[x, y]
end

matriz_resultante = menu()
R = Calcular_Probabilidade(matriz_resultante)

println("\nMatriz")
println(matriz_resultante)

println("Resposta da cadeia de Markov")
println("X = (", round(R[1]*100, digits=2),"%)")
println("X = (", round(R[2]*100, digits=2),"%)")