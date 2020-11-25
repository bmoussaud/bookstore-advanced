

$(eval SHA1=$(shell git rev-parse --short HEAD))
DB_VERSION="1.0.0-$(SHA1)"

database:
	cd database
	export DB_VERSION="1.0.0-$(SHA1)"
	docker build . --tag bmoussaud/bookstore-advanced-database:$DB_VERSION --build-arg version=$DB_VERSION
	docker tag bmoussaud/bookstore-advanced-database:$DB_VERSION registry.local:5000/bmoussaud/bookstore-advanced-database:$DB_VERSION
	docker push registry.local:5000/bmoussaud/bookstore-advanced-database:$DB_VERSION
	cd -

web:
	mvn package -B -Dcontainer.image.name="bmoussaud/bookstore-advanced" -Dcontainer.image.registry="registry.local:5000" -Dsha1="-${SHA1}"
	sed "s/SHA1/${SHA1}/g" kubernetes/bookstore-deployment.yml > kubernetes/bookstore-deployment-SHA1.yml
	echo "version=1.0.0-${SHA1}" > xebialabs/values.xlvals

exportci:
	./xlw --config config.yaml generate xl-deploy -s -p Configuration -f xebialabs/configuration.yaml
	./xlw --config config.yaml generate xl-deploy -s -p Applications -f xebialabs/applications.yaml
	./xlw --config config.yaml generate xl-deploy -s -p Infrastructure -f xebialabs/infrastructure.yaml
	./xlw --config config.yaml generate xl-deploy -s -p Environments -f xebialabs/environments.yaml

importci:
	./xlw --config config.yaml apply -s -p -f xebialabs.yaml

deploy: web importci
	 ./xlw apply -s -p -f xebialabs/deployment.yaml
