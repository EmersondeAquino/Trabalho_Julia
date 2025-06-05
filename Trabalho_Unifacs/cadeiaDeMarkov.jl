using LinearAlgebra

# funcao principal: executa o menu do programa
function menu()
    matriz_resultante = criar_matriz()  # cria a matriz de transiçao
    R = Calcular_Probabilidade(matriz_resultante)  # calculaa a distribuicao estacionária

    # exibe a matriz de transição inserida
    println("\nMatriz de transição inserida:")
    for i in 1:size(matriz_resultante, 1)
        println(matriz_resultante[i, :])
    end

    try
        # exibe a distribuiçao estacionária em porcentagem
        println("\nDistribuição estacionária da cadeia de Markov (%):")
        for i in 1:length(R)
            porcentagem = round(R[i] * 100, digits=2)
            println("estado $i = $porcentagem%")
        end
        println()
        # exibe a interpretaçao de longo prazo para cada estado
        for i in 1:length(R)
            porcentagem = round(R[i] * 100, digits=2)
            println("No longo prazo, a probabilidade do sistema estar no estado $i é $porcentagem%")
        end
    catch e
        println("Ocorreu um erro. Tente novamente.")
        return menu()
    end
end

# funcao que cria uma matriz quadrada NxN onde cada linha deve somar 1
function criar_matriz()
    n = 0  # N começa valendo zero
    try
        # pede ao usuário o tamanho N da matriz N x N
        print("Escreva o valor de N para a matriz N x N:")
        valor = readline()  # lê a entrada do usuário como string
        n = parse(Int, valor)  # converte a entrada para Int
        # verifica se N é maior que zero
        if n <= 0
            println("O valor deve ser maior que zero.")
            return criar_matriz()  # chama de novo a função se N for inválido
        end
    catch e
        println("Entrada inválida. Por favor, insira um número inteiro.")
        return criar_matriz()  # chama a função de novo se houver erro
    end

    # iniciq uma matriz NxN preenchida com zeros
    matriz = zeros(n, n)

    # pede ao usuário que preencha cada linha da matriz
    println("\nAgora, digite cada linha da matriz, separando os números por espaço (cada linha deve somar 1):")

    # loop para preencher cada linha da matriz
    for i in 1:n
        try
            while true  # loop infinit até que a linha seja válida
                print("Linha $i: ")
                entrada = readline()  # lê a linha digitada pelo usuário
                valores = [parse(Float64, x) for x in split(entrada)]  # converte para números

                # vê se o número de elementos digitados é igual a N
                if length(valores) != n
                    println("Erro: Digite exatamente $n números separados por espaço!")
                    continue  # pede a linha de novo
                end

                # calculaa a soma dos elementos da linha
                soma = sum(valores)

                # verifica se a soma é aproximadamente 1 (com tolerância para erros de ponto flutuante(linguagem n ajuda!))
                if abs(soma - 1.0) > 1e-8
                    println("Erro: A soma dos números da linha deve ser igual a 1 (soma atual = $soma)")
                    continue  # Pede novamente a linha
                end

                # se passar nas verificaçoes preenche a linha da matriz
                matriz[i, :] = valores
                break  # sai do loop while e vai para a próxima linha
            end
        catch e
            println("Entrada inválida. Por favor, insira um número float EX(0.10).")
            return criar_matriz() # chama a função de novo se houver erro
        end
    end

    # retorna a matriz preenchida
    return matriz
end

# funcao para calcular a distribuição estacionaria da matriz de transição
function Calcular_Probabilidade(matriz::Matrix{Float64})
    vals, vecs = eigen(matriz')  # calcula autovalores e autovetores da transposta
    idx = findall(x -> isapprox(x, 1.0; atol=1e-8), vals)  # procura autovalor 1
    if isempty(idx)
        println("Não foi possível encontrar distribuição estacionária.")
        return zeros(size(matriz, 1))
    end
    v = vecs[:, idx[1]]  # pega o autovetor correspondente
    v = abs.(v)          # garante valores positivos
    v = v / sum(v)       # normaliza para somar 1
    return v
end

# inicia o programa
menu()
