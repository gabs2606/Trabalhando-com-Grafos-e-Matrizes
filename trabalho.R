# Pacote igraph é necessário para manipulação e análise dos grafos
# if(!require(igraph)) install.packages("igraph")
biblioteca(igraph)

# 1. Define o Dataset Bruto, ele que coleta os dados.
# A lista 'musicas' armazena as preferências musicais, onde cada nome é um aluno 
# e o vetor c() são os gêneros que o escolheu.
musicas <- list(
  Luís = c("Pop", "Rock", "Gospel", "MPB"),
  Thauane = c("Pop", "Rock", "MPB"),
  Larissa = c("Pop", "Pagode", "Funk/Trap"),
  Fernanda = c("Pop", "MPB", "Sertanejo"),
  Felipe = c("Pop", "Rock", "Eletronica"),
  Giovanna = c("Pop", "Rock", "Eletronica"),
  Davi = c("Pop", "Rock", "Pagode"),
  Beatriz = c("Pop", "Rock", "MPB"),
  Camila = c("Pop", "Sertanejo", "Gospel"),
  Emily = c("Pop", "Sertanejo", "Pagode"),
  Geovana = c("Pop", "Pagode", "Funk/Trap"),
  Ana = c("Sertanejo", "Gospel", "MPB"), 
  Alexandre = c("Pagode", "Gospel", "Funk/Trap"),
  César = c("Eletronica", "Rap/Hiphop", "Gospel"),
  Nicole = c("Pagode", "Gospel", "MPB"),
  Alysson = c("Rap/Hiphop", "Gospel", "Funk/Trap")
)

# 2. Estrutura os dados para análise (Formato Longo).
# Converte a lista para um data.frame 'longo', facilitando uma criação de tabelas de contingência.
dados_longo <- data.frame(
  Pessoa = rep(names(musicas), sapply(musicas, length)),
  Genero = unlist(musicas),
  stringsAsFactors = FALSE
)

# 3. GERAÇÃO DA MATRIZ DE INCIDÊNCIA (Pessoa x Gênero)
# Criada usando a função 'table', que conta a ocorrência das combinações Pessoa/Gênero.
# Linhas = Alunos, Colunas = Gêneros. O valor '1' indica que o aluno escolheu aquele gênero.
matriz_incidencia <- table(dados_longo$Pessoa, dados_longo$Genero)
print("Matriz de Incidência (Alunos x Gêneros):")
print(matriz_incidencia)

# 4. GERAÇÃO DA MATRIZ DE SIMILARIDADE (Pessoa x Pessoa)
# Esta matriz é gerada pela multiplicação da matriz de incidência pela sua transposta (t()).
# O valor na célula (i, j) representa o NÚMERO DE GOSTOS MUSICAIS EM COMUM entre a pessoa 'i' e a pessoa 'j'.
matriz_similaridade <- matriz_incidencia %*% t(matriz_incidencia)

# Define a diagonal principal como zero (removendo auto-laços), pois a similaridade 
# de uma pessoa consigo mesma não é relevante para a rede de afinidade.
diag(matriz_similaridade) <- 0
print("Matriz de Similaridade (Alunos x Alunos - Peso = Gostos Comuns):")
print(matriz_similaridade)


# 5. GERAÇÃO DA MATRIZ DE COOCORRÊNCIA (Gênero x Gênero)
# Esta matriz é gerada pela multiplicação da transposta da matriz de incidência (t()) pela Matriz de Incidência original.
# O valor na célula (i, j) representa a FREQUÊNCIA DE ESCOLHA CONJUNTA entre o gênero 'i' e o gênero 'j' (quantas vezes foram escolhidos pela mesma pessoa).
matriz_coocorrencia <- t(matriz_incidencia) %*% matriz_incidencia

# Define a diagonal principal como zero, pois a coocorrência de um gênero consigo mesmo não é relevante para a rede de relação entre gêneros.
diag(matriz_coocorrencia) <- 0

print("Matriz de Coocorrência (Gêneros x Gêneros - Freq. de Escolha Conjunta):")
print(matriz_coocorrencia)

