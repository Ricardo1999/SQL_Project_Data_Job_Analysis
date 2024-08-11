
# Introdução

Este projeto trata da análise exploratória de dados de Oferta de Emprego na área de TI. Buscarei levantar os empregos que mais pagam para uma determinada função, e quais as habilidades mais requisitadas para o exercício dessa função.

# Sobre os dados

Esse projeto é fruto do curso [SQL for Data Analytics - Learn SQL in 4 Hours](https://youtu.be/7mz73uXD9DA?si=y4OTcwhL0JOqzuCI) do [Luke Barousse](linkedin.com/in/luke-b), usei alguns dados fornecidos por ele em seu curso  para realizar essa análise, bem como o projeto que também é feito em seu curso.

Ao longo do curso serão usadas as seguintes tabelas:

![Tabelas usadas no projeto](Images\data_table_relationship.png)

# Questões propostas pelo Projeto


Questions to Answer:
1. What are the top-paying jobs for my role?
    - Solution: [1_top_paying_jobs](project_sql\1_top_paying_jobs.sql)

2. What are the skills required for these  top-paying roles?
    - Solution: [2_skills_required_for_top_paying_jobs](project_sql\2_skills_required_for_top_paying_jobs.sql)

3. What are the most in-demand skills for my role?
    - Solution: [3_most_indemand_skills](project_sql\3_most_indemand_skills.sql)

4. What are the top skills based on salary for my role?
    - Solution: [4_top_skills_based_on_salary](project_sql\4_top_skills_based_on_salary.sql)
    
5. What are the most optimal skills to learn?
    - a. Optimal: High Demanda AND High Paying
    - Solution: [5_optimal_skills](project_sql\5_optimal_skills.sql)

<br><br>
# #1 Top paying jobs

A primeira pergunta a ser respondida foi "quais os empregos mais bem pagos na função de Cientista de Dados?". Para isso filtramos a coluna job_title da tabela job_postings_fact, onde o job_title_short era igual a 'Data Scientist' e ordenamos de maneira decrescente o salary_year_avg. (limitado aos 10 maiores)

```sql
SELECT 
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    name AS company_name

FROM job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Scientist' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;
```
### Resultado
| **Job Title**                               | **Location** | **Schedule Type** | **Average Yearly Salary** | **Company Name**      |
|---------------------------------------------|--------------|-------------------|--------------------------|-----------------------|
| Staff Data Scientist/Quant Researcher        | Anywhere     | Full-time          | $550,000                  | Selby Jennings        |
| Staff Data Scientist - Business Analytics    | Anywhere     | Full-time          | $525,000                  | Selby Jennings        |
| Data Scientist                               | Anywhere     | Full-time          | $375,000                  | Algo Capital Group    |
| Head of Data Science                         | Anywhere     | Full-time          | $351,500                  | Demandbase            |
| Head of Data Science                         | Anywhere     | Full-time          | $324,000                  | Demandbase            |
| Director Level - Product Management - Data Science | Anywhere  | Full-time          | $320,000                  | Teramind              |
| Director of Data Science & Analytics         | Anywhere     | Full-time          | $313,000                  | Reddit                |
| Director of Data Science                     | Anywhere     | Full-time          | $300,000                  | Storm4                |
| Principal Data Scientist                     | Anywhere     | Full-time          | $300,000                  | Storm5                |
| Head of Battery Data Science                 | Anywhere     | Full-time          | $300,000                  | Lawrence Harvey       |


### Pode-se observar que:

- **Altos Salários para Cientistas de Dados em Funções de Pesquisa Quantitativa:**
  - As posições de **Staff Data Scientist/Quant Researcher** e **Staff Data Scientist - Business Analytics** na Selby Jennings são as mais bem pagas, com salários anuais médios de $550,000 e $525,000, respectivamente. Isso indica que funções que combinam ciência de dados com pesquisa quantitativa estão entre as mais valorizadas financeiramente.

- **Variedade de Cargos com Diferentes Faixas Salariais:**
  - Há uma grande variedade de títulos de trabalho, desde **Cientistas de Dados** até **diretores** e **chefes de ciência de dados**. Os salários variam significativamente, com os cargos de diretor e chefe tendo uma faixa de $300,000 a $351,500, enquanto um cientista de dados regular pode ganhar em torno de $375,000.

- **O Papel da Localização e da Empresa:**
  - Todos os empregos listados têm a localização como "Anywhere", sugerindo que essas posições são remotas. Isso pode indicar uma tendência de altos salários para posições de ciência de dados, mesmo sem a necessidade de trabalhar em um local físico específico. Empresas como **Selby Jennings** e **Algo Capital Group** oferecem as oportunidades mais bem remuneradas, destacando que a escolha da empresa pode ter um impacto significativo nos ganhos potenciais.

- **Cargos de Liderança em Ciência de Dados:**
  - Funções como **Head of Data Science** e **Director of Data Science** estão em alta demanda, mas oferecem salários médios mais baixos (em torno de $300,000 a $351,500) em comparação com posições técnicas de pesquisa Isso pode refletir a complexidade e responsabilidade das funções de liderança em relação às técnicas.

- **Oportunidades de Crescimento na Carreira:**
  - Para alguém interessado em maximizar o potencial de ganhos, focar em papéis que combinam ciência de dados com pesquisa quantitativa ou **analytics de negócios** pode ser uma estratégia eficaz, pois esses são os cargos com os maiores salários.

<br><br>
# #2 Skills Required for Top Paying Jobs

A segunda pergunta respondida foi "quais são as habilidades necessárias para essas funções mais bem pagas?". Para isso começamos criando duas tabelas de referência uma para associar as tabelas *skills_job_dim* e *skills_dim* (*skill_jobs*), e outra para trazer o resultado dos empregos mais bem pagos (*top_payed_jobs*). Com essas duas tabelas, aplicamos um ```INNER JOIN``` para criar uma tabela com os Empregos e suas respectivas Habilidades requeridas.


```sql
WITH 
    skill_jobs AS(
    SELECT
    job_id,
    skills_job_dim.skill_id,
    skills,
    type

    FROM skills_job_dim
    LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    ),

    top_payed_jobs AS(
    SELECT 
        job_id,
        job_title,
        job_location,
        job_schedule_type,
        salary_year_avg,
        job_posted_date,
        name AS company_name

    FROM job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE 
        job_title_short = 'Data Scientist' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10)

SELECT
    top_payed_jobs.job_id,
    top_payed_jobs.job_title,
    skill_jobs.skills,
    top_payed_jobs.salary_year_avg

FROM skill_jobs
INNER JOIN top_payed_jobs ON skill_jobs.job_id = top_payed_jobs.job_id;
```
### Resultado
| **Job Title**                                      | **Skills**     | **Average Yearly Salary** |
|----------------------------------------------------|----------------|--------------------------|
| Staff Data Scientist/Quant Researcher              | SQL            | $550,000                 |
| Staff Data Scientist/Quant Researcher              | Python         | $550,000                 |
| Staff Data Scientist - Business Analytics          | SQL            | $525,000                 |
| Data Scientist                                     | SQL            | $375,000                 |
| Data Scientist                                     | Python         | $375,000                 |
| Data Scientist                                     | Java           | $375,000                 |
| Data Scientist                                     | Cassandra      | $375,000                 |
| Data Scientist                                     | Spark          | $375,000                 |
| Data Scientist                                     | Hadoop         | $375,000                 |
| Data Scientist                                     | Tableau        | $375,000                 |
| Director Level - Product Management - Data Science | Azure          | $320,000                 |
| Director Level - Product Management - Data Science | AWS            | $320,000                 |
| Director Level - Product Management - Data Science | TensorFlow     | $320,000                 |
| Director Level - Product Management - Data Science | Keras          | $320,000                 |
| Director Level - Product Management - Data Science | PyTorch        | $320,000                 |
| Director Level - Product Management - Data Science | Scikit-learn   | $320,000                 |
| Director Level - Product Management - Data Science | DataRobot      | $320,000                 |
| Director of Data Science                           | Python         | $300,000                 |
| Director of Data Science                           | Pandas         | $300,000                 |
| Director of Data Science                           | Numpy          | $300,000                 |
| Head of Battery Data Science                       | Python         | $300,000                 |
| Head of Battery Data Science                       | AWS            | $300,000                 |
| Head of Battery Data Science                       | GCP            | $300,000                 |
| Principal Data Scientist                           | SQL            | $300,000                 |
| Principal Data Scientist                           | Python         | $300,000                 |
| Principal Data Scientist                           | Java           | $300,000                 |
| Principal Data Scientist                           | C              | $300,000                 |
| Principal Data Scientist                           | AWS            | $300,000                 |
| Principal Data Scientist                           | GCP            | $300,000                 |



### Pode-se observar que:

### Habilidades de Programação e Manipulação de Dados
- **Python e SQL**: Estas habilidades são frequentemente associadas aos cargos mais bem pagos, incluindo Staff Data Scientist/Quant Researcher e Staff Data Scientist - Business Analytics. Python e SQL são fundamentais para análise de dados e modelagem, o que reflete seu impacto direto em salários mais altos.
- **Java**: Utilizado por Data Scientists e Distinguished Data Scientists, Java também é valorizado, especialmente para funções que requerem processamento de dados em grande escala.

### Competências em Big Data e Machine Learning
- **Spark, Hadoop e Cassandra**: Essas habilidades estão associadas a funções de Data Scientist com salários médios elevados. Elas são cruciais para trabalhar com grandes volumes de dados e processamento em larga escala.
- **TensorFlow, Keras, PyTorch e Scikit-learn**: Habilidades em frameworks de machine learning são comuns em funções de alto nível como Director Level e Distinguished Data Scientist. Elas são importantes para a construção e treinamento de modelos avançados de aprendizado de máquina.

### Ferramentas e Plataformas de Nuvem
- **AWS e GCP**: Habilidades em plataformas de nuvem são necessárias para várias funções, incluindo Head of Battery Data Science e Principal Data Scientist. A familiaridade com essas plataformas é crucial para implementar e gerenciar soluções de ciência de dados em ambientes escaláveis e distribuídos.
- **Azure**: Também é uma habilidade valorizada para cargos de nível diretor, indicando a importância de estar familiarizado com diferentes fornecedores de nuvem.

### Tecnologias e Ferramentas Adicionais
- **Tableau**: Conhecimento em ferramentas de visualização de dados, como Tableau, é relevante para funções de Data Scientist. Embora não seja um dos fatores de maior salário, é importante para apresentar e comunicar insights de dados.
- **Kubernetes**: Usado por Distinguished Data Scientists, Kubernetes é valorizado para gerenciamento de contêineres e orquestração, refletindo sua importância em ambientes de desenvolvimento de dados modernos.

### Diversidade de Habilidades
- **Variedade de habilidades**: A diversidade de habilidades requeridas para funções de ciência de dados, desde linguagens de programação até ferramentas específicas de Big Data e machine learning, sugere que um conjunto amplo de competências pode levar a melhores oportunidades de remuneração.

### Conclusão

Para maximizar o potencial de ganhos em ciência de dados, é importante desenvolver um conjunto diversificado de habilidades que inclui programação (Python, SQL), frameworks de machine learning (TensorFlow, PyTorch), ferramentas de big data (Spark, Hadoop), e plataformas de nuvem (AWS, GCP). A combinação de habilidades técnicas com experiência prática em projetos complexos e de grande escala pode aumentar significativamente o valor no mercado.

<br><br>
# #3 Most Indemand Skills

A terceira pergunta a ser respondida foi "quais são as habilidades mais exigidas para a função de cientista de dados?". Para isso criarmos a tabela *data_analyst_jobs* para trazer todos os registros que constam 'Data Scientist' e depois unimos com as tabelas *skills_job_dim* e *skills_dim* para encontrar as skills para 'Data Scientist'. Com isso, agrupamos e contamos a quantidade de skills e ordenamos em ordem decrescente. (limitamos as 10 mais frequentes)


```sql
WITH data_analyst_jobs AS (SELECT 
        job_id,
        job_title,
        job_title_short

    FROM job_postings_fact
    WHERE 
        job_title_short = 'Data Scientist')

SELECT
    skills_dim.skills,
    COUNT(skills_dim.skills) AS skill_count

FROM data_analyst_jobs
INNER JOIN skills_job_dim ON data_analyst_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

GROUP BY skills_dim.skills
ORDER BY skill_count DESC
LIMIT 10
```
## Resultado
#### Principais Habilidades para Cientistas de Dados

| Habilidade   | Contagem |
|--------------|----------|
| Python       | 114,016  |
| SQL          | 79,174   |
| R            | 59,754   |
| SAS          | 29,642   |
| Tableau      | 29,513   |
| AWS          | 26,311   |
| Spark        | 24,353   |
| Azure        | 21,698   |
| TensorFlow   | 19,193   |
| Excel        | 17,601   |

## Observações

- **Python** é a habilidade mais demandada, refletindo sua importância na ciência de dados para análise e modelagem.
- **SQL** é crucial para manipulação e extração de dados, o que justifica sua alta contagem.
- **R** é uma ferramenta valiosa para análise estatística e visualização, mantendo uma posição significativa no mercado.
- **SAS** e **Tableau** são utilizados para análises específicas e visualização de dados, respectivamente.
- **AWS** e **Azure** são essenciais para o trabalho com plataformas de nuvem.
- **Spark** é valorizado para processamento de grandes volumes de dados.
- **TensorFlow** é importante para machine learning e deep learning.
- **Excel** continua a ser amplamente usado para análises e relatórios básicos.

Essas habilidades são indicativas das áreas de conhecimento mais valorizadas no campo da ciência de dados, refletindo a necessidade de um conjunto diversificado de competências técnicas.


## Pode-se observar que:

### Habilidades Mais Requisitadas

1. **Python**
   - **Insight**: Python é a habilidade mais requisitada, destacando-se como a principal linguagem de programação para ciência de dados. Sua popularidade se deve à sua versatilidade e à vasta gama de bibliotecas e frameworks disponíveis para análise e modelagem de dados.

2. **SQL**
   - **Insight**: SQL é fundamental para a manipulação e extração de dados de bancos de dados relacionais. Sua alta demanda reflete a importância das habilidades de consulta e gestão de dados em tarefas diárias de um cientista de dados.

3. **R**
   - **Insight**: R é amplamente utilizado para análise estatística e visualização de dados. Sua presença significativa nas ofertas de emprego indica que, apesar da popularidade do Python, R continua a ser uma habilidade valiosa.

4. **SAS**
   - **Insight**: SAS é uma ferramenta tradicionalmente usada em análises estatísticas e de dados empresariais. Embora menos popular do que Python e R, ainda é uma habilidade relevante em muitas organizações, especialmente em setores específicos como finanças e saúde.

5. **Tableau**
   - **Insight**: Tableau é uma ferramenta de visualização de dados amplamente utilizada. A demanda por habilidades em Tableau destaca a importância de comunicar insights de dados de maneira clara e visualmente atraente.

6. **AWS**
   - **Insight**: Conhecimento em AWS é essencial para cientistas de dados que trabalham com soluções em nuvem e implementam modelos e análises em ambientes escaláveis.

7. **Spark**
   - **Insight**: Apache Spark é uma plataforma para processamento de grandes volumes de dados. Sua demanda alta reflete a necessidade de habilidades em processamento distribuído e big data.

8. **Azure**
   - **Insight**: Assim como AWS, o conhecimento em Microsoft Azure é valioso para cientistas de dados envolvidos em soluções de nuvem e análise em larga escala.

9. **TensorFlow**
   - **Insight**: TensorFlow é uma biblioteca popular para machine learning e deep learning. Sua alta demanda indica a importância crescente de técnicas avançadas de aprendizado de máquina em ciência de dados.

10. **Excel**
    - **Insight**: Embora menos avançado em comparação com outras ferramentas, Excel ainda é amplamente utilizado para análise de dados e criação de relatórios, especialmente em tarefas que não exigem processamento complexo.

### Conclusão

As habilidades mais exigidas para a função de cientista de dados incluem um forte conhecimento em Python e SQL, seguido por habilidades em R, SAS e ferramentas de visualização como Tableau. Competências em plataformas de nuvem (AWS, Azure), big data (Spark) e machine learning (TensorFlow) também são altamente valorizadas. Além disso, habilidades em Excel ainda desempenham um papel importante, indicando que a análise de dados básica continua a ser uma parte significativa do trabalho de um cientista de dados. Para se destacar na área, é crucial desenvolver um conjunto diversificado de habilidades técnicas e estar atualizado com as ferramentas e tecnologias emergentes.

<br><br>
# #4 Top Skills Based on Salary

A quarta pergunta a ser respondida foi "quais são as principais habilidades com base no salário para minha função?". Para isso buscamos ordenar de maneira decrescente a média dos salários anuais agrupada por *skill*, para todos os registros que constam como 'Data Scientist'.


```sql
SELECT
    skills_dim.skills,
    ROUND(AVG(job_postings_fact.salary_year_avg),2) AS avg_salary_year_by_skill

FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

WHERE
    job_postings_fact.salary_year_avg IS NOT NULL
    AND job_title_short = 'Data Scientist'

GROUP BY skills_dim.skills
ORDER BY avg_salary_year_by_skill DESC
LIMIT 10
```

## Resultado
#### Habilidades e Salários Médios Anuais

| Habilidade        | Salário Médio Anual (USD) |
|-------------------|----------------------------|
| Asana             | 215,477.38                 |
| Airtable          | 201,142.86                 |
| RedHat            | 189,500.00                 |
| Watson            | 187,417.14                 |
| Elixir            | 170,823.56                 |
| Lua               | 170,500.00                 |
| Slack             | 168,218.76                 |
| Solidity          | 166,979.90                 |
| Ruby on Rails     | 166,500.00                 |
| RShiny            | 166,436.21                 |

### Observações

- **Asana** apresenta o maior salário médio anual, sugerindo uma alta valorização para habilidades relacionadas a essa ferramenta de gerenciamento de projetos.
- **Airtable** e **RedHat** também possuem salários elevados, refletindo a demanda e a importância dessas plataformas no mercado.
- **Watson** e **Elixir** estão entre as habilidades bem remuneradas, indicando a valorização de tecnologias de inteligência artificial e linguagens funcionais.
- **Lua** e **Slack** têm salários significativos, destacando a importância de habilidades em tecnologias de programação e comunicação.
- **Solidity**, **Ruby on Rails**, e **RShiny** são altamente valorizados, refletindo a especialização em desenvolvimento de contratos inteligentes, frameworks de desenvolvimento web, e ferramentas de visualização de dados.


## Pode-se observar que:

### Habilidades de Alta Valorização
- **Asana** e **Airtable** são as habilidades com os maiores salários médios anuais. Isso sugere que habilidades em ferramentas de gerenciamento e colaboração de projetos são altamente valorizadas.
- **RedHat** e **Watson** também estão entre as habilidades mais bem remuneradas, refletindo a importância de conhecimentos em plataformas de tecnologia e inteligência artificial.

### Tecnologias de Programação e Desenvolvimento
- **Elixir**, **Lua**, **Solidity**, e **Ruby on Rails** estão associadas a salários elevados. Isso indica que habilidades em linguagens de programação específicas e desenvolvimento de software especializado são muito valorizadas.
- **Solidity**, em particular, destaca a importância do desenvolvimento de contratos inteligentes, um campo em crescimento com alta remuneração.

### Ferramentas de Comunicação e Colaboração
- **Slack** é uma habilidade bem remunerada, destacando a relevância das ferramentas de comunicação e colaboração no ambiente de trabalho moderno.

### Diversidade de Habilidades
- A variedade de habilidades listadas, desde plataformas de gerenciamento até linguagens de programação e ferramentas de colaboração, indica que um conjunto diversificado de competências pode levar a melhores oportunidades de remuneração.
- Isso reforça a importância de ter uma gama ampla de habilidades técnicas e ferramentas específicas para maximizar o potencial de ganhos.

### Recomendação
Para maximizar o potencial de ganhos em sua função, considere investir tempo e esforço para desenvolver habilidades nas áreas e ferramentas mais valorizadas, conforme os dados indicam. Isso pode incluir aprender ou aprimorar habilidades em ferramentas de gerenciamento de projetos, linguagens de programação especializadas, e plataformas de tecnologia emergentes.

<br><br>
# #5 Optimal Skills
A qquinta pergunta a ser respondida foi "quais são as habilidades ideais para aprender?", com os dados que temos em mãos entendemos que uma maneira de obter essa resposta seria encontrar as habilidades mais frenquentes e também mais bem pagas para Data Scientists. Para isso criamos duas tabelas  *most_indemand* e *top_skills_salary*, e realizamos um ```INNER JOIN``` para poder trazer as habilidades mais bem pagas e mais frequentes respectivamente.


```sql
WITH 
    most_indemand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_dim.skills) AS skill_count

    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Scientist' AND
        salary_year_avg IS NOT NULL AND
        job_work_from_home = True

    GROUP BY skills_dim.skill_id),
    
    top_skills_salary AS (
    SELECT
        skills_dim.skill_id,
        ROUND(AVG(job_postings_fact.salary_year_avg),2) AS avg_salary_year_by_skill

    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

    WHERE
        job_title_short = 'Data Scientist' AND
        salary_year_avg IS NOT NULL AND
        job_work_from_home = True

    GROUP BY skills_dim.skill_id)


SELECT 
    most_indemand.skill_id,
    most_indemand.skills,
    most_indemand.skill_count,
    top_skills_salary.avg_salary_year_by_skill

FROM most_indemand
INNER JOIN top_skills_salary ON most_indemand.skill_id = top_skills_salary.skill_id
WHERE 
    skill_count > 10
ORDER BY
    avg_salary_year_by_skill DESC,
    skill_count DESC
LIMIT 10
```

## Resultado
#### Principais Habilidades e Seus Salários Médios Anuais

| Habilidade  | Contagem de Ocorrências | Salário Médio Anual (USD) |
|-------------|--------------------------|----------------------------|
| C           | 48                       | $164,864.98                 |
| Go          | 57                       | $164,691.09                 |
| Qlik        | 15                       | $164,484.64                 |
| Looker      | 57                       | $158,714.91                 |
| Airflow     | 23                       | $157,414.13                 |
| BigQuery    | 36                       | $157,142.36                 |
| Scala       | 56                       | $156,701.92                 |
| GCP         | 59                       | $155,810.57                 |
| Snowflake   | 72                       | $152,686.88                 |
| PyTorch     | 115                      | $152,602.70                 |

### Observações

- **Habilidades Altamente Remuneradas:** As habilidades `C`, `Go`, e `Qlik` têm os salários anuais médios mais altos, indicando que conhecimentos nestas áreas são altamente valorizados.
- **Ferramentas e Plataformas de Dados:** `Airflow`, `BigQuery`, `Snowflake`, e `GCP` estão entre as habilidades bem remuneradas e são frequentemente associadas a plataformas de dados e processamento em larga escala.
- **Machine Learning:** `PyTorch` é uma habilidade bem remunerada e popular, refletindo a crescente demanda por conhecimentos em frameworks de machine learning.
- **Visualização e Análise de Dados:** `Looker` e `Qlik` são relevantes para análise e visualização de dados, com salários relativamente altos.

### Recomendação

Para maximizar o potencial de ganhos, considere desenvolver habilidades nas áreas mais bem remuneradas, como linguagens de programação específicas (`C`, `Go`), ferramentas de dados (`Airflow`, `BigQuery`), e frameworks de machine learning (`PyTorch`).

## Pode-se observar que:

### 1. Habilidades Altamente Remuneradas
- **C** e **Go**: Ambas são linguagens com altos salários médios anuais e são conhecidas por sua eficiência em desenvolvimento de sistemas e aplicativos de alta performance.
- **Qlik** e **Looker**: Ferramentas de visualização e análise de dados que são bem remuneradas. Investir em aprender essas ferramentas pode ser vantajoso para funções relacionadas à análise de dados.

### 2. Ferramentas de Dados e Processamento
- **Airflow**, **BigQuery**, **Snowflake**, e **GCP**: Essenciais para o gerenciamento e processamento de dados em larga escala. Aprender a usar essas ferramentas é crucial para funções relacionadas a Big Data e engenharia de dados.
- **GCP** (Google Cloud Platform) e **Snowflake**: Amplamente utilizados em ambientes de nuvem, refletindo a importância das habilidades em plataformas de nuvem para o gerenciamento de dados.

### 3. Machine Learning
- **PyTorch**: Uma habilidade bem remunerada e amplamente usada em machine learning. Aprender PyTorch é estratégico para quem deseja se aprofundar em aprendizado de máquina e desenvolvimento de modelos avançados.

### 4. Tendências do Mercado
- **Habilidades em Machine Learning**: A popularidade crescente de frameworks como PyTorch indica uma demanda crescente por habilidades em machine learning.
- **Ferramentas de Análise de Dados e Visualização**: A importância de ferramentas como Looker e Qlik sugere que habilidades em análise e visualização de dados continuam a ser muito valorizadas.

### 5. Diversidade de Habilidades
- **Variedade de Competências**: A diversidade nas habilidades mais bem remuneradas (linguagens de programação, ferramentas de dados, machine learning) sugere que um conjunto amplo de habilidades pode proporcionar uma vantagem significativa.

### Conclusão

- **Priorize Linguagens de Programação e Ferramentas Bem Remuneradas**: Focar no aprendizado de **C**, **Go**, e **PyTorch** pode aumentar as oportunidades de carreira e o potencial de ganhos.
- **Desenvolva Competências em Ferramentas de Dados e Nuvem**: Aprender a usar **Airflow**, **BigQuery**, **Snowflake**, e **GCP** pode ser essencial para funções em engenharia de dados e análise.
- **Invista em Ferramentas de Visualização e Análise**: Conhecimentos em **Qlik** e **Looker** são valiosos para funções focadas na análise e apresentação de dados.


<br><br>
# O que pude aprender?

writing...