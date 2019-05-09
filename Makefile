
VER=v0.1.0

redeploy:
	helm delete --purge moja-sim || echo 'already deleted'
	cd ./simulator/helm_chart/simulators && helm package .
	helm install --name=moja-sim --namespace=mojaloop ./simulator/helm_chart/simulators/simulators-4.2.0.tgz


docker-build:
	cd simulator && docker build -t ldaly/ml-simulator:${VER} .

docker-push:
	docker push ldaly/ml-simulator:${VER}

docker:
	@make docker-build docker-push