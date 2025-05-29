# Função principal que orquestra o processo
function menu()
    # Recebendo a matriz
    matriz_resultante = criar_matriz()
    # Incluindo o resultado da probabilidade em R
    R = Calcular_Probabilidade(matriz_resultante)

    # Exibe a matriz inserida
    println("\nMatriz")
    println(matriz_resultante)

    try
        # Exibe os resultados formatados como porcentagens
        println("Resposta da cadeia de Markov")
        println("X = (", round(R[1] * 100, digits=2), "%)")
        println("y = (", round(R[2] * 100, digits=2), "%)")
    catch e
        # Em caso de erro, reinicia o menu
        println("tente novamente")
        return menu()
    end
end

# Função para criar a matriz a partir da entrada do usuário
function criar_matriz()
    # Solicita o tamanho da matriz
    print("Qual é o tamanho da matriz? ")
    valor = readline()
    tamanho_vetor = parse(Int, valor)
    
    # Valida o tamanho da matriz
    if tamanho_vetor == 0
        println("valor tem que ser maior que zero")
        return criar_matriz()  # Recursão para nova tentativa
    end

    # Inicializa uma matriz de zeros com o tamanho especificado
    matriz = zeros(tamanho_vetor, tamanho_vetor)

    # Preenche cada coluna da matriz
    for i in 1:tamanho_vetor
        println("\nDigite dois números para a coluna $i (separados por espaço, soma deve ser 1):")

        # Loop para validação da entrada
        while true
            try
                valor_coluna = readline()
                valorDaColuna = [parse(Float64, x) for x in split(valor_coluna)]

                # Verifica se foram inseridos exatamente 2 números
                if length(valorDaColuna) != 2
                    println("Erro: Digite exatamente dois números separados por espaço!")
                    continue
                end

                # Atribui os valores à coluna correspondente
                matriz[:, i] = valorDaColuna
                break  # Sai do loop quando a entrada é válida

            catch e
                println("Erro: Por favor, digite números válidos!")
            end
        end
    end
    return matriz
end

# Função para calcular as probabilidades da cadeia de Markov
function Calcular_Probabilidade(matriz::Matrix{Float64})
    # Verifica se a soma dos elementos da primeira coluna é 1
    soma = matriz[1, 1] + matriz[2, 1]
    if soma !== 1.0
        return println("Erro: A soma dos números deve ser igual a 1 (soma atual = $soma)")
    end

    # Extrai os elementos relevantes da matriz
    a = matriz[1, 1] - 1  # Ajusta o elemento a11 para o cálculo
    b = matriz[1, 2]       # Elemento a12

    # Calcula as probabilidades estacionárias
    x = b / (b - a)  # Probabilidade do estado X
    y = 1 - x        # Probabilidade do estado Y (complementar)

    return [x, y]
end

# Inicia o programa chamando a função menu
menu()