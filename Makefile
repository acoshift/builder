default:
	docker build --pull -t acoshift/builder .
	docker push acoshift/builder
