#!/bin/bash

#Caso seja necessário reiniciar a aplicação, excute também:
#helm uninstall students
#minikube delete

cd students-web
mvn clean package

cd ..

echo "Iniciando o Minikube e habilitando addons"
minikube start
minikube addons enable ingress
minikube addons enable dashboard
minikube addons enable metrics-server
#minikube dashboard &
echo "Finalização do Minikube e reinicialização"

echo "Carregando imagens no Minikube"
eval $(minikube docker-env)
docker build -t students-terminal:latest ./students-terminal
docker build -t students-web:latest ./students-web
echo "Imagens carregadas com sucesso"
echo "Fazendo deploy com Helm"
helm upgrade --install students ./students-chart

echo "Acessar versão web com http://k8s.local"

echo "Verificando o status dos pods"
kubectl get pods

echo "Para rodar a versão terminal, execute o comando: kubectl exec -it <nome do pod terminal> -- /bin/bash"
echo "Rodar a aplicação com o comando: python main.py"