# 6. Criação e Análise do Grafo de Incidência
# Grafo Bipartido: Conecta alunos e gêneros.
g_incidencia <- graph_from_incidence_matrix(matriz_incidencia)
grau_alunos_inc <- degree(g_incidencia, v=V(g_incidencia)[type==FALSE]) # Grau dos alunos (variedade de gosto)
grau_generos_inc <- degree(g_incidencia, v=V(g_incidencia)[type==TRUE])  # Grau dos gêneros (popularidade)

print("Grafo de INCIDÊNCIA")
print("Mais Conectados (Grau):")
print(head(sort(grau_alunos_inc, decreasing = TRUE), 5))
print("Top 3 Gêneros Mais Populares (Grau):")
print(head(sort(grau_generos_inc, decreasing = TRUE), 3))

# Visualização do Grafo de Incidência
plot(g_incidencia, 
     vertex.color=c("pink", "lightgreen")[V(g_incidencia)$type+1],
     main="Grafo de Incidência (Pessoa <-> Gênero)")

# 7. Criação e Análise do Grafo de Similaridade
# Grafo de Afinidade: Conecta alunos com alunos, ponderado pelos gostos em comum.
g_similaridade <- graph_from_adjacency_matrix(matriz_similaridade, 
                                              mode="undirected", 
                                              weighted=TRUE)
# Remove as arestas com peso 0 (alunos sem nada em comum)
g_similaridade_clean <- delete_edges(g_similaridade, which(E(g_similaridade)$weight == 0))
grau_sim <- degree(g_similaridade_clean)
intermediação_sim <- betweenness(g_similaridade_clean)
comunidades_sim <- cluster_walktrap(g_similaridade_clean) # Detecção de comunidades pelo algoritmo Walktrap

print("Métricas similaridades")
print("Top 3 Alunos por Centralidade de Grau (Mais Similaridade):")
print(head(sort(grau_sim, decreasing = TRUE), 3))
print("Top 3 Alunos por Centralidade de Intermediação (Mais Pontes):")
print(head(sort(intermediação_sim, decreasing = TRUE), 3))
print("Tamanho das Comunidades Encontradas:")
print(sizes(comunidades_sim))
                          
# Configurações de visualização para o grafo de similaridade
V(g_similaridade_clean)$color <- comunidades_sim$membership
E(g_similaridade_clean)$width <- E(g_similaridade_clean)$weight # Largura da aresta pelo peso
plot(g_similaridade_clean, 
     main="Grafo 2: Similaridade (Alunos e Afinidade)", 
     layout=layout_nicely)

# 8. Criação e Análise do Grafo de Coocorrência
# Grafo de Relação entre gêneros, ponderado pela frequência de escolhas conjuntas.
g_coocorrencia <- graph_from_adjacency_matrix(matriz_coocorrencia, 
                                              mode="undirected", 
                                              weighted=TRUE)
# Remove as arestas com peso 0 (gêneros que nunca foram escolhidos juntos)
g_coocorrencia_clean <- delete_edges(g_coocorrencia, which(E(g_coocorrencia)$weight == 0))

# Recriação e limpeza (bloco duplicado, mantido para evitar confusão de variáveis)
g_coocorrencia <- graph_from_adjacency_matrix(matriz_coocorrencia, 
                                              mode="undirected", 
                                              
                                              weighted=TRUE)

g_coocorrencia_clean <- delete_edges(g_coocorrencia, which(E(g_coocorrencia)$weight == 0))
grau_cooc <- degree(g_coocorrencia_clean)

# Cálculo do Coeficiente de aglomeração local (mede a "integração" de cada gênero)
coeficiente_aglomeracao <- transitivity(g_coocorrencia_clean, type="local") 
names(coeficiente_aglomeracao) <- V(g_coocorrencia_clean)$name

print("--- MÉTRICAS COOCORRÊNCIA ---")
print("Top 3 Gêneros por Centralidade de Grau (Mais Coocorrem):")
print(head(sort(grau_cooc, decreasing = TRUE), 3))
print("Top 3 Gêneros por Coeficiente de Aglomeração (Mais Integrados):")
print(head(sort(coeficiente_aglomeracao, decreasing = TRUE), 3))

# Configurações de visualização para o grafo de coocorrência
E(g_coocorrencia_clean)$width <- E(g_coocorrencia_clean)$weight * 0.3
plot(g_coocorrencia_clean, 
     vertex.size=degree(g_coocorrencia_clean) * 3, 
     main="Grafo 3: Coocorrência (Relação entre Gêneros)")