# Trabalhando-com-Grafos-e-Matrizes
Repositório para armazenar o código.

Relatório do Trabalho de Matemática Discreta

4º ADS – Turma: B

1. Integrantes do Grupo
Gabriel Veloso (RA:1990821)
Gabriela Lima (RA: 2014108)
	
2. Desenvolvimento do Projeto
1. Organização e Geração de Dados Base
Gabriela foi responsável pela Coleta de Dados Brutos (Dataset), conduzindo a pesquisa primária para reunir as preferências musicais dos alunos.

Gabriel foi responsável pela Organização e Estruturação dos Dados, tratando os dados brutos para o formato ideal de processamento no ambiente R.

2. Geração de Matrizes
A geração das matrizes fundamentais para a análise de redes foi dividida:

Gabriela  gerou a Matriz de Incidência (Pessoa x Gênero) e a Matriz de Similaridade (Pessoa x Pessoa), que mede a afinidade de gostos.

Gabriel gerou a Matriz de Coocorrência (Gênero x Gênero), que quantifica a frequência de escolha conjunta entre os diferentes estilos musicais.

3. Criação de Grafos e Visualização
A criação dos modelos visuais de rede (Grafos) seguiu a responsabilidade da matriz correspondente:

Gabriela  criou o Grafo de Incidência (bipartido) e o Grafo de Similaridade (a rede ponderada Pessoa x Pessoa), que exibe as conexões de afinidade.

Gabriel criou o Grafo de Coocorrência (a rede ponderada Gênero x Gênero), que ilustra a relação entre os próprios gêneros.

4. Cálculo de Métricas Topológicas
As métricas analíticas foram igualmente distribuídas:

Gabriela calculou a Centralidade de Grau para os Grafos de Incidência e Similaridade, e realizou a Detecção e Análise de Comunidades no Grafo de Similaridade.

Gabriel calculou a Centralidade de Intermediação no Grafo de Similaridade e o Coeficiente de Aglomeração Local no Grafo de Coocorrência.



