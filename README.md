# Sistema de Cadastro de Alunos no Kubernetes(Minikube)

## Visão Geral
Implantação de uma aplcação composta por Docker, Helm e Kubernetes
- students-web: interface web(Tomcat) da aplicação para cadastro e listagem de estudantes
- students-terminal: interface com linha de comando da aplicação
- MongoDB: banco de dados usado para guardar as informações

Todos os componentes são conteinerizados e orquestrados pelo Kubernetes por meio do Helm

## Componentes e Artefatos
### Deployments
- Web: Garante que a interface web esteja sempre em execução. Define a imagem Docker students-web, expõe a porta 8080 e injeta variáveis de ambiente com as credenciais do Mongo via secret
- Terminal: Mantem o pod do terminal rodadno. Usa a imagem students-terminal e conecta ao banco através das variáveis de ambiente
- Banco: Usa a imagem padrão mongo:latest, com credenciais injetadas por secret e volume persistente associado

### Services
- Web: Service do tipo ClusterIP para expor students-web dentro do cluster, na porta 8080
- Terminal: Também usa CluesterIP para que students-terminal se comunique internamente com o banco de dados
- Banco: Service interno que expoẽ o Mongo para as aplicações

### Ingress
- Permite o acesso externo a interface web via navegador. USao o controlador nginx e associa ao domínio k8s.local
- A versão terminal não é exposta via ingress, o acesso é feito diretamente via kubectl exec

### PVC
- Cria um volume persistente para o banco de dados, garantindo que os dados sejam preservados

### Secrets
- Armazena de forma segura o nome de usuário e a senha de acesso ao Mongo. Esses valores são referenciados nos arquivos de deployment para configuração dos contêineres

## Pré-requisitos para executar o projeto
- Minikube
- Helm
- Maven
- Docker

## Como exeecutar o projeto
### Clone o repositório
- ` git clone https://github.com/nathaliabg12/Devops-Kubernetes.git`

### Execute o Script de Deploy
`chmod +x deploy.sh`
`./deploy.sh`
- Esse script faz:
  - O build da aplicação(mvn package)
  - Inicializa o Minikube
  - Hablita o Ingress, Dashboard e Metrics
  - Builda e carrega as imagens Docker para o cluster
  - Instala o Helm Chart da aplicação
- Se necessário adicione o IP do minikube: `echo "$(minikube ip) k8s.local" | sudo tee -a /etc/hosts`

### Acesse a aplicação
- Interface web: http://k8s.local
- Terminal via kubectl:
  - `kubectl exec -it <nome-do-pod-terminal> -- /bin/bash`
  - `python3 main.py`
- No script os pods já são acessados para poder pegar seu nome, mas se necessário, o comando é: `kubectl get pods`




